; Opt : 37
; %v0:i32 = var ; v0
; %1:i32 = add 0:i32, %v0
; infer %1
; result %v0
; 
; v0 + 0
;   =>
; v0
(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvadd (int_to_pbv q 0) v0)
    v0
))
(check-sat)
