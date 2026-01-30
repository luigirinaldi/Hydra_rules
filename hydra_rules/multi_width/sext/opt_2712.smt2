; Opt : 2712
; %newvar0:i32 = var ; newvar0
; %1:i32 = add 0:i32, %newvar0
; %2:i64 = sext %1
; infer %2
; %3:i64 = sext %newvar0
; result %3
; 
; sext((newvar0 + 0))
;   =>
; sext(newvar0)
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s q) (bvadd (int_to_pbv q 0) newvar0))
    (psign_extend (- s q) newvar0)
))
(check-sat)
