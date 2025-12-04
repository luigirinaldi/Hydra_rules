(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun newvar0 () (_ BitVec r))

(assert (distinct 
    (= symconst_1 (pzero_extend (- s s) newvar0))
    (= newvar0 (pextract symconst_1 (- s 1) 0))
))
(check-sat)
