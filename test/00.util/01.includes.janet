(use /test-util /format/util)

(assert= (includes? (chr "\n") "hello\nworld") true)
(assert= (includes? :a [:b :d :a :c]) true)

(assert= (includes? :e [:b :d :a :c]) false)
(assert= (includes? (chr "!") "hello\nworld") false)
