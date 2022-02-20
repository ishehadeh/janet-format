# Format Strings

Format strings use `{}` notation to reference arguments.

- `{}` referes to the next format argument
- `{0}` referes to the argument at index `0`.
- `{x}` references a local variable `x`

The format specification is seperated from the argument with a `:`, it is nearly identical to a `printf` format spec.

For more information and examples see [examples/syntax.janet](/examples/syntax.janet).

# janet-format API

## `(format/format fmt & args)`

This macro is the equivalent of `string/format`, but with `fmt` syntax.
The macro can reference local variables in the format string, or its arguments by index.
For example:
```janet
(def x 5)
(format/format "{x} + {x} = {0}" (+ x x))
```

## `(format/fprint fmt & args)`

`(format/fprint)` is exactly the same as `(format/format)`, but the generated string is printed to stdout.

## `(format/compile fmt & args)`

`(format/compile)` compiles a format string into a series of calls to the underlying value-formatting function.
The result will render the `fmt` string progressively, by `yield`ing a series of characters or strings.

This is a lower-level macro, general `(format/format)` should be used instead.
However it may be useful when building [Custom Formatters](#custom-formatters), or when streaming.

For example, using `(format/compile)` write to a file asynchronous.
Note: a string *or* char may be returned, since :write only accepts string-like structures chars must be converted.
```janet
(import /format)

(with [f (os/open "test.txt" :cw)]
  (loop [s :in (coro (format/compile "{},{},{}\n" 1 2 3))]
    (:write f (if (string? s) s (string/from-bytes s)))))
```

# Custom Formatters

By default tables are formatted with Janet syntax.

If they have a `:fmt` method in their prototype table, that is run instead.
Format funtions should have the signature: `(:fmt value spec)` where `value` is the table and spec is the compiled format specification.

(TODO format spec documentation)

For an example see [examples/prototype.janet](/examples/prototype.janet).


