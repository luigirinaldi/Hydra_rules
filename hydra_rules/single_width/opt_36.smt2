; Opt : 36
; %symconst_1:i8 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i8 = add %symconst_1, %v0
; %3:i8 = add %symconst_1, %2
; infer %3
; %4:i8 = add %symconst_1, %symconst_1
; %5:i8 = add %v0, %4
; result %5
; 
; C1 + (v0 + C1)
;   =>
; v0 + (C1 + C1)
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvadd symconst_1 (bvadd symconst_1 v0))
    (bvadd v0 (bvadd symconst_1 symconst_1))
))
(check-sat)
