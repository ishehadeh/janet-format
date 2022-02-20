(use /format/decimal /test-util)
(def s-format-decimal-fixed (wrap-formatter format-decimal-fixed))

(assert= (s-format-decimal-fixed (dec 0 0) {}) "0")
(assert= (s-format-decimal-fixed (dec 0 -307) {}) "0")
(assert= (s-format-decimal-fixed (dec 1 0) {}) "1")

(assert= (s-format-decimal-fixed (dec 31415 -4) {}) "3.1415")
(assert= (s-format-decimal-fixed (dec 1 -5) {}) "0.00001")
(assert= (s-format-decimal-fixed (dec 31415 3) {}) "31415000")
(assert= (s-format-decimal-fixed (dec 15 -24) {}) "0.000000000000000000000015")
(assert= (s-format-decimal-fixed (dec 51646 -1) {}) "5164.6")
