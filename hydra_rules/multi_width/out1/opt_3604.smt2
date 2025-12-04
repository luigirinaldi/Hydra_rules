(set-logic ALL)
(declare-const s Int)
(declare-fun v5 () (_ BitVec p))
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (bvslt (pzero_extend (- s s) v5) (pzero_extend (- s s) v0))
    (bvult v5 v0)
))
(check-sat)
