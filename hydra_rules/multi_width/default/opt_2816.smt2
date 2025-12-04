(set-logic ALL)
(declare-const p Int)
(declare-const s Int)
(declare-const q Int)
(declare-fun newvar1 () (_ BitVec p))

(assert (distinct 
    (pextract (pzero_extend (- q p) newvar1) (- s 1) 0)
    (pextract newvar1 (- s 1) 0)
))
(check-sat)
