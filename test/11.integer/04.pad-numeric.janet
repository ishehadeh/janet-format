(use /format/integer /test-util)
(def s-format-integer (wrap-formatter format-integer))

(assert= (s-format-integer -500 { :pad { :width 10 :align :right :fill " " :numeric true } }) "-000000500")
(assert= (s-format-integer -5 { :alternate true :number { :format :binary } :pad { :width 8 :align :right :fill " " :numeric true } }) "-0b00101")
