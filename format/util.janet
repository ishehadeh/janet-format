(defn ascii?
  "checks if c is an ascii character code"

  [c]
  (and (int? c) (<= c 0xFF) (>= c 0)))

(defn includes?
  "Returns true if needle is a value in the indexed structure ind"

  [needle ind]
  (not (nil? (find-index |(= needle $) ind))))

(defmacro u64
  "Create a new u64 value from a string or number at load time."

  [source]
  (int/u64 source))

(defmacro u64?
  "Returns true if `val` is a u64"

  [val]
  ~(= (type ,val) :core/u64))

(defmacro- expand-char-ranges
  "takes a series of tuples [start, end] where start and end are 1-character strings,
expands them to [start, start + 1, start + 2, ..., end] and concatanates them."

  [& ranges]
  (def numbers @[])

  (loop [[start end] :in ranges]
    (loop [x :range-to [(start 0) (end 0)]]
      (array/push numbers x)))

  (tuple/brackets ;numbers))

(defn digit-to-char
  "Convert a single digit to a character. Lowercase alphabet used by default."

  [digit &keys {:uppercase uppercase}]
  (assert (int? digit))
  (default uppercase false)

  (if uppercase
    ((expand-char-ranges ["0" "9"] ["A" "Z"]) digit)
    ((expand-char-ranges ["0" "9"] ["a" "z"]) digit)))

(defn char-escaped-length [c]
  "length of the escape code for a character"
  (assert (ascii? c))

  (cond
    (includes? c "\"\n\r\0\f\v\e\\\t")
    2 # backslash-character escape code (e.g. \n, see above)

    (or (< c 32) (> c 126))
    4 # ascii hex code (e.g. \x00)

    # no escape needed
    1))

(defn generate-escaped
  "Generator that yields an escaped version of a character `c`, replacing special characters with \\<code>"

  [c]
  (assert (ascii? c))

  (case c
    (chr "\"") (yield "\\\"")
    (chr "\n") (yield "\\n")
    (chr "\r") (yield "\\r")
    (chr "\0") (yield "\\0")
    (chr "\f") (yield "\\f")
    (chr "\v") (yield "\\v")
    (chr "\e") (yield "\\e")
    (chr "\\") (yield "\\\\")
    (chr "\t") (yield "\\t")
    (if (or (< c 32) (> c 126))
      (do
        (yield "\\x")
        (yield (digit-to-char (band (brshift c 4) 0xF)))
        (yield (digit-to-char (band c 0xF))))

      (yield c))))
