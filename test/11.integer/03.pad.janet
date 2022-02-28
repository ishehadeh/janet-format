(use /format/integer /test-util)
(def s-format-integer (wrap-formatter format-integer))

(assert= (s-format-integer 31415 {:pad {:width 3 :align :right :fill " "}}) "31415")

(assert= (s-format-integer 5 {:pad {:width 10 :align :right :fill " "}}) "         5")
(assert= (s-format-integer 15 {:pad {:width 10 :align :right :fill " "}}) "        15")
(assert= (s-format-integer 15 {:pad {:width 10 :align :right :fill "+"}}) "++++++++15")

(assert= (s-format-integer 5 {:pad {:width 10 :align :left :fill " "}}) "5         ")
(assert= (s-format-integer 15 {:pad {:width 10 :align :left :fill " "}}) "15        ")
(assert= (s-format-integer 15 {:pad {:width 10 :align :left :fill "+"}}) "15++++++++")

(assert= (s-format-integer 5 {:pad {:width 10 :align :center :fill " "}}) "    5     ")
(assert= (s-format-integer 15 {:pad {:width 10 :align :center :fill " "}}) "    15    ")
(assert= (s-format-integer 15 {:pad {:width 10 :align :center :fill "+"}}) "++++15++++")

(assert= (s-format-integer -5 {:pad {:width 4 :align :center :fill " "}}) " -5 ")
(assert= (s-format-integer -500 {:width 3 :align :right :fill " "}) "-500")

(assert= (s-format-integer 255 {:number {:format :hex} :pad {:width 4 :align :center :fill " "} :alternate true}) "0xff")
