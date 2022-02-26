(use /format/string /test-util)
(def s-format-string (wrap-formatter format-string))

(assert= (s-format-string "hello world" {:pad {:width 13 :align :right :fill (chr " ")}}) "  hello world")
(assert= (s-format-string "hello world" {:pad {:width 13 :align :right :fill (chr " ")}}) "  hello world")
(assert= (s-format-string "hello world" {:pad {:width 13 :align :left :fill (chr " ")}}) "hello world  ")
(assert= (s-format-string "hello world" {:pad {:width 13 :align :center :fill (chr " ")}}) " hello world ")
(assert= (s-format-string "hello world" {:pad {:width 13 :align :center :fill (chr "-")}}) "-hello world-")
