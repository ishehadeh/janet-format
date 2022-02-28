(defmacro unwrap-pad-spec
  ``Interpret a padding specification combined with content width, to find where padding is needed around the content.

returns a tuple: `[fill num-pad left-pad right-pad]`
  - fill: the character that should be used when padding
  - num-pad: sign-aware padding, this will only be filled if :enable-numeric is set
  - left-pad: the number of `fill` characters that should be to the left of the content
  - right-pad: the number of `fill` characters that should be to right of the content``

  [content-length pad-spec &keys {:enable-numeric enable-numeric}]
  (with-syms [width fill numeric align left-pad padding]
    (def align-check
      ~(case ,align
         :left [,fill 0 0 ,padding]
         :right [,fill 0 ,padding 0]
         :center
         (let [,left-pad (,math/floor (/ ,padding 2))]
           [,fill 0 ,left-pad (- ,padding ,left-pad)])))

    (if enable-numeric
      ~(if-let [{:width ,width :fill ,fill :numeric ,numeric :align ,align} ,pad-spec
                ,padding (- ,width ,content-length)]
         (if ,numeric
           [(chr "0") ,padding 0 0]
           ,align-check)
         [nil 0 0 0])

      ~(if-let [{:width ,width :fill ,fill :align ,align} ,pad-spec
                ,padding (- ,width ,content-length)]
         ,align-check
         [nil 0 0 0]))))

(defmacro pad-around
  ```
  generate padding based on a spec around another statement.
  The number of characters to pad must be known ahead of time.
  If two body statements are provided numeric (sign-aware) padding is enabled, and the first body is used as the sign
  ```

  [content-length pad-spec body &opt num-body]
  (with-syms [pad-tuple]
    ~(let [,pad-tuple (as-macro ,unwrap-pad-spec ,content-length ,pad-spec :enable-numeric (and ,num-body))]
       (repeat (,pad-tuple 2)
         (yield (,pad-tuple 0)))
       ,body
       ,(when num-body
          ~(do
             (repeat (,pad-tuple 1)
               (yield (,pad-tuple 0)))
             ,num-body))
       (repeat (,pad-tuple 3)
         (yield (,pad-tuple 0))))))
