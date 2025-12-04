(set-logic ALL)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec p))
(declare-fun newvar1 () (_ BitVec r))

(assert (distinct 
    (distinct (pzero_extend (- s s) newvar0) (pzero_extend (- s s) newvar1))
    (bvxor newvar0 newvar1)
))
(check-sat)
