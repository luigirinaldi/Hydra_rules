; Opt : 1106
; %v0:i8 = var ; v0
; %symconst_2:i8 = var ; symconst_2
; %2:i8 = and %v0, %symconst_2
; %symconst_1:i8 = var ; symconst_1
; %symconst_3:i8 = var ; symconst_3
; %5:i8 = and %v0, %symconst_3
; %6:i8 = and %symconst_1, %5
; %7:i8 = or %2, %6
; infer %7
; %8:i8 = and %symconst_1, %symconst_3
; %9:i8 = or %symconst_2, %8
; %10:i8 = and %v0, %9
; result %10
; 
; (v0 & C2) | (C1 & (v0 & C3))
;   =>
; v0 & (C2 | (C3 & C1))
(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))
(declare-fun v0 () (_ BitVec s))

; assert lhs != rhs:
(assert (distinct 
    (bvor (bvand v0 symconst_2) (bvand symconst_1 (bvand v0 symconst_3)))
    (bvand v0 (bvor symconst_2 (bvand symconst_1 symconst_3)))
))
(check-sat)
