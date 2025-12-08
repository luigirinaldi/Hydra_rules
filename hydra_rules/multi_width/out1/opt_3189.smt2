(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))
(declare-fun symconst_5 () (_ BitVec q))
(declare-fun symconst_6 () (_ BitVec q))

; Preconditions:
(assert (> t 1))
(assert (bvult symconst_6 symconst_5))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct symconst_6 (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)) symconst_5 symconst_6)) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 newvar0)
))
(check-sat)
