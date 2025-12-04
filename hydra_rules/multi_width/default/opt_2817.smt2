(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec r))

(assert (distinct 
    (pextract (bvsub (pzero_extend (- r u) newvar0) symconst_1) (- u 1) 0)
    (bvadd newvar0 (pextract (bvsub (int_to_pbv r 0) symconst_1) (- u 1) 0))
))
(check-sat)
