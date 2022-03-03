(use /format/decimal /test-util)
(def s-format-decimal-scientific (wrap-formatter format-decimal-scientific))

(assert= (s-format-decimal-scientific (dec 1 3) {}) "1e+03")
(assert= (s-format-decimal-scientific (dec 158751 -10) {}) "1.58751e-05")

(assert= (s-format-decimal-scientific (dec -1 3) {}) "-1e+03")
(assert= (s-format-decimal-scientific (dec -158751 -10) {}) "-1.58751e-05")
