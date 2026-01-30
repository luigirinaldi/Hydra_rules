; Opt : 1502
; %newvar0:i1 = var ; newvar0
; %symconst_1:i8 = var ; symconst_1
; %2:i8 = select %newvar0, %symconst_1, %symconst_1
; infer %2
; result %symconst_1
; 
; select newvar0 C1 C1
;   =>
; C1
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar0 symconst_1 symconst_1)
    symconst_1
))
(check-sat)
