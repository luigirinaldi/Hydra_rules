; Opt : 2430
; %v0:i32 = var ; v0
; %1:i32 = add 0:i32, %v0
; %2:i64 = zext %1
; infer %2
; %3:i64 = zext %v0
; result %3
; 
; zext((v0 + 0))
;   =>
; zext(v0)
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- s q) (bvadd (int_to_pbv q 0) v0))
    (pzero_extend (- s q) v0)
))
(check-sat)
