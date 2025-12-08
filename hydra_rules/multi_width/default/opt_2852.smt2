(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (> r q))
(assert (> r q))
(assert (< q r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- q 1) 0 (bvsub symconst_1 (pzero_extend (- r q) v0)))
    (bvsub (pextract (- q 1) 0 symconst_1) v0)
))
(check-sat)
