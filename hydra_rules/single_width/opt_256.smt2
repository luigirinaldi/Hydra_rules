; Opt : 256
; %v1:i64 = var ; v1
; %v0:i64 = var ; v0
; %2:i64 = sub %v1, %v0
; %3:i64 = sub %v1, %2
; infer %3
; result %v0
; 
; v1 - (v1 - v0)
;   =>
; v0
(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub v1 (bvsub v1 v0))
    v0
))
(check-sat)
