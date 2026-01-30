; Opt : 2846
; %symconst_3:i32 = var ; symconst_3
; %newvar1:i1 = var ; newvar1
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %4:i32 = select %newvar1, %symconst_1, %symconst_2
; %5:i32 = xor %symconst_3, %4
; %6:i8 = trunc %5
; infer %6
; %7:i32 = xor %symconst_3, %symconst_1
; %8:i8 = trunc %7
; %9:i32 = xor %symconst_3, %symconst_2
; %10:i8 = trunc %9
; %11:i8 = select %newvar1, %8, %10
; result %11
; 
; trunc((C3 ^ (select newvar1 C1 C2)))
;   =>
; select newvar1 trunc((C3 ^ C1)) trunc((C3 ^ C2))
(set-logic ALL)
(declare-const r Int)
(declare-const v Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))

; Preconditions:
(assert (> r v))
(assert (> r v))
(assert (> r v))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- v 1) 0 (bvxor symconst_3 (ite newvar1 symconst_1 symconst_2)))
    (ite newvar1 (pextract (- v 1) 0 (bvxor symconst_3 symconst_1)) (pextract (- v 1) 0 (bvxor symconst_3 symconst_2)))
))
(check-sat)
