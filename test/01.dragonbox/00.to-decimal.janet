(import /build/dragonbox)
(use /test-util)

(assert= (dragonbox/to-decimal 0) [true (int/u64 0) -307])
(assert= (dragonbox/to-decimal 0.5e-100) [true (int/u64 5) -101])
(assert= (dragonbox/to-decimal 3.1415) [true (int/u64 31415) -4])
(assert= (dragonbox/to-decimal 314150000) [true (int/u64 31415) 4])

(assert= (dragonbox/to-decimal -1) [false (int/u64 1) 0])
