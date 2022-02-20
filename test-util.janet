(import /format)

(defmacro assert=
  "throw an error if deep= is false for x and y."
  [value expect]
  (with-syms [$value $expect]
    ~(let [,$expect ,expect
           ,$value ,value]
        (unless (deep= ,$value ,$expect)
          (errorf "assert failed: %q != %q\n  Expect: %q\n  Result: %q" ',value ',expect ,$expect ,$value)))))

(defmacro wrap-formatter
  "wrap a formatter function, collecting its output in a string, also makes merges spec with `format/default-format-spec` and prints errors with more context"

  [ generator ]
  (def buf (gensym))
  (def fib (gensym))
  ~(fn [ value spec ]
      (let [  ,fib (fiber/new
                    |(,generator value (merge ,format/default-format-spec spec))
                    :yei)
              ,buf @"" ]
        (loop [ c :in ,fib]
          (,buffer/push ,buf c))
        (when (= (fiber/status ,fib) :error)
          (printf "formatter error: value=%q, spec=%q, %q" value spec (fiber/last-value ,fib))
          (debug/stacktrace ,fib)
          (os/exit 1))

        (string ,buf))))

(defn dec
  "construct a new decimal number"
  [ significand exponent ]
  (assert (int? exponent))
  [(int/u64 significand) exponent])