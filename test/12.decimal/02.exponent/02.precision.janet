(use /format/decimal /test-util)
(def s-format-decimal-scientific (wrap-formatter format-decimal-scientific))

(assert= (s-format-decimal-scientific (dec 45142 -1) {:precision 4 :number {:uppercase true}}) "4.5142E+03")
(assert= (s-format-decimal-scientific (dec 45142 -1) {:precision 4}) "4.5142e+03")
