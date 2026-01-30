; Opt : 2482
; %v0:i32 = var ; v0
; %1:i32 = and 1:i32, %v0
; %2:i1 = ne 0:i32, %1
; %3:i32 = select %2, 1:i32, 0:i32
; %4:i1 = ne 0:i32, %3
; %5:i1 = xor 1:i1, %4
; %6:i32 = zext %5
; infer %6
; %7:i32 = sub 1:i32, %1
; result %7
; 
; zext(~((select ((v0 & 1) != 0) 1 0) != 0))
;   =>
; 1 - (v0 & 1)
(set-logic ALL)
(declare-const t Int)
(declare-const v Int)
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (not (distinct (int_to_pbv v 0) (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) v0)) (int_to_pbv v 1) (int_to_pbv v 0)))) (_ bv1 1) (_ bv0 1)))
    (bvsub (int_to_pbv t 1) (bvand (int_to_pbv t 1) v0))
))
(check-sat)
