(use ./integer ./util ./padding)

(defn escaped-length [str]
  "Get the lenght of str if were escaped"
  (reduce |(+ $0 (char-escaped-length $1)) 0 str))

(defn format-string [value {:alternate alternate :precision precision :pad pad}]
  (assert (string? value))

  (def value-length
    (min
      (if alternate
        (+ (escaped-length value) 2) # value will be surrounded in quotes and will be escaped in debug mode
        (length value))
      precision))

  (pad-around value-length pad
              (if (not alternate)
                (for i 0 value-length (yield (value i)))

                (do
                  (var written 2) # the two quotes will always be written
                  (yield (chr "\""))
                  (loop [c :in value
                         :before (+= written (char-escaped-length c))
                         :while (or (nil? precision) (<= written precision))]
                    (generate-escaped c))
                  (yield (chr "\""))))))
