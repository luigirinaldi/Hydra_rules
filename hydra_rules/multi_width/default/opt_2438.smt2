(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (pzero_extend (- t r) (bvand symconst_1 (pextract v0 (- r 1) 0)))
    (bvand v0 (pzero_extend (- t r) symconst_1))
))
(check-sat)
