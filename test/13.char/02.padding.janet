(use /format /format/util /test-util)
(def s-format-char (wrap-formatter format-char))

(assert= (s-format-char (chr "A") {:pad {:fill (chr " ") :width 5 :align :right}}) "    A")
(assert= (s-format-char (chr "A") {:pad {:fill (chr " ") :width 5 :align :center}}) "  A  ")
(assert= (s-format-char (chr "A") {:pad {:fill (chr " ") :width 5 :align :left}}) "A    ")

(assert= (s-format-char (chr "A") {:pad {:fill (chr " ") :width 6 :align :center}}) "  A   ")

(assert= (s-format-char (chr "\n") {:alternate true}) "\\n")
(assert= (s-format-char (chr "\n") {:alternate true :pad {:fill (chr " ") :width 5 :align :right}}) "   \\n")
(assert= (s-format-char (chr "\n") {:alternate true :pad {:fill (chr " ") :width 5 :align :center}}) " \\n  ")
(assert= (s-format-char (chr "\n") {:alternate true :pad {:fill (chr " ") :width 5 :align :left}}) "\\n   ")
