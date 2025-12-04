(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun newvar1 () (_ BitVec q))

(assert (distinct 
    (pextract (bvadd symconst_1 (pzero_extend (- r t) newvar1)) (- t 1) 0)
    (bvadd newvar1 (pextract symconst_1 (- t 1) 0))
))
(check-sat)
