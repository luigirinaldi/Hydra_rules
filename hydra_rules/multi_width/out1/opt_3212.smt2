(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (distinct (int_to_pbv r 0) (bvurem v0 (int_to_pbv r 2)))
    (pextract v0 (- r 1) 0)
))
(check-sat)
