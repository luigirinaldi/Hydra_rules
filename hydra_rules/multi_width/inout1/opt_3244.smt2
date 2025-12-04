(set-logic ALL)
(declare-const t Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun newvar52 () (_ BitVec s))

(assert (distinct 
    (distinct (int_to_pbv t 0) (bvxor (pzero_extend (- t t) v0) (pzero_extend (- t t) newvar52)))
    (bvxor v0 newvar52)
))
(check-sat)
