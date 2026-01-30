; Opt : 2777
; %v0:i8 = var ; v0
; %1:i32 = sext %v0
; %v2:i8 = var ; v2
; %3:i32 = sext %v2
; %4:i32 = and %1, %3
; %5:i8 = trunc %4
; infer %5
; %6:i8 = and %v0, %v2
; result %6
; 
; trunc((sext(v0) & sext(v2)))
;   =>
; v2 & v0
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v2 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))
(assert (> s r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvand (psign_extend (- s r) v0) (psign_extend (- s r) v2)))
    (bvand v0 v2)
))
(check-sat)
