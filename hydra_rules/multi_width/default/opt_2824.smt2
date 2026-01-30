; Opt : 2824
; %v0:i8 = var ; v0
; %1:i32 = zext %v0
; %2:i16 = trunc %1
; infer %2
; %3:i16 = zext %v0
; result %3
; 
; trunc(zext(v0))
;   =>
; zext(v0)
(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (< p s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (pzero_extend (- q p) v0))
    (pzero_extend (- s p) v0)
))
(check-sat)
