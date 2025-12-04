(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun symconst_6 () (_ BitVec p))
(declare-fun symconst_5 () (_ BitVec q))
(declare-fun newvar0 () (_ BitVec t))

(assert (distinct 
    (distinct symconst_6 (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)) symconst_5 symconst_6))
    (pextract newvar0 (- q 1) 0)
))
(check-sat)
