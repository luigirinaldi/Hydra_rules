; Opt : 3449
; %newvar0:i1 = var ; newvar0
; %1:i32 = zext %newvar0
; %newvar24:i1 = var ; newvar24
; %3:i32 = zext %newvar24
; %4:i32 = or %1, %3
; %5:i1 = ne 0:i32, %4
; infer %5
; %6:i1 = or %newvar0, %newvar24
; result %6
; 
; (zext(newvar0) | zext(newvar24)) != 0
;   =>
; newvar24 | newvar0
(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar24 () Bool)

; Preconditions:
(assert (< 1 t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t 1) (ite newvar0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- t 1) (ite newvar24 (_ bv1 1) (_ bv0 1)))))
    (or newvar0 newvar24)
))
(check-sat)
