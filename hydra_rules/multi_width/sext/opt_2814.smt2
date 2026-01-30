; Opt : 2814
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %2:i32 = sext 1:i1
; %3:i32 = xor %symconst_2, %2
; %4:i1 = eq %symconst_1, %3
; pc %4 1:i1
; %v0:i8 = var ; v0
; %6:i32 = zext %v0
; %7:i32 = and %symconst_1, %6
; %8:i32 = or %symconst_2, %7
; %9:i8 = trunc %8
; infer %9
; %10:i8 = trunc %symconst_2
; %11:i8 = or %v0, %10
; result %11
; 
; C1 == (C2 ^ sext(1))
;   |= 
; trunc((C2 | (C1 & zext(v0))))
;   =>
; v0 | trunc(C2)
(set-logic ALL)
(declare-const r Int)
(declare-const v Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec v))

; Preconditions:
(assert (< v r))
(assert (< 1 r))
(assert (> r v))
(assert (> r v))
(assert (= symconst_1 (bvxor symconst_2 (psign_extend (- r 1) (ite true (_ bv1 1) (_ bv0 1))))))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- v 1) 0 (bvor symconst_2 (bvand symconst_1 (pzero_extend (- r v) v0))))
    (bvor v0 (pextract (- v 1) 0 symconst_2))
))
(check-sat)
