; Opt : 2450
; %v0:i1 = var ; v0
; %1:i32 = zext %v0
; %2:i1 = ne 0:i32, %1
; %3:i1 = xor 1:i1, %2
; %4:i32 = zext %3
; infer %4
; %5:i32 = zext 1:i1
; %6:i32 = sub %5, %1
; result %6
; 
; zext(~(zext(v0) != 0))
;   =>
; zext(1) - zext(v0)
(set-logic ALL)
(declare-const s Int)
(declare-const v Int)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< 1 s))
(assert (< 1 v))
(assert (< 1 v))
(assert (< 1 v))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- v 1) (ite (not (distinct (int_to_pbv s 0) (pzero_extend (- s 1) (ite v0 (_ bv1 1) (_ bv0 1))))) (_ bv1 1) (_ bv0 1)))
    (bvsub (pzero_extend (- v 1) (ite true (_ bv1 1) (_ bv0 1))) (pzero_extend (- v 1) (ite v0 (_ bv1 1) (_ bv0 1))))
))
(check-sat)
