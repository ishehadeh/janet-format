(use ./util ./padding)

(setdyn :doc "Routines for formatting integers")

(defn format-integer [integer {:pad pad :precision precision :alternate include-prefix :number {:format format :uppercase uppercase :sign sign}}]
  "stringify an integer and append it to a buffer"
  (default sign :negative)
  (default uppercase false)
  (default include-prefix false)

  (assert (int? integer))

  (def radix
    (case format
      nil 10
      :binary 2
      :octal 8
      :decimal 10
      :hex 16
      (errorf "cannot format integer as %q" format)))

  (def scratch-buffer
    "buffer to hold the digits, this will be copied into the output buffer backwards"
    (buffer/new 10)) # TODO: the size should be adjusted based on radix

  (var remaining-digits (math/abs integer))
  (forever
    (def digit (% remaining-digits radix))
    (buffer/push-byte scratch-buffer (digit-to-char digit))
    (set remaining-digits (/ (- remaining-digits digit) radix))

    (when (= remaining-digits 0)
      (break)))

  (def prefix
    (when include-prefix
      (case radix
        2 (if uppercase "0B" "0b")
        8 (if uppercase "0O" "0o")
        10 nil
        16 (if uppercase "0X" "0x"))))

  (def sign (sign-char (neg? integer) sign))
  (def output-length (+
                       (if sign 1 0)
                       (if prefix (length prefix) 0)
                       (length scratch-buffer)))
  (pad-around output-length pad
              (do
                (when sign (yield sign))
                (when prefix (yield prefix)))

              (loop [i :down-to [(dec (length scratch-buffer)) 0]]
                (yield (scratch-buffer i)))))
