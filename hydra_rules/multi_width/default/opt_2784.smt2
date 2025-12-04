(set-logic ALL)
(declare-const s Int)
(declare-const q Int)
(declare-fun v3 () (_ BitVec q))

(assert (distinct 
    (pextract (bvand (int_to_pbv q 4294967295) v3) (- s 1) 0)
    (pextract v3 (- s 1) 0)
))
(check-sat)
