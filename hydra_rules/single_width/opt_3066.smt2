; Opt : 3066
; %newvar1:i8 = var ; newvar1
; %1:i1 = eq %newvar1, %newvar1
; infer %1
; %2:i1 = eq 0:i8, 0:i8
; result %2
; 
; newvar1 == newvar1
;   =>
; 0 == 0
(set-logic ALL)
(declare-const p Int)
(declare-const r Int)
(declare-fun newvar1 () (_ BitVec p))

; assert lhs != rhs:
(assert (distinct 
    (= newvar1 newvar1)
    (= (int_to_pbv r 0) (int_to_pbv r 0))
))
(check-sat)
