(use /format/string)
(use /format/string /test-util)
(def s-format-string (wrap-formatter format-string))

(assert= (s-format-string "hello" {}) "hello")
(assert= (s-format-string "hello\nworld" {}) "hello\nworld")
