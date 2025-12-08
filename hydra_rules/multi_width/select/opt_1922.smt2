(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun v0 () (_ BitVec 1))
(declare-fun v3 () (_ BitVec t))

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r 1) v0)) symconst_2 v3)
    (ite v0 symconst_2 v3)
))
(check-sat)
