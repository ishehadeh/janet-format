(use /format/integer /test-util)
(def s-format-integer (wrap-formatter format-integer))

(assert= (s-format-integer 0 {}) "0")
(assert= (s-format-integer 913 {}) "913")
(assert= (s-format-integer -13 {}) "-13")

(assert= (s-format-integer 0xff1e { :number { :format :hex } }) "ff1e")
(assert= (s-format-integer 100 { :number { :format :decimal } }) "100")
(assert= (s-format-integer 9 { :number { :format :octal } }) "11")
(assert= (s-format-integer 5 { :number { :format :binary } }) "101")


#
(assert= (s-format-integer -5 { :number { :format :binary } :pad { :width 10 :align :right :fill " " } :alternate true }) "    -0b101")
(assert= (s-format-integer -500 { :width 3 :align :right :fill " " }) "-500")
(assert= (s-format-integer -11 { :alternate true :pad { :width 7 :align :right :fill " " } :number { :format :octal } }) "  -0o13")
