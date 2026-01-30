; Opt : 1635
; %symconst_6:i32 = var ; symconst_6
; %symconst_7:i32 = var ; symconst_7
; %2:i32 = sub %symconst_6, %symconst_7
; %3:i1 = eq 1:i32, %2
; pc %3 1:i1
; %v0:i32 = var ; v0
; %5:i32 = and 1:i32, %v0
; %6:i1 = ne 0:i32, %5
; %7:i32 = select %6, %symconst_6, %symconst_7
; infer %7
; %8:i32 = add %symconst_7, %5
; result %8
; 
; (C6 - C7) == 1
;   |= 
; let var0 = (v0 & 1);
; select (var0 != 0) C6 C7
;   =>
; C7 + var0
(set-logic ALL)
(declare-const u Int)
(declare-fun symconst_6 () (_ BitVec u))
(declare-fun symconst_7 () (_ BitVec u))
(declare-fun v0 () (_ BitVec u))

; Preconditions:
(assert (= (int_to_pbv u 1) (bvsub symconst_6 symconst_7)))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv u 0) (bvand (int_to_pbv u 1) v0)) symconst_6 symconst_7)
    (bvadd symconst_7 (bvand (int_to_pbv u 1) v0))
))
(check-sat)
