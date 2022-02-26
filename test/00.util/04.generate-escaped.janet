(use /test-util /format/util)

(defn esc [c]
  (def escaped @"")
  (loop [x :in (coro (generate-escaped c))]
    (buffer/push escaped x))
  (string escaped))

(assert= (esc (chr "a")) "a")
(assert= (esc (chr "\n")) "\\n")
(assert= (esc 255) "\\xff")
