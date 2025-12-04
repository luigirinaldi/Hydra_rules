(set-logic ALL)
(declare-const s Int)
(declare-fun v3 () (_ BitVec p))
(declare-fun v6 () (_ BitVec r))

(assert (distinct 
    (bvsle (pzero_extend (- s s) v3) (pzero_extend (- s s) v6))
    (bvule v3 v6)
))
(check-sat)
