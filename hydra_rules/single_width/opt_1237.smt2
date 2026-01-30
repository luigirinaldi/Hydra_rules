; Opt : 1237
; %symconst_1:i8 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i8 = and %symconst_1, %v0
; %3:i1 = eq %symconst_1, %2
; %4:i1 = xor 1:i1, %3
; infer %4
; %5:i1 = ult %2, %symconst_1
; result %5
; 
; ~(C1 == (v0 & C1))
;   =>
; (v0 & C1) <u C1
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (not (= symconst_1 (bvand symconst_1 v0)))
    (bvult (bvand symconst_1 v0) symconst_1)
))
(check-sat)
