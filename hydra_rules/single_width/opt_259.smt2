; Opt : 259
; %symconst_2:i8 = var ; symconst_2
; %symconst_1:i8 = var ; symconst_1
; %2:i8 = sub %symconst_2, %symconst_1
; %3:i1 = eq 1:i8, %2
; pc %3 1:i1
; %v1:i8 = var ; v1
; %5:i8 = add %symconst_1, %v1
; %6:i8 = sub %5, %symconst_2
; infer %6
; %7:i8 = add 255:i8, %v1
; result %7
; 
; (C2 - C1) == 1
;   |= 
; (v1 + C1) - C2
;   =>
; v1 + 0xFF
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; Preconditions:
(assert (= (int_to_pbv q 1) (bvsub symconst_2 symconst_1)))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (bvadd symconst_1 v1) symconst_2)
    (bvadd (bvnot (int_to_pbv q 0)) v1)
))
(check-sat)
