(use /format/decimal /test-util)
(def s-format-decimal-scientific (wrap-formatter format-decimal-scientific))

(assert= (s-format-decimal-scientific (dec 1 3) { :alternate true }) "1.e+03")