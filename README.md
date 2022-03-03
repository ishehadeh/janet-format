# janet-format

A janet string formatter using Python or `{fmt}` style format string syntax.

## Status

This library is very much a WIP!

Most of the builtin type formatters are implemented. Some are only partially complete though.\
Specifically needed:
- format unicode codepoints with `c`

There are some tests, but they aren't very thorough, especially around the actual `format` macro.

## Docs

See: [docs/usage.md](docs/usage.md), and the `examples/` directory.


## Limiting C Modules

One of the main goals of this project is to write as much of the formatter in Janet as possible.

At the momement, there are two C/C++ modules `int-ext` and `dragonbox`.
- `int-ext` adds a single function to unwrap `int/u64` values, which isn't available in the stdlib.
- `dragonbox` wraps the dragonbox float-to-decimal conversion.

Hopefully these won't be necessary in the future.

