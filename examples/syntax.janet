(use /format)

# -------------------------------------
# Syntax Overview
# -------------------------------------
#
# { [arg] [":" [[fill]align] [sign] ["#"] ["0"] [width] ["." precision] [type]] }
#
#     arg ::= integer | symbol
#     fill ::= <any>
#     align ::= "<" | "^" | ">"
#     sign ::= "+" | "-" | " "
#     width ::= integer | "{" arg "}"
#     precision ::= integer | "{" arg "}"
#     type ::= "f" | "F" | "g" | "G" | "e" | "E" | "b" | "B" | "o" | "O" | "d" | "x" | "X" | "c"


# -------------------------------------
# Paramater
#
# { [arg] [":" [[fill]align] [sign] ["#"] ["0"] [width] ["." precision] [type]] }
#   ^^^^^
# -------------------------------------

# With no direction, paramaters are used in-order
(fprint "{}" 1.5) # => 1.5
(fprint "first={} second={}" 1 2) # => first=1 second=2

# an index can be used to select specific paramaters
(fprint "{0}{0} {1} {0}{0}" "!" "WARNING") # => !! WARNING !!
(fprint "{}{3}{}{3}{}" "foo" "bar" "baz" ".") # => foo.bar.baz

# Identifiers can be used to format local values
(let [x 5
      y 6]
  (fprint "({x}, {y})")) # => (5, 6)

# Format specifiers are seperated from the paramater with a ":"
# (no special formatting here, its all optional)
(let [x 5] (fprint "{x:}")) # => 5

# -------------------------------------
# Number Format
#
# { [arg] [":" [[fill]align] [sign] ["#"] ["0"] [width] ["." precision] [type]] }
#                                                                       ^^^^^^
# -------------------------------------

# Numbers can be formatted many different ways
# By default when the number is an integer it is formatted in base 10.
# if the number is not an integer its formatted as a fixed or scientific notation decimal, whichever is shorter.
(fprint "{}" .0000003) # => 3e-07
(fprint "{}" 100.5) # => 100.5
(fprint "{}" 1) # => 1

# To force printing a float use either the "f", "e", or "g" types
# "f" prints a decimal number with no exponent
(fprint "{:f}" .0000003) # => 0.0000003
# "e" prints a number in scientific notation
(fprint "{:e}" .0000003) # => 3e-07
# "g" prints whichever is shorter (this is the default)
(fprint "{:g}" .0000003) # => 3e-07

# To change the radix of the printed integer use the "x", "o", "b", or "d" types
(fprint "{:x}" 15) # => f
(fprint "{:o}" 15) # => 17
(fprint "{:b}" 15) # => 1111
(fprint "{:d}" 15) # => 15

# "c" prints the number as an ascii character
(fprint "{:c}" 65) # => A

# -------------------------------------
# Padding
#
# { [arg] [":" [[fill]align] [sign] ["#"] ["0"] [width] ["." precision] [type]] }
#              ^^^^^^^^^^^^^               ^^^  ^^^^^^^
# -------------------------------------

# A number can be added to pad the output to a certain number of characters
(fprint "|{:5}{:5}|" 1 2) # => |    1    2|

# An <, ^, or > can be added before the number to change the alignment
(fprint "|{:<10}|{:^10}|{:>10}|" "left" "center" "right") # => |left      |  center  |     right|

# A specific pad character can be added preceding alignment (An alignment character is required)
(fprint "|{:+<10}|{:-^10}|{:.>10}|" "left" "center" "right") # => |left++++++|--center--|.....right|

# If a zero precedes the width, numbers will be padded with zeros, after the sign.
# NOTE: currently unimplemented for floats
(fprint "<{:08x}>" 0xF) # => <0000000f>
(fprint "{:08}" -25) # => -0000025

# -------------------------------------
# Sign
#
# { [arg] [":" [[fill]align] [sign] ["#"] ["0"] [width] ["." precision] [type]] }
#                            ^^^^^^       ^^^^^
# -------------------------------------
# By default numbers only print their sign if they are negative
(fprint "abs({}) = {}" -5 5) # => abs(-5) = 5

# The "+" flag can be used always print the sign
(fprint "abs({:+}) = {:+}" -5 5) # => abs(-5) = +5

# The " " (space) flag can be used to replace "+" with " " when printing sign
(fprint "| {: }  |\n| {: }  |\n| {: }  |" 1 -2 3)
# => |  1  |
# => | -2  |
# => |  3  |

# -------------------------------------
# Alternate Forms
#
# { [arg] [":" [[fill]align] [sign] ["#"] ["0"] [width] ["." precision] [type]] }
#                                   ^^^^
# -------------------------------------

# The "#" flag can be used to print an alternate (often debug-friendly) form

# Integers will be given a prefix showing their radix (except decimal numbers)
(fprint "{:#x}" 0xF) # => 0xf
(fprint "{:#o}" 30) # => 0o36
(fprint "{:#b}" 0xFF) # => 0b11111111
(fprint "{:#d}" 15) # => 15

# Floats will always print the decimal point
(fprint "{:#f}" 1) # => 1.
(fprint "{:#e}" 1) # => 1.e+00

# Strings and characters will be escaped
(fprint "{:#}" "hello\nworld") # => "hello\nworld"
(fprint "{:#c}" (chr "\xFF")) # => \xff


# Container types will print each value on a newline, and indent.
(fprint "{:#}" @[:a :b :c])
# => @[
# =>   :a
# =>   :b
# =>   :c
# => ]
(fprint "{:#}" {:a 1 :b 2 :c 3})
# => {
# =>   :c 1
# =>   :a 2
# =>   :b 3
# => }

# They also forward the alternate form to their children
(fprint "{:#}" {:a 1 :b ["hello\0world"] :c 3})
# => {
# =>   :c 1
# =>   :a 2
# =>   :b (
# =>     "hello\0world"  
# =>   )
# => }

# -------------------------------------
# Precision
#
# { [arg] [":" [[fill]align] [sign] ["#"] ["0"] [width] ["." precision] [type]] }
#                                                       ^^^^^^^^^^^^^^^
# -------------------------------------

# Precision is a number given after the "."
# For non-float arguments precision is the max length of the value.
(fprint "{:.5}" "hello world") # => hello

# For floats, the precision is the number of characters after the decimal point
(fprint "{0:.1f} {0:.5f} {1:.5f}" math/pi 1) # => 3.1 3.14159 1.00000

