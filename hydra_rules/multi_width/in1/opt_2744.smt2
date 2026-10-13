; Opt : 2744
; %newvar1:i1 = var ; newvar1
; %1:i32 = zext %newvar1
; %2:i8 = trunc %1
; infer %2
; %3:i8 = zext %newvar1
; result %3
; 
; trunc(zext(newvar1))
;   =>
; zext(newvar1)
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar1 () Bool)

; Preconditions:
(assert (< 1 q))
(assert (< 1 s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (pzero_extend (- q 1) (ite newvar1 (_ bv1 1) (_ bv0 1))))
    (pzero_extend (- s 1) (ite newvar1 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
