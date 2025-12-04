(set-logic ALL)
(declare-const s Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (pextract (bvadd (int_to_pbv q 0) v0) (- s 1) 0)
    (pextract v0 (- s 1) 0)
))
(check-sat)
