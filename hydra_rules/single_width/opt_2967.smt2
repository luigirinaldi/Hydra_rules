; Opt : 2967
; %symconst_1:i8 = var ; symconst_1
; %v1:i8 = var ; v1
; %2:i8 = add %symconst_1, %v1
; %3:i1 = eq %symconst_1, %2
; infer %3
; %4:i1 = eq 0:i8, %v1
; result %4
; 
; C1 == (v1 + C1)
;   =>
; v1 == 0
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (bvadd symconst_1 v1))
    (= (int_to_pbv q 0) v1)
))
(check-sat)
