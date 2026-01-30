; Opt : 2750
; %v0:i8 = var ; v0
; %1:i32 = zext %v0
; %newvar1:i8 = var ; newvar1
; %3:i32 = zext %newvar1
; %4:i32 = or %1, %3
; %5:i8 = trunc %4
; infer %5
; %6:i8 = or %v0, %newvar1
; result %6
; 
; trunc((zext(v0) | zext(newvar1)))
;   =>
; v0 | newvar1
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))
(assert (> s r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvor (pzero_extend (- s r) v0) (pzero_extend (- s r) newvar1)))
    (bvor v0 newvar1)
))
(check-sat)
