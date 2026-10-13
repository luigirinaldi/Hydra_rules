; Opt : 2703
; %newvar0:i1 = var ; newvar0
; %1:i32 = zext %newvar0
; %2:i32 = sub 0:i32, %1
; %3:i64 = sext %2
; infer %3
; %4:i64 = sext %newvar0
; result %4
; 
; sext((0 - zext(newvar0)))
;   =>
; sext(newvar0)
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< r t))
(assert (< 1 r))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- t r) (bvsub (int_to_pbv r 0) (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))))
    (psign_extend (- t 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
