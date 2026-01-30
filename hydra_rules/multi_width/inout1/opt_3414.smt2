; Opt : 3414
; %newvar0:i1 = var ; newvar0
; %1:i32 = select %newvar0, 1:i32, 0:i32
; %newvar5:i1 = var ; newvar5
; %3:i32 = zext %newvar5
; %4:i32 = xor %1, %3
; %5:i1 = ne 0:i32, %4
; infer %5
; %6:i1 = xor %newvar0, %newvar5
; result %6
; 
; ((select newvar0 1 0) ^ zext(newvar5)) != 0
;   =>
; newvar5 ^ newvar0
(set-logic ALL)
(declare-const s Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar5 () Bool)

; Preconditions:
(assert (< 1 s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (bvxor (ite newvar0 (int_to_pbv s 1) (int_to_pbv s 0)) (pzero_extend (- s 1) (ite newvar5 (_ bv1 1) (_ bv0 1)))))
    (xor newvar0 newvar5)
))
(check-sat)
