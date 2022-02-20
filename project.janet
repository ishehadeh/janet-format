(declare-project
  :name "format"
  :description "janet string formatting")

(declare-native
  :name "int-ext"
  :source [ "int-ext/int-ext.c" ])

(declare-native
  :name "dragonbox"
  :cppflags [ "-std=c++17" ]
  :source [ "dragonbox/dragonbox-janet.cpp" ])

(declare-source :source "format")
