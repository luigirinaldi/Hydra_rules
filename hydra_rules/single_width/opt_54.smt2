; Opt : 54
; %symconst_2:i8 = var ; symconst_2
; %symconst_3:i8 = var ; symconst_3
; %v0:i8 = var ; v0
; %symconst_1:i8 = var ; symconst_1
; %4:i8 = add %v0, %symconst_1
; %5:i8 = add %symconst_3, %4
; %6:i8 = add %symconst_2, %5
; infer %6
; %7:i8 = add %symconst_2, %symconst_1
; %8:i8 = add %symconst_3, %7
; %9:i8 = add %v0, %8
; result %9
; 
; C2 + (C3 + (v0 + C1))
;   =>
; v0 + (C3 + (C2 + C1))
(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))
(declare-fun v0 () (_ BitVec s))

; assert lhs != rhs:
(assert (distinct 
    (bvadd symconst_2 (bvadd symconst_3 (bvadd v0 symconst_1)))
    (bvadd v0 (bvadd symconst_3 (bvadd symconst_2 symconst_1)))
))
(check-sat)
