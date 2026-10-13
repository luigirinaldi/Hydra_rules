; Opt : 3275
; %newvar2:i1 = var ; newvar2
; %1:i32 = zext %newvar2
; %newvar1:i1 = var ; newvar1
; %3:i1 = xor 1:i1, %newvar1
; %4:i32 = zext %3
; %5:i32 = or %1, %4
; %6:i1 = ne 0:i32, %5
; infer %6
; %7:i1 = ule %newvar1, %newvar2
; result %7
; 
; (zext(newvar2) | zext(~newvar1)) != 0
;   =>
; newvar1 <=u newvar2
(set-logic ALL)
(declare-const u Int)
(declare-fun newvar1 () Bool)
(declare-fun newvar2 () Bool)

; Preconditions:
(assert (< 1 u))
(assert (< 1 u))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv u 0) (bvor (pzero_extend (- u 1) (ite newvar2 (_ bv1 1) (_ bv0 1))) (pzero_extend (- u 1) (ite (not newvar1) (_ bv1 1) (_ bv0 1)))))
    (bvule (ite newvar1 (_ bv1 1) (_ bv0 1)) (ite newvar2 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
