; Opt : 1160
; %v1:i8 = var ; v1
; %symconst_3:i8 = var ; symconst_3
; %2:i8 = and %v1, %symconst_3
; %symconst_2:i8 = var (powerOfTwo) ; symconst_2
; %4:i8 = and %v1, %symconst_2
; %5:i1 = ne 0:i8, %4
; %6:i8 = select %5, %symconst_2, 0:i8
; %7:i8 = or %2, %6
; infer %7
; %8:i8 = or %symconst_3, %symconst_2
; %9:i8 = and %v1, %8
; result %9
; 
; (v1 & C3) | (select ((v1 & C2 (powerOfTwo)) != 0) C2 0)
;   =>
; v1 & (C3 | C2)
(set-logic ALL)
(declare-const t Int)
(declare-fun symconst_2 () (_ BitVec t))
(declare-fun symconst_3 () (_ BitVec t))
(declare-fun v1 () (_ BitVec t))

; Preconditions:
(assert (= (bvand symconst_2 (bvsub symconst_2 (int_to_pbv t 1))) (int_to_pbv t 0)))
(assert (distinct symconst_2 (int_to_pbv t 0)))

; assert lhs != rhs:
(assert (distinct 
    (bvor (bvand v1 symconst_3) (ite (distinct (int_to_pbv t 0) (bvand v1 symconst_2)) symconst_2 (int_to_pbv t 0)))
    (bvand v1 (bvor symconst_3 symconst_2))
))
(check-sat)
