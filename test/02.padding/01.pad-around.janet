(use /test-util /format/padding)

(def pad-formatter
  (wrap-formatter
    (fn [str {:pad pad-spec}]
      (pad-around (length str) pad-spec
                  (yield str)))))

(def pad-formatter-num
  (wrap-formatter
    (fn [[prefix str] {:pad pad-spec}]
      (pad-around (+ (length str) (length prefix)) pad-spec
                  (yield prefix)
                  (yield str)))))

(assert= (pad-formatter "hi" {:pad {:width 10 :align :left :fill (chr " ")}}) "hi        ")
(assert= (pad-formatter "hi" {:pad {:width 10 :align :right :fill (chr " ")}}) "        hi")
(assert= (pad-formatter "hi" {:pad {:width 10 :align :center :fill (chr " ")}}) "    hi    ")

(assert= (pad-formatter-num ["+" "hi"] {:pad {:width 10 :align :left :fill (chr " ") :numeric true}}) "+0000000hi")
(assert= (pad-formatter-num ["+" "hi"] {:pad {:width 10 :align :left :fill (chr " ")}}) "+hi       ")
