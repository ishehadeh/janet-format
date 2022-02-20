(use ./integer ./util)

(defn escaped-length [ str ]
  "Get the lenght of str if were escaped"
  (reduce |(+ $0 (char-escaped-length $1)) 0 str))

(defn format-string [ value { :alternate alternate :precision precision :pad pad }]
  (assert (string? value))

  (def value-length
    (min
      (if alternate
        (+ (escaped-length value) 2) # value will be surrounded in quotes and will be escaped in debug mode
        (length value))
      precision))
  
  (def [pad-l pad-r pad-char]
    (if-let [ { :width width :align align :fill fill } pad
              padding-needed (- width value-length) ]
      (do
        (default align :right)
        (default fill (chr " "))
        (case align
          :right [padding-needed 0 fill]
          :left [0 padding-needed fill]
          :center (let [h (/ padding-needed 2)] [(math/floor h) (math/ceil h) fill])))
      [0 0 nil]))

  (repeat pad-l (yield pad-char))

  (if (not alternate)
    # emit character by character to avoid copying the string when slicing
    (for i 0 value-length (yield (value i)))

    (do
      (var written 2) # the two quotes will always be written
      (yield (chr "\""))

      (loop [ data :in (coro (generate-escaped value))]
        (def len
          (case (type data)
            :string (length data)
            :number 1
            (errorf "expected character-code or string, got %q (%q)" data (type data))))
        (when (> (+ written len) value-length)
          (break))
        (yield data)
        (+= written len))

      (yield (chr "\""))))

    (repeat pad-r (yield pad-char)))