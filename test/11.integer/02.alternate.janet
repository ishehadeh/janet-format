(use /format/integer /test-util)
(def s-format-integer (wrap-formatter format-integer))

(assert= (s-format-integer 5 { :alternate true :number { :format :binary } }) "0b101")
(assert= (s-format-integer 11 { :alternate true :number { :format :octal } }) "0o13")
(assert= (s-format-integer 0xff { :alternate true :number { :format :hex } }) "0xff")
(assert= (s-format-integer 5 { :alternate true :number { :format :decimal } }) "5")

(assert= (s-format-integer -5 { :alternate true :number { :format :binary } }) "-0b101")
(assert= (s-format-integer -11 { :alternate true :number { :format :octal } }) "-0o13")
(assert= (s-format-integer -0xff { :alternate true :number { :format :hex } }) "-0xff")
(assert= (s-format-integer -5 { :alternate true :number { :format :decimal } }) "-5")
