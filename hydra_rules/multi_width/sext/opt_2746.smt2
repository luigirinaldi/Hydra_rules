; Opt : 2746
; %v0:i8 = var ; v0
; %1:i32 = sext %v0
; %2:i8 = trunc %1
; infer %2
; result %v0
; 
; trunc(sext(v0))
;   =>
; v0
(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (> q p))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- p 1) 0 (psign_extend (- q p) v0))
    v0
))
(check-sat)
