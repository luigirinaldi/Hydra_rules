; Opt : 2496
; %symconst_2:i8 = var ; symconst_2
; %v0:i8 = var ; v0
; %2:i8 = width %v0
; %3:i1 = ult %symconst_2, %2
; pc %3 1:i1
; %4:i8 = and %symconst_2, %v0
; %5:i1 = eq 0:i8, %4
; %6:i8 = zext %5
; infer %6
; %7:i8 = sub 1:i8, %symconst_2
; %8:i8 = add %symconst_2, %7
; %9:i8 = ashr %8, %4
; result %9
; 
; C2 <u width(v0)
;   |= 
; let var0 = (v0 & C2);
; zext((var0 == 0))
;   =>
; (C2 + (1 - C2)) >>a var0
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< 1 r))
(assert (bvult symconst_2 (int_to_pbv r r)))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r 1) (ite (= (int_to_pbv r 0) (bvand symconst_2 v0)) (_ bv1 1) (_ bv0 1)))
    (bvashr (bvadd symconst_2 (bvsub (int_to_pbv r 1) symconst_2)) (bvand symconst_2 v0))
))
(check-sat)
