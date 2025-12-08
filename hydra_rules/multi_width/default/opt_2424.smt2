(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< 1 r))
(assert (bvult symconst_2 (int_to_pbv r r)))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r 1) (bvxor true (distinct (int_to_pbv r 0) (bvand symconst_2 v0))))
    (bvashr (bvadd symconst_2 (bvsub (int_to_pbv r 1) symconst_2)) (bvand symconst_2 v0))
))
(check-sat)
