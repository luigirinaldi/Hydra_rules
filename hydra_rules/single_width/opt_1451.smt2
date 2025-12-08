(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_3 () (_ BitVec q))
(declare-fun symconst_4 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvlshr (bvand v0 symconst_3) symconst_4)
    (bvlshr v0 symconst_4)
))
(check-sat)
