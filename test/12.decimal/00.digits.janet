(use /format/decimal /format/util)
(use /test-util)

(defmacro num-round-significant-digits [ s f ] ~(,u64-round-significant-digits (int/u64 ,s) ,f))
(defmacro num-count-significant-digits [ s ] ~(,u64-count-significant-digits ,(int/u64 s)))

(assert= (u64-count-digits (u64 1000)) 4)
(assert= (u64-count-digits (u64 1)) 1)
(assert= (u64-count-digits (u64 10)) 2)


(assert= (num-count-significant-digits 132) 3)
(assert= (num-count-significant-digits 123000) 3)
(assert= (num-count-significant-digits 10003) 5)

(assert= (num-round-significant-digits 132 2) (u64 130))
(assert= (num-round-significant-digits 132 1) (u64 100))
(assert= (num-round-significant-digits 13200 1) (u64 10000))

(assert= (num-round-significant-digits 136 2) (u64 140))
(assert= (num-round-significant-digits 156 1) (u64 200))
(assert= (num-round-significant-digits 15200 1) (u64 20000))

(assert= (num-round-significant-digits 50053000 3) (u64 50100000))
