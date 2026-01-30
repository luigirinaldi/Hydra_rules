; Opt : 3356
; %newvar0:i1 = var ; newvar0
; %1:i32 = zext %newvar0
; %newvar1:i1 = var ; newvar1
; %3:i32 = zext %newvar1
; %4:i1 = ne %1, %3
; infer %4
; %5:i1 = xor %newvar0, %newvar1
; result %5
; 
; zext(newvar0) != zext(newvar1)
;   =>
; newvar1 ^ newvar0
(set-logic ALL)
(declare-const s Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar1 () Bool)

; Preconditions:
(assert (< 1 s))
(assert (< 1 s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (pzero_extend (- s 1) (ite newvar0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- s 1) (ite newvar1 (_ bv1 1) (_ bv0 1))))
    (xor newvar0 newvar1)
))
(check-sat)
