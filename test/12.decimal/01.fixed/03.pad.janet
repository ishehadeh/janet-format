(use /format/decimal /test-util)
(def s-format-decimal (wrap-formatter format-decimal-fixed))

(def n (dec 31415 -4))
(assert= (s-format-decimal n {:pad {:width 13 :align :right :fill (chr " ")}}) "       3.1415")
(assert= (s-format-decimal n {:pad {:width 13 :align :right :fill (chr "-")}}) "-------3.1415")
(assert= (s-format-decimal n {:pad {:width 13 :align :left :fill (chr " ")}}) "3.1415       ")
(assert= (s-format-decimal n {:pad {:width 13 :align :center :fill (chr " ")}}) "   3.1415    ")
(assert= (s-format-decimal n {:pad {:width 13 :align :center :fill (chr "-")}}) "---3.1415----")

# pad with sign
(assert= (s-format-decimal (dec -1 0) {:number {:sign :negative} :pad {:width 6 :align :right :fill (chr " ")}}) "    -1")
