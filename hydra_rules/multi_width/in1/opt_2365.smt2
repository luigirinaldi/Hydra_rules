; Opt : 2365
; %newvar3:i1 = var ; newvar3
; %1:i32 = zext %newvar3
; %2:i1 = ne 0:i32, %1
; %3:i32 = zext %2
; infer %3
; result %1
; 
; zext((zext(newvar3) != 0))
;   =>
; zext(newvar3)
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar3 () (_ BitVec 1))

; Preconditions:
(assert (< 1 r))
(assert (< 1 t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (distinct (int_to_pbv r 0) (pzero_extend (- r 1) newvar3)) (_ bv1 1) (_ bv0 1)))
    (pzero_extend (- t 1) newvar3)
))
(check-sat)
