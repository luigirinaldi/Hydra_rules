; Opt : 251
; %v0:i64 = var ; v0
; %v1:i64 = var ; v1
; %2:i64 = sub %v0, %v1
; %3:i64 = sub 0:i64, %2
; infer %3
; %4:i64 = sub %v1, %v0
; result %4
; 
; 0 - (v0 - v1)
;   =>
; v1 - v0
(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (int_to_pbv q 0) (bvsub v0 v1))
    (bvsub v1 v0)
))
(check-sat)
