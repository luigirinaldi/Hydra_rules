; Opt : 1232
; %symconst_3:i8 = var ; symconst_3
; %newvar1:i1 = var ; newvar1
; %symconst_1:i8 = var ; symconst_1
; %symconst_2:i8 = var ; symconst_2
; %4:i8 = select %newvar1, %symconst_1, %symconst_2
; %5:i8 = xor %symconst_3, %4
; infer %5
; %6:i8 = xor %symconst_3, %symconst_1
; %7:i8 = xor %symconst_3, %symconst_2
; %8:i8 = select %newvar1, %6, %7
; result %8
; 
; C3 ^ (select newvar1 C1 C2)
;   =>
; select newvar1 (C3 ^ C1) (C3 ^ C2)
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvxor symconst_3 (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (bvxor symconst_3 symconst_1) (bvxor symconst_3 symconst_2))
))
(check-sat)
