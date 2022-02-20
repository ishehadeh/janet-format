(import int-ext)
(use ./util)

# TODO padding

(def- u64-max (u64 "18446744073709551615"))
(defmacro- gen-u64-count-digits
  "Count the number digits in a u64, `val`, by generating a cond-table inline."
  [ val &keys { :magnitude return-magnitude } ]

  (def conditions @[])
  (var magnitude (u64 10))
  (var digits 2)
  (while (< magnitude (/ u64-max (u64 10)))
    # the result ("digits") is placed first and >= is used becuase `conditions` will be reversed before being emitted. 
    (array/push conditions (if return-magnitude magnitude digits) ~(>= ,val ,magnitude))

    (*= magnitude (u64 10))
    (+= digits 1))

    (array/push conditions digits ~(>= ,val ,magnitude))

  ~(cond ,;(reverse conditions) 1))

(defmacro- gen-u64-pow10-table
  "generate an tuple with the integer powers of 10, [1 10 100 (...) ] up to u64-max"
  [ ]

  (def powers @[])
  (var pow (u64 1))
  (repeat 20
    (array/push powers pow)
    (*= pow (u64 10)))

  (tuple/brackets ;powers))

(defn u64-count-digits
  "returns the number of decimal digits in an int/u64"
  [ x ]
  (gen-u64-count-digits x))

(defn u64-count-significant-digits
  "returns the number of significant digits (i.e. digits excluding trailing zeroes) in an int/u64"
  [ x ]
  (if (= (% x (u64 10)) (u64 0))
    (u64-count-significant-digits (/ x (u64 10)))
    (u64-count-digits x)))

(defn u64-round-significant-digits
  "round an int/u64 to the given number of signficant digits"
  [ x digits ]
  (def pow10-table (gen-u64-pow10-table))
  (def total-digits (u64-count-digits x))
  (def roundoff-magnitude (pow10-table (- total-digits digits 1)))
  (def last-digit-magnitude (* roundoff-magnitude (u64 10)))

  (var result x)
  (when (>= (% x last-digit-magnitude) (* roundoff-magnitude (u64 5)))
    (+= result last-digit-magnitude))

  (- result (% x last-digit-magnitude)))

(defn format-decimal-fixed-reversed [ [significand exponent] { :precision precision :alternate keep-decimal }]
  (default keep-decimal false)

  (assert (u64? significand))
  (assert (int? exponent))

  (var current-exponent exponent)
  (var remaining-digits significand)
  (var need-decimal keep-decimal)

  # first, remove trailing zero digits
  (while (and (< current-exponent 0) (= (% remaining-digits (u64 10)) (u64 0)))
    (/= remaining-digits (u64 10))
    (++ current-exponent))

  # If the initial exponent is > 0, and a decimal is required print it immediately before any zero-padding
  (when (and need-decimal (> current-exponent 0))
    (yield (chr ".")))

  # pad the end of the number with zeroes if either
  # 1. precision is higher than the exponent
  # 2. exponent > 0
  (repeat (+ current-exponent (or precision 0))
    (yield (chr "0"))
    (set need-decimal true))

  (def num-digits (u64-count-digits significand))
  
  (forever
    (when (and need-decimal (= current-exponent 0))
      (yield (chr ".")))
    
    # print the current digit only if
    #  1. current place is before the decimal (current exponent > 0)
    #  2. current place is after the decimal and greater than the given precision
    (when (or (> current-exponent 0) (nil? precision) (<= (math/abs current-exponent) precision))
      (yield (int-ext/unwrap-u64 (+ (chr "0") (% remaining-digits (u64 10)))))
      (set need-decimal true))

    (++ current-exponent)
    (/= remaining-digits (u64 10))
    
    (when (and (> current-exponent 0) (= remaining-digits (u64 0)))
      (break))))

(defn format-decimal-fixed [ parts spec]
  (def reversed (buffer/new 20))
  (def reversed-generator
    (coro
      (format-decimal-fixed-reversed parts spec)))

  (loop [ c :in reversed-generator]
    (buffer/push reversed c))
  
  (loop [i :down-to [(dec (length reversed)) 0]]
    (yield (reversed i))))

(defn format-decimal-scientific [ [significand exponent] { :alternate keep-decimal :precision precision :number num-spec }]
  (assert (u64? significand))
  (assert (int? exponent))

  (def digits (u64-count-digits significand))
  (def fixed-part-exponent (- 1 digits))
  (def real-exponent (- exponent fixed-part-exponent))
  
  # buffer used for holding the numbers it will be reversed before being emitted
  (def scratch-buffer (buffer/new 20))
  (loop [ c :in (coro (format-decimal-fixed-reversed [ significand fixed-part-exponent ] { :alternate keep-decimal :precision precision }))]
    (buffer/push scratch-buffer c))

  (loop [i :down-to [(dec (length scratch-buffer)) 0]]
    (yield (scratch-buffer i)))

  (yield (if (and num-spec (num-spec :uppercase)) "E" "e"))
  (yield (if (neg? real-exponent) "-" "+"))
  
  (buffer/clear scratch-buffer)
  (var remaining-exp-digits (math/abs real-exponent))

  (while (> remaining-exp-digits 0)
    (def digit (% remaining-exp-digits 10))
    (buffer/push-byte scratch-buffer (digit-to-char digit))
    (set remaining-exp-digits (/ (- remaining-exp-digits digit) 10)))

  # pad the exponent to 2 characters
  (repeat (- 2 (length scratch-buffer))
    (yield (chr "0")))

  (loop [i :down-to [(dec (length scratch-buffer)) 0]]
    (yield (scratch-buffer i))))

(defn format-decimal-general [ [significand exponent] spec ]
  (def rounded-significand
    (if-let [ precision (spec :precision) ]
      (u64-round-significant-digits significand precision)
      significand))
  
  (def exponent-needed (math/abs (+ exponent (u64-count-significant-digits rounded-significand))))
  (if (> exponent-needed 4)
    (format-decimal-scientific [significand exponent] spec)
    (format-decimal-fixed [significand exponent] spec)))
