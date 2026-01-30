; Opt : 2731
; %v0:i16 = var ; v0
; %1:i32 = zext %v0 (hasExternalUses)
; %v2:i16 = var ; v2
; %3:i32 = zext %v2
; %4:i32 = and %1, %3
; %5:i16 = trunc %4
; infer %5
; %6:i16 = and %v0, %v2
; result %6
; 
; trunc((zext(v0) & zext(v2)))
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
    (pextract (- r 1) 0 (bvand (pzero_extend (- s r) v0) (pzero_extend (- s r) v2)))
    (bvand v0 v2)
))
(check-sat)
