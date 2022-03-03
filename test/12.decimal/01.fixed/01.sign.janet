(use /format/decimal /test-util)
(def s-format-decimal (wrap-formatter format-decimal-fixed))

(assert= (s-format-decimal (dec 1 0) {:number {:sign :pad}}) " 1")
(assert= (s-format-decimal (dec 31 -1) {:number {:sign :always}}) "+3.1")
(assert= (s-format-decimal (dec 31 -1) {:number {:sign :negative}}) "3.1")

(assert= (s-format-decimal (dec -31 -1) {:number {:sign :pad}}) "-3.1")
(assert= (s-format-decimal (dec -31 -1) {:number {:sign :always}}) "-3.1")
(assert= (s-format-decimal (dec -31 -1) {:number {:sign :negative}}) "-3.1")
