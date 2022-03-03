(import dragonbox)
(use ./decimal ./util ./padding)

(defn format-float [num spec]
  (if (nan? num)
    (pad-around 3 (spec :pad)
                (yield (if (spec :uppercase) "NAN" "nan")))

    (if (= (math/abs num) math/inf)
      (do
        (def sign (sign-char (neg? num) ((spec :number) :sign)))
        (pad-around (+ (if sign 1 0) 3) (spec :pad)
                    (do
                      (when sign (yield sign))
                      (yield (if (spec :uppercase) "INF" "inf")))))

      (let [{:number {:format f}} spec
            parts (dragonbox/to-decimal num)]
        (default f :general)
        (case f
          :fixed (format-decimal-fixed parts spec)
          :exponent (format-decimal-scientific parts spec)
          :general (format-decimal-general parts spec)
          (errorf "unknown float format %q" f))))))
