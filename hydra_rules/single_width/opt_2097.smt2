; Opt : 2097
; %newvar0:i8 = var ; newvar0
; %1:i8 = and 1:i8, %newvar0
; %2:i1 = ne 0:i8, %1
; %symconst_3:i8 = var ; symconst_3
; %4:i8 = select %2, %symconst_3, 0:i8
; infer %4
; %5:i8 = mul %symconst_3, %1
; result %5
; 
; select ((newvar0 & 1) != 0) C3 0
;   =>
; C3 * (newvar0 & 1)
(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))
(declare-fun symconst_3 () (_ BitVec t))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)) symconst_3 (int_to_pbv t 0))
    (bvmul symconst_3 (bvand (int_to_pbv t 1) newvar0))
))
(check-sat)
