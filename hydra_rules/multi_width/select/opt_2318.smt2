; Opt : 2318
; %v0:i32 = var ; v0
; %1:i32 = and 1:i32, %v0
; %2:i1 = ne 0:i32, %1
; %3:i32 = select %2, 1:i32, 0:i32
; %4:i1 = ne 0:i32, %3
; %5:i8 = zext %4
; infer %5
; %6:i8 = trunc %1
; result %6
; 
; zext(((select ((v0 & 1) != 0) 1 0) != 0))
;   =>
; trunc((v0 & 1))
(set-logic ALL)
(declare-const s Int)
(declare-const u Int)
(declare-const x Int)
(declare-fun v0 () (_ BitVec s))

; Preconditions:
(assert (< 1 x))
(assert (> s x))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- x 1) (ite (distinct (int_to_pbv u 0) (ite (distinct (int_to_pbv s 0) (bvand (int_to_pbv s 1) v0)) (int_to_pbv u 1) (int_to_pbv u 0))) (_ bv1 1) (_ bv0 1)))
    (pextract (- x 1) 0 (bvand (int_to_pbv s 1) v0))
))
(check-sat)
