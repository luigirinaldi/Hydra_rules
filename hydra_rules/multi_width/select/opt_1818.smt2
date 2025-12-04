(set-logic ALL)
(declare-const u Int)
(declare-const r Int)
(declare-const q Int)
(declare-const t Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun newvar5 () (_ BitVec s))

(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r q) newvar0)) newvar5 (int_to_pbv t 0))
    (ite newvar0 newvar5 (int_to_pbv u 0))
))
(check-sat)
