; Opt : 2542
; %newvar0:i1 = var ; newvar0
; %1:i32 = zext %newvar0
; %2:i1 = ne 0:i32, %1
; %3:i8 = zext %2
; infer %3
; %4:i8 = zext %newvar0
; result %4
; 
; zext((zext(newvar0) != 0))
;   =>
; zext(newvar0)
(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (< q t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (distinct (int_to_pbv r 0) (pzero_extend (- r q) newvar0)) (_ bv1 1) (_ bv0 1)))
    (pzero_extend (- t q) newvar0)
))
(check-sat)
