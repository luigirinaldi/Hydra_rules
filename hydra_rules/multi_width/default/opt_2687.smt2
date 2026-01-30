; Opt : 2687
; %newvar0:i32 = var ; newvar0
; %1:i32 = and 1:i32, %newvar0
; %2:i1 = ne 0:i32, %1
; %3:i1 = xor 1:i1, %2
; %4:i1 = xor 1:i1, %3
; %5:i32 = zext %4
; infer %5
; result %1
; 
; zext(~~((newvar0 & 1) != 0))
;   =>
; newvar0 & 1
(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))

; Preconditions:
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (not (not (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)))) (_ bv1 1) (_ bv0 1)))
    (bvand (int_to_pbv t 1) newvar0)
))
(check-sat)
