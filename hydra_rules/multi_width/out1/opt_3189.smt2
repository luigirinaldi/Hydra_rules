(set-logic ALL)
(declare-const t Int)
(declare-const q Int)
(declare-fun symconst_6 () (_ BitVec q))
(declare-fun symconst_5 () (_ BitVec q))
(declare-fun newvar0 () (_ BitVec t))

; Preconditions:
(assert (> t q))
(assert (bvult symconst_6 symconst_5))

; assert lhs != rhs:
(assert (distinct 
    (distinct symconst_6 (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)) symconst_5 symconst_6))
    (pextract (- q 1) 0 newvar0)
))
(check-sat)
