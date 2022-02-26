(use /format /format/util /test-util)
(def s-format-char (wrap-formatter format-char))

(assert= (s-format-char (chr "A") {}) "A")
(assert= (s-format-char (chr "\xFF") {}) "\xFF")
(assert= (s-format-char (chr "\n") {}) "\n")
