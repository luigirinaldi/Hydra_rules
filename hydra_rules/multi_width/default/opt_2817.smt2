(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec u))
(declare-fun symconst_1 () (_ BitVec r))

; Preconditions:
(assert (< u r))
(assert (> r u))
(assert (> r u))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- u 1) 0 (bvsub (pzero_extend (- r u) newvar0) symconst_1))
    (bvadd newvar0 (pextract (- u 1) 0 (bvsub (int_to_pbv r 0) symconst_1)))
))
(check-sat)
