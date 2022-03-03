(use /format/decimal /test-util)
(def s-format-decimal (wrap-formatter format-decimal-scientific))

(assert= (s-format-decimal (dec 31415 -4) {:pad {:numeric true :width 13 :align :right :fill (chr " ")}}) "0003.1415e+00")
(assert= (s-format-decimal (dec -31415 -4) {:pad {:numeric true :width 13 :align :right :fill (chr " ")}}) "-003.1415e+00")
