(set-logic ALL)
(declare-const p Int)
(declare-const s Int)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec p))

(assert (distinct 
    (pextract (pextract newvar0 (- q 1) 0) (- s 1) 0)
    (pextract newvar0 (- s 1) 0)
))
(check-sat)
