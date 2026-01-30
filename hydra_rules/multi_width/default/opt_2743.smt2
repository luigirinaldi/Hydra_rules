; Opt : 2743
; %newvar0:i16 = var ; newvar0
; %1:i32 = zext %newvar0
; %2:i16 = trunc %1
; infer %2
; result %newvar0
; 
; trunc(zext(newvar0))
;   =>
; newvar0
(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (> q p))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- p 1) 0 (pzero_extend (- q p) newvar0))
    newvar0
))
(check-sat)
