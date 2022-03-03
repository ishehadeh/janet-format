(use /format/decimal /test-util)
(def s-format-decimal-scientific (wrap-formatter format-decimal-scientific))

(assert= (s-format-decimal-scientific (dec 31 -4) {:number {:sign :pad}}) " 3.1e-03")
(assert= (s-format-decimal-scientific (dec 31 -4) {:number {:sign :always}}) "+3.1e-03")
(assert= (s-format-decimal-scientific (dec 31 -4) {:number {:sign :negative}}) "3.1e-03")

(assert= (s-format-decimal-scientific (dec -31 -4) {:number {:sign :pad}}) "-3.1e-03")
(assert= (s-format-decimal-scientific (dec -31 -4) {:number {:sign :always}}) "-3.1e-03")
(assert= (s-format-decimal-scientific (dec -31 -4) {:number {:sign :negative}}) "-3.1e-03")
