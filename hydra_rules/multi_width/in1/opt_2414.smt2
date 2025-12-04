(set-logic ALL)
(declare-const x Int)
(declare-const q Int)
(declare-const t Int)
(declare-const w Int)
(declare-const s Int)
(declare-fun newvar2 () (_ BitVec q))
(declare-fun newvar7 () (_ BitVec s))

(assert (distinct 
    (pzero_extend (- x t) (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t q) newvar2) (pzero_extend (- t s) newvar7))))
    (pextract (bvor (pzero_extend (- w q) newvar2) (pzero_extend (- w s) newvar7)) (- x 1) 0)
))
(check-sat)
