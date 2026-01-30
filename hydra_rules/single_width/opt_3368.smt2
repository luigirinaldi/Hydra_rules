; Opt : 3368
; %newvar0:i8 = var ; newvar0
; %1:i1 = ne %newvar0, %newvar0
; infer %1
; %2:i1 = ne 0:i8, 0:i8
; result %2
; 
; newvar0 != newvar0
;   =>
; 0 != 0
(set-logic ALL)
(declare-const p Int)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec p))

; assert lhs != rhs:
(assert (distinct 
    (distinct newvar0 newvar0)
    (distinct (int_to_pbv r 0) (int_to_pbv r 0))
))
(check-sat)
