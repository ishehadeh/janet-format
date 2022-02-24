(use /format/string /test-util)
(def s-format-string (wrap-formatter format-string))

(assert= (s-format-string "1" {:precision 5}) "1")
(assert= (s-format-string "hello world" {:precision 5}) "hello")
(assert= (s-format-string "hello world" {:precision 5 :pad {:width 10 :align :right}}) "     hello")
(assert= (s-format-string "hello world" {:precision 5 :pad {:width 10 :align :left}}) "hello     ")
(assert= (s-format-string "hello world" {:precision 5 :pad {:width 10 :align :center}}) "  hello   ")
(assert= (s-format-string "hello world" {:precision 5 :pad {:width 10 :align :center :fill "-"}}) "--hello---")

(assert= (s-format-string "hi" {:precision 6 :alternate true}) "\"hi\"")
(assert= (s-format-string "hello" {:precision 6 :alternate true}) "\"hell\"")
(assert= (s-format-string "hel\x7f" {:precision 6 :alternate true}) "\"hel\"")
