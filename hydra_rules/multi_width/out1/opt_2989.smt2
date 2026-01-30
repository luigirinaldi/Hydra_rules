; Opt : 2989
; %v0:i8 = var ; v0
; %1:i32 = sext %v0 (hasExternalUses)
; %v2:i8 = var ; v2
; %3:i32 = sext %v2
; %4:i1 = eq %1, %3
; infer %4
; %5:i1 = eq %v0, %v2
; result %5
; 
; sext(v0) == sext(v2)
;   =>
; v2 == v0
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
    (= (psign_extend (- s r) v0) (psign_extend (- s r) v2))
    (= v0 v2)
))
(check-sat)
