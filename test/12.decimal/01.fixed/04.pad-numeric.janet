(use /format/decimal /test-util)
(def s-format-decimal (wrap-formatter format-decimal-fixed))

(assert= (s-format-decimal (dec 31415 -4) {:pad {:numeric true :width 13 :align :right :fill (chr " ")}}) "00000003.1415")
(assert= (s-format-decimal (dec -31415 -4) {:pad {:numeric true :width 13 :align :right :fill (chr " ")}}) "-0000003.1415")
