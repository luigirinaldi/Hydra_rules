; Opt : 1677
; %newvar3:i1 = var ; newvar3
; %1:i16 = select %newvar3, 1:i16, 0:i16
; infer %1
; %2:i16 = zext %newvar3
; result %2
; 
; select newvar3 1 0
;   =>
; zext(newvar3)
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar3 () Bool)

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar3 (int_to_pbv r 1) (int_to_pbv r 0))
    (pzero_extend (- r 1) (ite newvar3 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
