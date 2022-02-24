(declare-project
  :name "format"
  :description "janet string formatting")

(declare-native
  :name "int-ext"
  :source ["int-ext/int-ext.c"])

(declare-native
  :name "dragonbox"
  :cppflags ["-std=c++17"]
  :source ["dragonbox/dragonbox-janet.cpp"])

(declare-source :source "format")

(defn format-recursive
  [path]
  (case (os/stat path :mode)
    :file
    (try
      (when (string/has-suffix? ".janet" path)
        (prinf "formatting: %s..." (string/replace (os/cwd) "" path))
        (eval ['spork/fmt/format-file path])
        (print "OK"))
      ([e]
        (printf "ERROR %s" e)))
    :directory
    (let [filenames @[]]
      (try
        (os/dir path filenames)
        ([e]
          (printf "WARN: failed to list directory %s: %s" path e)
          (break)))

      (loop [filename :in filenames]
        (format-recursive (string path "/" filename))))))

(task "format" []
      (try
        (do
          (import* "spork")
          (format-recursive (os/cwd)))
        ([e]
          (printf "failed to import spork/fmt: %q" e))))
