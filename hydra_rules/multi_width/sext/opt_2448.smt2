(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-const t Int)
(declare-fun v2 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))

(assert (distinct 
    (pzero_extend (- t r) (pzero_extend (- r q) (bvand v2 symconst_1)))
    (psign_extend (- t q) (bvand v2 symconst_1))
))
(check-sat)
