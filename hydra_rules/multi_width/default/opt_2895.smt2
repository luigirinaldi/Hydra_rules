; Opt : 2895
; %newvar0:i64 = var ; newvar0
; %1:i32 = trunc %newvar0
; %2:i16 = trunc %1
; infer %2
; %3:i16 = trunc %newvar0
; result %3
; 
; trunc(trunc(newvar0))
;   =>
; trunc(newvar0)
(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec p))

; Preconditions:
(assert (> p q))
(assert (> p s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (pextract (- q 1) 0 newvar0))
    (pextract (- s 1) 0 newvar0)
))
(check-sat)
