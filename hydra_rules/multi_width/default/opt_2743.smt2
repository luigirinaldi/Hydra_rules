(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec p))

(assert (distinct 
    (pextract (pzero_extend (- q p) newvar0) (- p 1) 0)
    newvar0
))
(check-sat)
