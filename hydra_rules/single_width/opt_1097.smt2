; Opt : 1097
; %newvar0:i8 = var ; newvar0
; %1:i8 = or 0:i8, %newvar0
; infer %1
; result %newvar0
; 
; newvar0 | 0
;   =>
; newvar0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvor (int_to_pbv q 0) newvar0)
    newvar0
))
(check-sat)
