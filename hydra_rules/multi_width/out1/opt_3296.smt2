; Opt : 3296
; %v0:i32 = var ; v0
; %1:i32 = and 1:i32, %v0
; %2:i1 = ne 0:i32, %1
; infer %2
; %3:i1 = trunc %v0
; result %3
; 
; (v0 & 1) != 0
;   =>
; trunc(v0)
(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (> r 1))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) v0)) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 v0)
))
(check-sat)
