(use /format/decimal /test-util)
(def s-format-decimal (wrap-formatter format-decimal-scientific))

(def n (dec 31415 -4))
(assert= (s-format-decimal n {:pad {:width 13 :align :right :fill (chr " ")}}) "   3.1415e+00")
(assert= (s-format-decimal n {:pad {:width 13 :align :right :fill (chr "-")}}) "---3.1415e+00")
(assert= (s-format-decimal n {:pad {:width 13 :align :left :fill (chr " ")}}) "3.1415e+00   ")
(assert= (s-format-decimal n {:pad {:width 17 :align :center :fill (chr " ")}}) "   3.1415e+00    ")
(assert= (s-format-decimal n {:pad {:width 17 :align :center :fill (chr "-")}}) "---3.1415e+00----")

# pad with sign
(assert= (s-format-decimal (dec -1 0) {:number {:sign :negative} :pad {:width 8 :align :right :fill (chr " ")}}) "  -1e+00")
