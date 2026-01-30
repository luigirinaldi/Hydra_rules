; Opt : 2695
; %v0:i16 = var ; v0
; %1:i32 = sext %v0
; %2:i64 = sext %1
; infer %2
; %3:i64 = sext %v0
; result %3
; 
; sext(sext(v0))
;   =>
; sext(v0)
(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (< p s))
(assert (< q s))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s q) (psign_extend (- q p) v0))
    (psign_extend (- s p) v0)
))
(check-sat)
