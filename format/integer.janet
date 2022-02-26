(use ./util)

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

  (def sign
    (let [neg (neg? integer)]
      (case sign
        :negative (if neg "-" "")
        :always (if neg "-" "+")
        :pad (if neg "-" " ")
        (errorf "unexpected sign spec %q, expected :negative, :always, or :pad" sign))))

  # fill is the character used to pad
  # num-pad: padding after the prefix, before the number
  # left-pad: padding to the left of the sign
  # right-pad: padding to the right of the number
  (def [fill num-pad left-pad right-pad]
    (if-let [{:width width :fill fill :numeric numeric :align align} pad
             padding (- width (length sign) (if (nil? prefix) 0 (length prefix)) (length scratch-buffer))]
      (if numeric
        [(chr "0") padding 0 0]

        (case align
          :left [fill 0 0 padding]
          :right [fill 0 padding 0]
          :center
          (let [l (math/ceil (/ padding 2))]
            [fill 0 l (- padding l)])))

      [nil 0 0 0]))

  (repeat left-pad
    (yield fill))

  (unless (zero? (length sign))
    (yield sign))

  (unless (nil? prefix)
    (yield prefix))

  (repeat num-pad
    (yield fill))

  (loop [i :down-to [(dec (length scratch-buffer)) 0]]
    (yield (scratch-buffer i)))

  (repeat right-pad
    (yield fill)))
