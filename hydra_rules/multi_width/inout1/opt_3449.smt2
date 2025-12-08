(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))
(declare-fun newvar24 () (_ BitVec t))

; Preconditions:
(assert (< t t))
(assert (< t t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t t) newvar0) (pzero_extend (- t t) newvar24)))
    (bvor newvar0 newvar24)
))
(check-sat)
