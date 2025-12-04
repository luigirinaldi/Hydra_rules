(set-logic ALL)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun v2 () (_ BitVec r))

(assert (distinct 
    (= (psign_extend (- s s) v0) (psign_extend (- s s) v2))
    (= v0 v2)
))
(check-sat)
