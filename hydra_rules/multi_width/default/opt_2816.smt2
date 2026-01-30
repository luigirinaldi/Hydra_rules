; Opt : 2816
; %newvar1:i16 = var ; newvar1
; %1:i32 = zext %newvar1
; %2:i8 = trunc %1
; infer %2
; %3:i8 = trunc %newvar1
; result %3
; 
; trunc(zext(newvar1))
;   =>
; trunc(newvar1)
(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar1 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (> p s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (pzero_extend (- q p) newvar1))
    (pextract (- s 1) 0 newvar1)
))
(check-sat)
