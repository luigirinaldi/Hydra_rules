(set-logic ALL)
(declare-const t Int)
(declare-const u Int)
(declare-const s Int)
(declare-const r Int)
(declare-fun newvar6 () (_ BitVec r))

; Preconditions:
(assert (< u r))
(assert (> s u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r u) (pextract (- u 1) 0 (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) newvar6)) (int_to_pbv s 1) (int_to_pbv t 0))))
    (bvand (int_to_pbv r 1) newvar6)
))
(check-sat)
