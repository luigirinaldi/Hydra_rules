; Opt : 293
; %v0:i8 = var ; v0
; %symconst_1:i8 = var ; symconst_1
; %2:i8 = add %v0, %symconst_1
; %symconst_2:i8 = var ; symconst_2
; %4:i8 = sub %2, %symconst_2
; infer %4
; %5:i8 = sub %symconst_1, %symconst_2
; %6:i8 = add %v0, %5
; result %6
; 
; (v0 + C1) - C2
;   =>
; v0 + (C1 - C2)
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (bvadd v0 symconst_1) symconst_2)
    (bvadd v0 (bvsub symconst_1 symconst_2))
))
(check-sat)
