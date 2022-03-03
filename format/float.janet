(import dragonbox)
(use ./decimal ./util)

(defn format-float [num spec]
  (if (nan? num)
    (yield (if (spec :uppercase) "NAN" "nan"))

    (do
      (if-let [sign (sign-char (neg? num) ((spec :number) :sign))]
        (yield sign))

      (if (= (math/abs num) math/inf)
        (yield (if (spec :uppercase) "INF" "inf"))
        (let [{:number {:format f}} spec
              parts (dragonbox/to-decimal num)]
          (default f :general)
          (case f
            :fixed (format-decimal-fixed parts spec)
            :exponent (format-decimal-scientific parts spec)
            :general (format-decimal-general parts spec)
            (errorf "unknown float format %q" f)))))))
