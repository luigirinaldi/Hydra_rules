(set-logic ALL)
(declare-const t Int)
(declare-fun symconst_2 () (_ BitVec t))
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< 1 t))
(assert (bvult symconst_2 q))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (= (int_to_pbv t 0) (bvand symconst_2 v0)))
    (bvashr (bvadd symconst_2 (bvsub (int_to_pbv t 1) symconst_2)) (bvand symconst_2 v0))
))
(check-sat)
