(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const u Int)
(declare-const w Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r w))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) newvar0))) (int_to_pbv w 1) (int_to_pbv u 0))
    (pzero_extend (- w r) (bvand (int_to_pbv r 1) newvar0))
))
(check-sat)
