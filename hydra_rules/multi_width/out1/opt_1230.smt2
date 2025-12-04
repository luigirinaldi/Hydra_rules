(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun newvar1 () (_ BitVec r))

(assert (distinct 
    (bvxor (int_to_pbv s 1) (distinct symconst_1 (pzero_extend (- s s) newvar1)))
    (= newvar1 (pextract symconst_1 (- s 1) 0))
))
(check-sat)
