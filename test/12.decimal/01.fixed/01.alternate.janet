(use /format/decimal /test-util)
(def s-format-decimal-fixed (wrap-formatter format-decimal-fixed))

(assert= (s-format-decimal-fixed (dec 1 0) { :alternate true }) "1.")
(assert= (s-format-decimal-fixed (dec 123 3) { :alternate true }) "123000.")

(assert= (s-format-decimal-fixed (dec 1 -3) { :alternate true }) "0.001")