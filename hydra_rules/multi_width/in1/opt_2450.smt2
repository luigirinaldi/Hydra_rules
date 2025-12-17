(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const u Int)
(declare-const w Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r w))
(assert (< u w))
(assert (< 1 w))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- w 1) (ite (not (distinct (int_to_pbv s 0) (pzero_extend (- s r) v0))) (_ bv1 1) (_ bv0 1)))
    (bvsub (pzero_extend (- w u) (int_to_pbv u 1)) (pzero_extend (- w r) v0))
))
(check-sat)
