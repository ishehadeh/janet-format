(use /format/string /test-util)
(def s-format-string (wrap-formatter format-string))

(assert= (s-format-string "hello world" { :pad { :width 13 } }) "  hello world")
(assert= (s-format-string "hello world" { :pad { :width 13 :align :right } }) "  hello world")
(assert= (s-format-string "hello world" { :pad { :width 13 :align :left } }) "hello world  ")
(assert= (s-format-string "hello world" { :pad { :width 13 :align :center } }) " hello world ")
(assert= (s-format-string "hello world" { :pad { :width 13 :align :center :fill "-" } }) "-hello world-")
