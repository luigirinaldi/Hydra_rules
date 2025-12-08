(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun newvar4 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (> r q))
(assert (> r q))
(assert (= symconst_1 (pzero_extend (- r q) symconst_2)))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (pextract (- q 1) 0 (bvadd symconst_1 newvar4)) symconst_2)
    (pextract (- q 1) 0 newvar4)
))
(check-sat)
