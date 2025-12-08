(set-logic ALL)
(declare-const t Int)
(declare-const q Int)
(declare-const s Int)
(declare-const r Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun v3 () (_ BitVec t))

; Preconditions:
(assert (< q r))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r q) v0)) symconst_2 v3)
    (ite v0 symconst_2 v3)
))
(check-sat)
