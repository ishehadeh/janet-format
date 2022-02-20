(use /test-util /format/util)

(assert= (ascii? (chr "\n")) true)

(assert= (ascii? "\n") false)
(assert= (ascii? 256) false)
(assert= (ascii? 1.5) false)
