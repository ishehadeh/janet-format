(use /format)
(use /test-util)


(assert= (format "{:x}" 15) "f")
(assert= (format "{:d}" 15) "15")
(assert= (format "{:o}" 15) "17")
(assert= (format "{:b}" 15) "1111")

(assert= (format "{:^20}" 15) "         15         ")
(assert= (format "{:5}{:5}" 1 2) "    1    2")
