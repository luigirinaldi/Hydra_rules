; Opt : 1204
; %newvar0:i64 = var ; newvar0
; %v4:i64 = var ; v4
; %2:i1 = ult %newvar0, %v4
; %3:i1 = xor 1:i1, %2
; infer %3
; %4:i1 = ule %v4, %newvar0
; result %4
; 
; ~(newvar0 <u v4)
;   =>
; v4 <=u newvar0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun v4 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (not (bvult newvar0 v4))
    (bvule v4 newvar0)
))
(check-sat)
