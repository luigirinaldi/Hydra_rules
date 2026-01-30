; Opt : 1116
; %symconst_1:i8 = var ; symconst_1
; %symconst_2:i8 = var ; symconst_2
; %v0:i8 = var ; v0
; %3:i8 = or %symconst_2, %v0
; %4:i8 = or %symconst_1, %3
; infer %4
; %5:i8 = or %symconst_1, %symconst_2
; %6:i8 = or %v0, %5
; result %6
; 
; C1 | (v0 | C2)
;   =>
; v0 | (C2 | C1)
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvor symconst_1 (bvor symconst_2 v0))
    (bvor v0 (bvor symconst_1 symconst_2))
))
(check-sat)
