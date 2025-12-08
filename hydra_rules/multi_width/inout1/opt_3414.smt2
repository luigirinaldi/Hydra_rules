(set-logic ALL)
(declare-const s Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec 1))
(declare-fun newvar5 () (_ BitVec 1))

; Preconditions:
(assert (< 1 u))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv u 0) (bvxor (ite (= newvar0 (_ bv1 1)) (int_to_pbv u 1) (int_to_pbv s 0)) (pzero_extend (- u 1) newvar5)))
    (bvxor newvar0 newvar5)
))
(check-sat)
