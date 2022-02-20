(use /format)
(use /test-util)

(assert= (format "hello {0}" "world") "hello world")
(assert= (format "one {} two {} three {}" "1" "2" "3") "one 1 two 2 three 3")
(assert= (format "[{} {2} {}]" "foo" "baz" "bar") "[foo bar baz]")

(let [x "1"
      y "5"]
  (assert= (format "x={x}, y={y}") "x=1, y=5"))
