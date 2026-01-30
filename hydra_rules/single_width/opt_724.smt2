; Opt : 724
; %symconst_1:i8 = var ; symconst_1
; %newvar0:i8 = var ; newvar0
; %2:i8 = or %symconst_1, %newvar0
; %3:i8 = and %symconst_1, %2
; infer %3
; result %symconst_1
; 
; C1 & (C1 | newvar0)
;   =>
; C1
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_1 (bvor symconst_1 newvar0))
    symconst_1
))
(check-sat)
