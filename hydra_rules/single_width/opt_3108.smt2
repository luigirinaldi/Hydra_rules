; Opt : 3108
; %v0:i8 = var ; v0
; %symconst_1:i8 = var ; symconst_1
; %2:i8 = add %v0, %symconst_1
; %v2:i8 = var ; v2
; %4:i8 = add %symconst_1, %v2
; %5:i1 = eq %2, %4
; infer %5
; %6:i1 = eq %v0, %v2
; result %6
; 
; (v0 + C1) == (v2 + C1)
;   =>
; v2 == v0
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))
(declare-fun v2 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (= (bvadd v0 symconst_1) (bvadd symconst_1 v2))
    (= v0 v2)
))
(check-sat)
