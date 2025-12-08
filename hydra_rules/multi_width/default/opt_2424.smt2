(set-logic ALL)
(declare-const u Int)
(declare-fun symconst_2 () (_ BitVec u))
(declare-fun v0 () (_ BitVec u))

; Preconditions:
(assert (< u u))
(assert (bvult symconst_2 q))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- u u) (bvxor (int_to_pbv u 1) (distinct (int_to_pbv u 0) (bvand symconst_2 v0))))
    (bvashr (bvadd symconst_2 (bvsub (int_to_pbv u 1) symconst_2)) (bvand symconst_2 v0))
))
(check-sat)
