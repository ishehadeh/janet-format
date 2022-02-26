(use /format /format/util /test-util)
(def s-format-char (wrap-formatter format-char))

(assert= (s-format-char (chr "A") {:alternate true}) "A")
(assert= (s-format-char (chr "\xFF") {:alternate true}) "\\xff")
(assert= (s-format-char (chr "\n") {:alternate true}) "\\n")
