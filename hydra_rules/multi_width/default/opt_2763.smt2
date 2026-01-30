; Opt : 2763
; %v0:i64 = var ; v0
; %1:i64 = add 0:i64, %v0
; %2:i32 = trunc %1
; infer %2
; %3:i32 = trunc %v0
; result %3
; 
; trunc((v0 + 0))
;   =>
; trunc(v0)
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (> q s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (bvadd (int_to_pbv q 0) v0))
    (pextract (- s 1) 0 v0)
))
(check-sat)
