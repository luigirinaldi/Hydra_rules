; Opt : 3174
; %newvar0:i1 = var ; newvar0
; %1:i32 = zext %newvar0
; %2:i1 = ne 0:i32, %1
; infer %2
; result %newvar0
; 
; zext(newvar0) != 0
;   =>
; newvar0
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv r 0) (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1))))
    newvar0
))
(check-sat)
