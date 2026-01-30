; Opt : 3315
; %v0:i1 = var ; v0
; %1:i32 = zext %v0
; %newvar5:i1 = var ; newvar5
; %3:i32 = zext %newvar5
; %4:i8 = trunc %3
; %5:i32 = zext %4
; %6:i1 = ne %1, %5
; infer %6
; %7:i1 = xor %v0, %newvar5
; result %7
; 
; zext(v0) != zext(trunc(zext(newvar5)))
;   =>
; v0 ^ newvar5
(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun newvar5 () Bool)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< t u))
(assert (< 1 s))
(assert (< 1 u))
(assert (> s t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (pzero_extend (- u 1) (ite v0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- u t) (pextract (- t 1) 0 (pzero_extend (- s 1) (ite newvar5 (_ bv1 1) (_ bv0 1))))))
    (xor v0 newvar5)
))
(check-sat)
