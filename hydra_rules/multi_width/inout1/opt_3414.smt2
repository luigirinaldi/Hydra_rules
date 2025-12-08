(set-logic ALL)
(declare-const u Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec u))
(declare-fun newvar5 () (_ BitVec u))

; Preconditions:
(assert (< u u))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv u 0) (bvxor (ite newvar0 (int_to_pbv u 1) (int_to_pbv s 0)) (pzero_extend (- u u) newvar5)))
    (bvxor newvar0 newvar5)
))
(check-sat)
