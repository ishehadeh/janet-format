(use /format)
(use /test-util)

# Special values formatting
(assert= (format "{}" math/inf) "inf")
(assert= (format "{}" math/-inf) "-inf")
(assert= (format "{}" math/nan) "nan")

(assert= (format "{:10}" math/inf) "       inf")
(assert= (format "{:10}" math/-inf) "      -inf")
(assert= (format "{:10}" math/nan) "       nan")

# Sign formatting
(assert= (format "{:-}" math/-inf) "-inf")
(assert= (format "{: }" math/inf) " inf")
(assert= (format "{:+}" math/inf) "+inf")

# Default Formatting (should be :general)
(assert= (format "{}" 3001.5) "3001.5")
(assert= (format "{}" .0000003) "3e-07")

# fixed point number formatting
(assert= (format "{:f}" 3.1) "3.1")
(assert= (format "{:f}" 3.1) "3.1")
(assert= (format "{:.5f}" 3.1) "3.10000")
(assert= (format "{:+f}" 2.75) "+2.75")
(assert= (format "{: f}" 0) " 0")
(assert= (format "{:+06f}" 2.75) "+02.75")

# scientific notation number formatting
(assert= (format "{:e}" 3001.5) "3.0015e+03")

# general notation
(assert= (format "{:g}" 3001.5) "3001.5")
(assert= (format "{:g}" 30000000) "3e+07")
