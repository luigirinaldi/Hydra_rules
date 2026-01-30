; Opt : 1247
; %newvar4:i1 = var ; newvar4
; %1:i1 = xor 1:i1, %newvar4
; %2:i1 = xor 1:i1, %1
; infer %2
; result %newvar4
; 
; ~~newvar4
;   =>
; newvar4
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar4 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvnot (bvnot newvar4))
    newvar4
))
(check-sat)
