(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun newvar24 () (_ BitVec s))

(assert (distinct 
    (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t t) newvar0) (pzero_extend (- t t) newvar24)))
    (bvor newvar0 newvar24)
))
(check-sat)
