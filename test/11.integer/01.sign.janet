(use /format/integer /test-util)
(def s-format-integer (wrap-formatter format-integer))

(assert= (s-format-integer 1 { :number { :sign :pad } }) " 1")
(assert= (s-format-integer 3 { :number { :sign :always } }) "+3")
(assert= (s-format-integer 3 { :number { :sign :negative } }) "3")

(assert= (s-format-integer -3 { :number { :sign :pad } }) "-3")
(assert= (s-format-integer -3 { :number { :sign :always } }) "-3")
(assert= (s-format-integer -3 { :number { :sign :negative } }) "-3")