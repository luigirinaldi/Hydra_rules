(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun newvar2 () (_ BitVec q))

(assert (distinct 
    (pextract (bvor symconst_1 (pzero_extend (- r t) newvar2)) (- t 1) 0)
    (bvor newvar2 (pextract symconst_1 (- t 1) 0))
))
(check-sat)
