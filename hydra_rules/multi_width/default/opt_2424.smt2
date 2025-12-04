(set-logic ALL)
(declare-const u Int)
(declare-fun symconst_2 () (_ BitVec p))
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (pzero_extend (- u u) (bvxor (int_to_pbv u 1) (distinct (int_to_pbv u 0) (bvand symconst_2 v0))))
    (bvashr (bvadd symconst_2 (bvsub (int_to_pbv u 1) symconst_2)) (bvand symconst_2 v0))
))
(check-sat)
