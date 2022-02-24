(import /format)

(with [f (file/open "test.txt" :w)]
  (loop [s :in (coro (format/compile "{},{},{}\n" 1 2 3))]
    (file/write f (if (string? s) s (string/from-bytes s)))))
