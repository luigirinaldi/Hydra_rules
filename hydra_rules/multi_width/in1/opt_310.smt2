; Opt : 310
; %newvar0:i1 = var ; newvar0
; %1:i32 = zext %newvar0
; %2:i32 = sub 0:i32, %1
; infer %2
; %3:i32 = sext %newvar0
; result %3
; 
; 0 - zext(newvar0)
;   =>
; sext(newvar0)
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< 1 r))
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (int_to_pbv r 0) (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1))))
    (psign_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
