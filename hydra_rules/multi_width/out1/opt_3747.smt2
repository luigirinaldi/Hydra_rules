; Opt : 3747
; %v0:i8 = var ; v0
; %1:i64 = zext %v0 (hasExternalUses)
; %v2:i8 = var ; v2
; %3:i64 = zext %v2
; %4:i1 = ule %1, %3
; infer %4
; %5:i1 = ule %v0, %v2
; result %5
; 
; zext(v0) <=u zext(v2)
;   =>
; v0 <=u v2
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v2 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (bvule (pzero_extend (- s r) v0) (pzero_extend (- s r) v2))
    (bvule v0 v2)
))
(check-sat)
