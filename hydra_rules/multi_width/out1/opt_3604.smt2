; Opt : 3604
; %v5:i16 = var ; v5
; %1:i32 = zext %v5
; %v0:i16 = var ; v0
; %3:i32 = zext %v0 (hasExternalUses)
; %4:i1 = slt %1, %3
; infer %4
; %5:i1 = ult %v5, %v0
; result %5
; 
; zext(v5) <s zext(v0)
;   =>
; v5 <u v0
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v5 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (bvslt (pzero_extend (- s r) v5) (pzero_extend (- s r) v0))
    (bvult v5 v0)
))
(check-sat)
