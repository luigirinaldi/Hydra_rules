(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const q Int)
(declare-const t Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun v3 () (_ BitVec t))

(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r q) v0)) symconst_2 v3)
    (ite v0 symconst_2 v3)
))
(check-sat)
