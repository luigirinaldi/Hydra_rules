(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (pextract (bvsub symconst_1 (pzero_extend (- r q) v0)) (- q 1) 0)
    (bvsub (pextract symconst_1 (- q 1) 0) v0)
))
(check-sat)
