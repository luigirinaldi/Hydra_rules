(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar3 () Bool)

; Preconditions:
(assert (< 1 q))
(assert (< 1 s))
(assert (< 1 s))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- s 1) (ite (distinct (int_to_pbv q 0) (pzero_extend (- q 1) (ite newvar3 (_ bv1 1) (_ bv0 1)))) (_ bv1 1) (_ bv0 1)))
    (pzero_extend (- s 1) (ite newvar3 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
