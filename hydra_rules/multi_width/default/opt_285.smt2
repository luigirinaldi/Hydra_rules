(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun newvar4 () (_ BitVec s))

(assert (distinct 
    (bvsub (pextract (bvadd symconst_1 newvar4) (- q 1) 0) symconst_2)
    (pextract newvar4 (- q 1) 0)
))
(check-sat)
