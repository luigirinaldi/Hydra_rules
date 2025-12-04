(set-logic ALL)
(declare-const u Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun newvar5 () (_ BitVec r))

(assert (distinct 
    (distinct (pzero_extend (- u u) v0) (pzero_extend (- u t) (pextract (pzero_extend (- s u) newvar5) (- t 1) 0)))
    (bvxor v0 newvar5)
))
(check-sat)
