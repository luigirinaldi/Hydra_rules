; Opt : 3272
; %newvar0:i1 = var ; newvar0
; %1:i32 = zext %newvar0
; %2:i8 = trunc %1
; %3:i1 = ne 0:i8, %2
; infer %3
; result %newvar0
; 
; trunc(zext(newvar0)) != 0
;   =>
; newvar0
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< 1 r))
(assert (> r s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (pextract (- s 1) 0 (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))))
    newvar0
))
(check-sat)
