(use /format/string /test-util)
(def s-format-string (wrap-formatter format-string))

(assert= (s-format-string "hello" {:alternate true}) "\"hello\"")
(assert= (s-format-string "\n\n\x7f" {:alternate true}) "\"\\n\\n\\x7f\"")
