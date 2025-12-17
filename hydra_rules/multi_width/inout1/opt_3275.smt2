(set-logic ALL)
(declare-const q Int)
(declare-const u Int)
(declare-fun newvar1 () (_ BitVec q))
(declare-fun newvar2 () (_ BitVec q))

; Preconditions:
(assert (< q u))
(assert (< q u))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv u 0) (bvor (pzero_extend (- u q) newvar2) (pzero_extend (- u q) (bvnot newvar1))))
    (bvule newvar1 newvar2)
))
(check-sat)
