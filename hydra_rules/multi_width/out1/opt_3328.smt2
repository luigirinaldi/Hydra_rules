; Opt : 3328
; %newvar0:i64 = var ; newvar0
; %1:i64 = srem %newvar0, 2:i64
; %2:i1 = ne 0:i64, %1
; infer %2
; %3:i1 = trunc %newvar0
; result %3
; 
; (newvar0 %s 2) != 0
;   =>
; trunc(newvar0)
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (> r 1))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (bvsrem newvar0 (int_to_pbv r 2))) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 newvar0)
))
(check-sat)
