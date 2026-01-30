; Opt : 3891
; %v3:i16 = var ; v3
; %1:i32 = zext %v3 (hasExternalUses)
; %v6:i16 = var ; v6
; %3:i32 = zext %v6
; %4:i1 = sle %1, %3
; infer %4
; %5:i1 = ule %v3, %v6
; result %5
; 
; zext(v3) <=s zext(v6)
;   =>
; v3 <=u v6
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v3 () (_ BitVec r))
(declare-fun v6 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (bvsle (pzero_extend (- s r) v3) (pzero_extend (- s r) v6))
    (bvule v3 v6)
))
(check-sat)
