(set-logic ALL)
(declare-const q Int)
(declare-fun newvar4 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvnot (bvnot newvar4))
    newvar4
))
(check-sat)
