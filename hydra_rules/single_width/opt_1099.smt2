; Opt : 1099
; %symconst_3:i8 = var ; symconst_3
; %newvar5:i1 = var ; newvar5
; %symconst_1:i8 = var ; symconst_1
; %3:i8 = select %newvar5, %symconst_1, 0:i8
; %4:i8 = or %symconst_3, %3
; infer %4
; %5:i8 = or %symconst_3, %symconst_1
; %6:i8 = select %newvar5, %5, %symconst_3
; result %6
; 
; C3 | (select newvar5 C1 0)
;   =>
; select newvar5 (C3 | C1) C3
(set-logic ALL)
(declare-const s Int)
(declare-fun newvar5 () Bool)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))

; assert lhs != rhs:
(assert (distinct 
    (bvor symconst_3 (ite newvar5 symconst_1 (int_to_pbv s 0)))
    (ite newvar5 (bvor symconst_3 symconst_1) symconst_3)
))
(check-sat)
