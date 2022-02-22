(use /format/decimal /test-util)
(def s-format-decimal-general (wrap-formatter format-decimal-general))

(assert= (s-format-decimal-general (dec 30015 -1) {}) "3001.5")
