; Opt : 1304
; %symconst_1:i8 = var ; symconst_1
; %symconst_3:i8 = var ; symconst_3
; %v0:i8 = var ; v0
; %symconst_2:i8 = var ; symconst_2
; %4:i8 = lshr %v0, %symconst_2
; %5:i8 = and %symconst_3, %4
; %6:i8 = and %symconst_1, %5
; %7:i8 = shl %6, %symconst_2
; infer %7
; %8:i8 = and %symconst_1, %symconst_3
; %9:i8 = shl %8, %symconst_2
; %10:i8 = and %v0, %9
; result %10
; 
; (C1 & (C3 & (v0 >>l C2))) << C2
;   =>
; v0 & ((C3 & C1) << C2)
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun symconst_3 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvshl (bvand symconst_1 (bvand symconst_3 (bvlshr v0 symconst_2))) symconst_2)
    (bvand v0 (bvshl (bvand symconst_1 symconst_3) symconst_2))
))
(check-sat)
