(use /test-util /format/util)

(assert= (char-escaped-length (chr "a")) 1)
(assert= (char-escaped-length (chr "\n")) 2)
(assert= (char-escaped-length (chr "\"")) 2)
(assert= (char-escaped-length (chr "\xDD")) 4)
