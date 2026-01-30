; Opt : 70
; %symconst_1:i8 = var ; symconst_1
; %symconst_2:i8 = var ; symconst_2
; %2:i8 = mul 255:i8, %symconst_2
; %3:i1 = eq %symconst_1, %2
; pc %3 1:i1
; %v1:i8 = var ; v1
; %5:i8 = add %symconst_1, %v1
; %6:i8 = add %symconst_2, %5
; infer %6
; result %v1
; 
; C1 == (C2 * 0xFF)
;   |= 
; C2 + (v1 + C1)
;   =>
; v1
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; Preconditions:
(assert (= symconst_1 (bvmul (bvnot (int_to_pbv q 0)) symconst_2)))

; assert lhs != rhs:
(assert (distinct 
    (bvadd symconst_2 (bvadd symconst_1 v1))
    v1
))
(check-sat)
