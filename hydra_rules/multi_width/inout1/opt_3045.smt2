; Opt : 3045
; %newvar1:i1 = var ; newvar1
; %1:i32 = zext %newvar1
; %newvar0:i1 = var ; newvar0
; %3:i1 = xor 1:i1, %newvar0
; %4:i32 = zext %3
; %5:i1 = eq %1, %4
; infer %5
; %6:i1 = xor %newvar1, %newvar0
; result %6
; 
; zext(newvar1) == zext(~newvar0)
;   =>
; newvar1 ^ newvar0
(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar1 () Bool)

; Preconditions:
(assert (< 1 t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (= (pzero_extend (- t 1) (ite newvar1 (_ bv1 1) (_ bv0 1))) (pzero_extend (- t 1) (ite (not newvar0) (_ bv1 1) (_ bv0 1))))
    (xor newvar1 newvar0)
))
(check-sat)
