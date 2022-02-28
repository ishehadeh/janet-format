(use ./float ./string ./integer ./util ./padding)

(def- format-grammar
  ~{:symchars (+ (range "09" "AZ" "az" "\x80\xFF") (set "!$%&*+-./<?=>@^_")) # TODO this should include ":" but thats a special character in the syntax...
    :symbol (some :symchars)

    # reference to a local variable, keyword arg or normal argument
    :argument (+ (/ (<- :d+) ,scan-number) (/ (<- :symbol) ,symbol))

    # A count can be a reference to an argument where the count is stored or a number
    # this pattern will always have two captures, first a label followed by a value:
    # - :reference {index|symbol}
    # - :literal {int}
    :count (+
             (* (constant :reference) "{" :argument "}")
             (* (constant :literal) (/ (<- :d+) ,scan-number)))

    # Matches an optional fill character followed by either <, ^, or >
    # This pattern returns has two captures:
    # 1. the fill character (int32 or nil)
    # 2. the direction, either `:left`, `:center` or `:right`
    :align (*
             (/ (<- (opt (if (look 1 (set "<^>")) (range "\x00\xFF")))) ,|(if (= $ "") nil ($ 0))) # the fill character, optional can be nil
             (/ (<- (set "<^>")) ,|(case $ "<" :left "^" :center ">" :right)))

    :spec (*
            (group (opt :align)) # alignment + fill character
            # TODO implement space
            (/ (<- (opt (set "+- "))) ,|(case $ "+" :always "-" :negative " " :pad nil)) # "+" means always print sign, "-" is the same as default behavior, " " means pad with space
            (/ (<- (opt "#")) ,(partial = "#")) # alternate form
            (/ (<- (opt "0")) ,(partial = "0")) # numeric pad (sign aware + pad with zeroes)
            (group (opt :count)) # width
            (group (opt (* "." # precision
                           (+ (* "*" (constant :adjacent)) # indicates the param following the value is the precision
                              :count))))
            (<- (opt (set "fFgGeEbBoOdxXc"))))

    :binding (* "{" (group (* (+ :argument (* (constant nil) "")) (opt (* ":" :spec)))) "}")
    :main (any (+ (/ (<- "{{") "{")
                  (/ (<- "}}") "}")
                  :binding
                  (<- (to "{"))
                  (<- (some 1))))})

(def default-format-spec
  {:precision nil
   :pad nil
   :alternate false
   :number {:sign :negative
            :uppercase false
            :format nil}})

(defn parse-format-string [str]
  (peg/match format-grammar str))

# forward declare
(var format-any nil)

(defn indent-formatter
  ``adapter that runs formatter `fmt`, yielding `indent` before the next character after a newline

Example: `(indent-formatter |(compile "{:#}" [1 2 3]) "--")`
--(
--  1
--  2
--  3
--)
``
  [fmt indent]
  (var should-indent true)
  (loop [chars :in (fiber/new fmt :yi)]
    (when should-indent
      (yield indent)
      (set should-indent false))

    (if (= chars (chr "\n"))
      (do # if this is a single newline yield it an indent on new data
        (yield chars)
        (set should-indent true))

      (if-let [_ (or (string? chars) (buffer? chars)) # sneaking a normal condition into if-let
               ind (find-index (partial = (chr "\n")) chars)]
        (if (= ind (dec (length chars)))
          (do # if the last character of the string is the newline emit the string, and indent on new data
            (yield chars)
            (set should-indent true))
          (do # otherwise emit character by character through the newline (to avoid copy)
            # then indent and yield the rest of the string
            (loop [i :range-to [0 ind]]
              (yield (chars i)))
            (yield indent)
            (loop [i :range [(inc ind) (length chars)]]
              (yield (chars i)))))

        # forward the characters when no newline is found
        (yield chars)))))

(defn format-indexed
  ``Format an array or array-like data structure.
  Alternate Form: Each element is on a newline, indented with 2 spaces.
  Element Formatting: The spec is used to format each element
  Padding & Precision: Padding and precision are ignored for the array
``
  [value spec]
  (def sep (if (spec :alternate) (chr "\n") (chr " ")))
  (def [delim-left delim-right]
    (case (type value)
      :tuple
      (case (tuple/type value)
        :brackets ["[" "]"]
        :parens ["(" ")"]
        (errorf "unknown tuple-type %q, value %q" (tuple/type value) value))

      :array
      ["@[" "]"]

      (errorf "expected an array or tuple got %q (%q)" value (type value))))

  (yield delim-left)

  (defn elements []
    (loop [x :in value]
      (yield sep)
      (format-any x spec)))

  (if (spec :alternate)
    (indent-formatter elements "  ")
    (elements))

  (yield sep)
  (yield delim-right))

(defn format-associative [value spec]
  (def sep (if (spec :alternate) (chr "\n") (chr " ")))
  (def kv-sep (chr " "))

  (when (table? value)
    (yield (chr "@")))

  (yield (chr "{"))
  (yield sep)

  (defn elements []
    (loop [[k v] :pairs value]
      (format-any k spec)
      (yield kv-sep)
      (format-any v spec)
      (yield sep)))

  (if (spec :alternate)
    (indent-formatter elements "  ")
    (elements))

  (yield (chr "}")))


(defn format-char [char {:alternate alternate :pad pad}]
  # TODO: handle unicode characters
  (assert (ascii? char))

  # alternate means escape the char
  (def value-length
    (if alternate
      (char-escaped-length char)
      1))

  (pad-around value-length pad
              (if alternate
                (generate-escaped char)
                (yield char))))

(set format-any
     (fn [value spec]
       (case (type value)
         :nil (format-string "nil" (merge spec {:alternate false}))
         :boolean (format-string (if value "true" "false") (merge spec {:alternate false}))

         :keyword (format-string (string ":" value) (merge spec {:alternate false}))
         :symbol (format-string (string "'" value) (merge spec {:alternate false}))

         :string (format-string value spec)
         :buffer (format-string value spec)

         :number
         (case ((spec :number) :format)
           nil
           (if (int? value)
             (format-integer value spec)
             (format-float value spec))

           :char (format-char value spec)

           :binary (format-integer value spec)
           :octal (format-integer value spec)
           :decimal (format-integer value spec)
           :hex (format-integer value spec)

           :general (format-float value spec)
           :fixed (format-float value spec)
           :exponent (format-float value spec)

           (errorf "unknown format type: %q" ((spec :number) :format)))

         :array (format-indexed value spec)
         :tuple (format-indexed value spec)

         :struct (format-associative value spec)
         :table
         (if-let [proto (table/getproto value)
                  fmt (proto :fmt)]
           (fmt value spec)
           (format-associative value spec))

         :function (format-string (string value) (merge spec {:alternate false}))
         :cfunction (format-string (string value) (merge spec {:alternate false}))

         (if (spec :alternate)
           (format-string (string "<" (type value) " " value ">") (merge spec {:alternate false}))
           (format-string (string value) (merge spec {:debug false :alternate false}))))))

(defmacro compile
  ""

  [str & args]
  (assert (string? str))

  (var argn "default index if none is given, incremented every time its used" 0)
  (defn lookup-argument [&opt arg]
    ``returns either the positional argument `arg` if `arg` is a number or `arg` if arg is a symbol
      If arg is nil then positional argument `argn` is used, and `argn` is incremented.
    ``
    (case (type arg)
      :nil (let [n argn] (++ argn) (args n))
      :number (args arg)
      :symbol arg
      (errorf "failed to lookup argument '%q', expected a number, symbol or nil" arg)))

  (defn compile-count [count]
    "compile the output of the :count pattern"
    (match count
      @[:literal x] x
      @[:reference arg] (lookup-argument arg)
      @[] nil
      (errorf "compile-count: unexpected input %q, expected @[:literal _], @[:reference _] or @[]" count)))

  (var generators @[])
  (loop [item :in (peg/match format-grammar str)]
    (if (string? item)
      (array/push generators ~(,yield ,item))
      (let [@[arg align sign hash zero width-count prec-count type] item]
        (def pad-spec
          (if-not (empty? (or width-count @[]))
            {:width (compile-count width-count)
             :align (if (empty? align) :right (align 1))
             :fill (or (unless (empty? align) (align 0)) (chr " "))
             :numeric zero}

            (unless (empty? (or align @[]))
              (errorf "%q: alignment included in format spec without width" str))))

        (def spec
          {:precision (unless (nil? prec-count) (compile-count prec-count))
           :pad pad-spec
           :alternate (and hash)
           :number {:sign (or sign :negative)
                    :uppercase (includes? type "FGEXOB")
                    :format (case type
                              "c" :char
                              "x" :hex "X" :hex
                              "d" :decimal
                              "o" :octal "O" :octal
                              "b" :binary "B" :binary
                              "f" :fixed "F" :fixed
                              "e" :exponent "E" :exponent
                              "g" :general "G" :general
                              nil)}})
        (array/push generators ~(,format-any ,(lookup-argument arg) ,spec)))))

  ~(do ,;generators))

(defmacro buffer-formatter
  [fmt &opt buf]
  (if (nil? buf)
    (with-syms [buf]
      ~(let [,buf @""]
         ,(buffer-formatter fmt buf)))

    (with-syms [chars]
      ~(do
         (loop [,chars :in (coro ,fmt)]
           (buffer/push ,buf ,chars))
         ,buf))))

(defmacro format
  [str & args]
  ~(string (as-macro ,buffer-formatter (as-macro ,compile ,str ,;args))))

(defmacro fprint [str & args]
  ~(print (as-macro ,format ,str ,;args)))
