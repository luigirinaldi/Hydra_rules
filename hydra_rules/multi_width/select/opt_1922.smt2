(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun v0 () Bool)
(declare-fun v3 () (_ BitVec s))

; Preconditions:
(assert (< 1 q))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv q 0) (pzero_extend (- q 1) (ite v0 (_ bv1 1) (_ bv0 1)))) symconst_2 v3)
    (ite v0 symconst_2 v3)
))
(check-sat)
