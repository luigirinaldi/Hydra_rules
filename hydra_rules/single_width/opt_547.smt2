; Opt : 547
; %v0:i64 = var ; v0
; %1:i64 = sdiv %v0, 1:i64
; infer %1
; result %v0
; 
; v0 /s 1
;   =>
; v0
(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsdiv v0 (int_to_pbv q 1))
    v0
))
(check-sat)
