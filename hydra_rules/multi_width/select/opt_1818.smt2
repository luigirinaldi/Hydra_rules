; Opt : 1818
; %newvar0:i1 = var ; newvar0
; %1:i8 = zext %newvar0
; %2:i1 = ne 0:i8, %1
; %newvar5:i8 = var ; newvar5
; %4:i8 = select %2, %newvar5, 0:i8
; infer %4
; %5:i8 = select %newvar0, %newvar5, 0:i8
; result %5
; 
; select (zext(newvar0) != 0) newvar5 0
;   =>
; select newvar0 newvar5 0
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar5 () (_ BitVec t))

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))) newvar5 (int_to_pbv t 0))
    (ite newvar0 newvar5 (int_to_pbv t 0))
))
(check-sat)
