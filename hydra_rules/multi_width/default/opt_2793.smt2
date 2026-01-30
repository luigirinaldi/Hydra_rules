; Opt : 2793
; %v0:i16 = var ; v0
; %1:i32 = zext %v0
; %v3:i16 = var ; v3
; %3:i32 = zext %v3
; %4:i32 = add %1, %3
; %5:i16 = trunc %4
; infer %5
; %6:i16 = add %v0, %v3
; result %6
; 
; trunc((zext(v0) + zext(v3)))
;   =>
; v3 + v0
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v3 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))
(assert (> s r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvadd (pzero_extend (- s r) v0) (pzero_extend (- s r) v3)))
    (bvadd v0 v3)
))
(check-sat)
