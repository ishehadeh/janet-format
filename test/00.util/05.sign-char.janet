(use /test-util /format/util)

(assert= (sign-char (neg? 0) :negative) nil)
(assert= (sign-char (neg? 1) :negative) nil)

(assert= (sign-char (neg? -1) :negative) (chr "-"))
(assert= (sign-char (neg? -1) :always) (chr "-"))
(assert= (sign-char (neg? -1) :pad) (chr "-"))

(assert= (sign-char (neg? 1) :pad) (chr " "))
(assert= (sign-char (neg? 1) :always) (chr "+"))
