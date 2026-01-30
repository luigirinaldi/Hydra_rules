; Opt : 583
; %newvar0:i8 = var ; newvar0
; %symconst_1:i8 = var (powerOfTwo) ; symconst_1
; %2:i8 = urem %newvar0, %symconst_1
; infer %2
; %3:i8 = sub %symconst_1, 1:i8
; %4:i8 = and %newvar0, %3
; result %4
; 
; newvar0 %u C1 (powerOfTwo)
;   =>
; newvar0 & (C1 - 1)
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvurem newvar0 symconst_1)
    (bvand newvar0 (bvsub symconst_1 (int_to_pbv r 1)))
))
(check-sat)
