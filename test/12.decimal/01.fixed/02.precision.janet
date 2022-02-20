(use /format/decimal /test-util)
(def s-format-decimal-fixed (wrap-formatter format-decimal-fixed))

(assert= (s-format-decimal-fixed (dec 51646 -1) { :precision 3 }) "5164.600")
(assert= (s-format-decimal-fixed (dec 51646 -1) { :precision 0 }) "5164")
(assert= (s-format-decimal-fixed (dec 51646 -2) { :precision 1 }) "516.4")
(assert= (s-format-decimal-fixed (dec 51646 -3) { :precision 2 }) "51.64")
(assert= (s-format-decimal-fixed (dec 1000006 -5) { :precision 4 }) "10.0000")
(assert= (s-format-decimal-fixed (dec 1000004 -5) { :precision 4 }) "10.0000")