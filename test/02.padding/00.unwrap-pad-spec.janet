(use /test-util /format/padding)

(assert= (unwrap-pad-spec 0 {:width 10 :align :right :fill (chr " ")}) [(chr " ") 0 10 0])
(assert= (unwrap-pad-spec 0 {:width 10 :align :right :fill (chr "-")}) [(chr "-") 0 10 0])

(assert= (unwrap-pad-spec 0 {:width 10 :align :center :fill (chr " ")}) [(chr " ") 0 5 5])
(assert= (unwrap-pad-spec 0 {:width 10 :align :left :fill (chr " ")}) [(chr " ") 0 0 10])

(assert= (unwrap-pad-spec 4 {:width 10 :align :center :fill (chr " ")}) [(chr " ") 0 3 3])
(assert= (unwrap-pad-spec 4 {:width 10 :align :left :fill (chr " ")}) [(chr " ") 0 0 6])
(assert= (unwrap-pad-spec 4 {:width 10 :align :right :fill (chr " ")}) [(chr " ") 0 6 0])

# Bias toward right when center is impossible
(assert= (unwrap-pad-spec 3 {:width 10 :align :center :fill (chr " ")}) [(chr " ") 0 3 4])

# Numeric is ignored unless enabled
(assert= (unwrap-pad-spec 0 {:width 10 :align :left :fill (chr " ") :numeric true}) [(chr " ") 0 0 10])
(assert= (unwrap-pad-spec 0 {:width 10 :align :left :fill (chr " ") :numeric true} :enable-numeric true) [(chr "0") 10 0 0])
