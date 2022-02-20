(import dragonbox)
(use ./decimal)

(defn format-float [ num spec ]
  (if (nan? num)
    (yield (if (spec :uppercase) "NAN" "nan"))

    (do
      (yield
        (let [ neg (neg? num)
               sign (get (get spec :number {}) :sign :negative) ]
          (case sign
            :negative (if neg "-" "")
            :always (if neg "-" "+")
            :pad (if neg "-" " ")
            (errorf "expected sign specified %q, expected :negative, :always, or :pad" sign))))

        (if (= (math/abs num) math/inf)
          (yield (if (spec :uppercase) "INF" "inf"))
          (let [ { :number { :format f } } spec
                parts (dragonbox/to-decimal num) ]
            (default f :general)
            (case f
              :fixed (format-decimal-fixed parts spec)
              :exponent (format-decimal-scientific parts spec)
              :general (format-decimal-general parts spec)
              (errorf "unknown float format %q" f)))))))