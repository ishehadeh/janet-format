(use /test-util /format/util)

(assert= (digit-to-char 3) (chr "3"))
(assert= (digit-to-char 15) (chr "f"))
(assert= (digit-to-char 35) (chr "z"))
(assert= (digit-to-char 0 :uppercase true) (chr "0"))
(assert= (digit-to-char 15 :uppercase true) (chr "F"))
(assert= (digit-to-char 35 :uppercase true) (chr "Z"))