(set-logic ALL)
(declare-const s Int)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))

(assert (distinct 
    (psign_extend (- s q) (bvadd (int_to_pbv q 0) newvar0))
    (psign_extend (- s q) newvar0)
))
(check-sat)
