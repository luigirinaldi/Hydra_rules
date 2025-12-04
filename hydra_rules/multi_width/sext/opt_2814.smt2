(set-logic ALL)
(declare-const r Int)
(declare-const w Int)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () (_ BitVec t))

(assert (distinct 
    (pextract (bvor symconst_2 (bvand symconst_1 (pzero_extend (- s w) v0))) (- w 1) 0)
    (bvor v0 (pextract symconst_2 (- w 1) 0))
))
(check-sat)
