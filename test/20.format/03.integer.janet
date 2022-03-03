(use /format)
(use /test-util)


(assert= (format "{:x}" 15) "f")
(assert= (format "{:d}" 15) "15")
(assert= (format "{:o}" 15) "17")
(assert= (format "{:b}" 15) "1111")

(assert= (format "{:X}" 15) "F")
(assert= (format "{:#X}" 15) "0XF")
(assert= (format "{:#O}" 15) "0O17")
(assert= (format "{:#B}" 15) "0B1111")

(assert= (format "{:^20}" 15) "         15         ")
(assert= (format "{:5}{:5}" 1 2) "    1    2")
