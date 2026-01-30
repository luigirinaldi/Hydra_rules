; Opt : 1003
; %symconst_2:i8 = var ; symconst_2
; %v0:i8 = var ; v0
; %2:i8 = and %symconst_2, %v0
; %symconst_1:i8 = var ; symconst_1
; %4:i8 = and %v0, %symconst_1
; %5:i8 = or %2, %4
; infer %5
; %6:i8 = or %symconst_2, %symconst_1
; %7:i8 = and %v0, %6
; result %7
; 
; (v0 & C2) | (v0 & C1)
;   =>
; v0 & (C2 | C1)
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvor (bvand symconst_2 v0) (bvand v0 symconst_1))
    (bvand v0 (bvor symconst_2 symconst_1))
))
(check-sat)
