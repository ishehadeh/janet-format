(use /format)
(use /test-util)

(assert= (parse-format-string "foo") @["foo"])
(assert= (parse-format-string "hello {}") @["hello " @[nil]])
(assert= (parse-format-string "{:f}") @[@[nil @[] nil false false @[] @[] "f"]])
(assert= (parse-format-string "foo{test}bar") @["foo" @[(symbol "test")] "bar"])
(assert= (parse-format-string "{test:f}") @[@[(symbol "test") @[] nil false false @[] @[] "f"]])

(assert= (parse-format-string "{0:f}") @[@[0 @[] nil false false @[] @[] "f"]])
(assert= (parse-format-string "{0:20}") @[@[0 @[] nil false false @[:literal 20] @[] ""]])
(assert= (parse-format-string "{0:20.3}") @[@[0 @[] nil false false @[:literal 20] @[:literal 3] ""]])
(assert= (parse-format-string "{0:20.3F}") @[@[0 @[] nil false false @[:literal 20] @[:literal 3] "F"]])
(assert= (parse-format-string "{0:020.3F}") @[@[0 @[] nil false true @[:literal 20] @[:literal 3] "F"]])
(assert= (parse-format-string "{0:+#020.3F}") @[@[0 @[] :always true true @[:literal 20] @[:literal 3] "F"]])
(assert= (parse-format-string "{0:^+#020.3F}") @[@[0 @[nil :center] :always true true @[:literal 20] @[:literal 3] "F"]])
(assert= (parse-format-string "{0:_^+#020.3F}") @[@[0 @[("_" 0) :center] :always true true @[:literal 20] @[:literal 3] "F"]])

(assert= (parse-format-string "{0:{w}}") @[@[0 @[] nil false false @[:reference (symbol "w")] @[] ""]])
(assert= (parse-format-string "{0:20.{prec}}") @[@[0 @[] nil false false @[:literal 20] @[:reference (symbol "prec")] ""]])
(assert= (parse-format-string "{0:{w}.3}") @[@[0 @[] nil false false @[:reference (symbol "w")] @[:literal 3] ""]])
(assert= (parse-format-string "{0:{w}.{prec}}") @[@[0 @[] nil false false @[:reference (symbol "w")] @[:reference (symbol "prec")] ""]])

# Sign flags
(assert= (parse-format-string "{test:+}") @[@[(symbol "test") @[] :always false false @[] @[] ""]])
(assert= (parse-format-string "{test:-}") @[@[(symbol "test") @[] :negative false false @[] @[] ""]])
(assert= (parse-format-string "{test: }") @[@[(symbol "test") @[] :pad false false @[] @[] ""]])


(assert= (parse-format-string "{{") @["{"])
(assert= (parse-format-string "}}") @["}"])
(assert= (parse-format-string "{{{}}}") @["{" @[nil] "}"])
