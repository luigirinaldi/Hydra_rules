; Opt : 2751
; %v4:i8 = var ; v4
; %1:i32 = zext %v4
; %v1:i8 = var ; v1
; %3:i32 = zext %v1 (hasExternalUses)
; %4:i32 = sub %1, %3
; %5:i8 = trunc %4
; infer %5
; %6:i8 = sub %v4, %v1
; result %6
; 
; trunc((zext(v4) - zext(v1)))
;   =>
; v4 - v1
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v1 () (_ BitVec r))
(declare-fun v4 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))
(assert (> s r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvsub (pzero_extend (- s r) v4) (pzero_extend (- s r) v1)))
    (bvsub v4 v1)
))
(check-sat)
