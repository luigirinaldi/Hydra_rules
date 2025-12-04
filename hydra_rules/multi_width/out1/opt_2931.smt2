(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v1 () (_ BitVec r))

(assert (distinct 
    (= symconst_1 (pzero_extend (- s s) v1))
    (= v1 (pextract symconst_1 (- s 1) 0))
))
(check-sat)
