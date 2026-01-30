; Opt : 408
; %symconst_3:i8 = var ; symconst_3
; %newvar0:i8 = var ; newvar0
; %2:i8 = and 1:i8, %newvar0
; %3:i1 = ne 0:i8, %2
; %4:i1 = xor 1:i1, %3
; %5:i1 = xor 1:i1, %4
; %6:i8 = zext %5
; %7:i8 = mul %symconst_3, %6
; infer %7
; %8:i8 = mul %symconst_3, %2
; result %8
; 
; C3 * zext(~~((newvar0 & 1) != 0))
;   =>
; C3 * (newvar0 & 1)
(set-logic ALL)
(declare-const v Int)
(declare-fun newvar0 () (_ BitVec v))
(declare-fun symconst_3 () (_ BitVec v))

; Preconditions:
(assert (< 1 v))

; assert lhs != rhs:
(assert (distinct 
    (bvmul symconst_3 (pzero_extend (- v 1) (ite (not (not (distinct (int_to_pbv v 0) (bvand (int_to_pbv v 1) newvar0)))) (_ bv1 1) (_ bv0 1))))
    (bvmul symconst_3 (bvand (int_to_pbv v 1) newvar0))
))
(check-sat)
