(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun newvar1 () (_ BitVec 1))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))

; Preconditions:
(assert (< q t))
(assert (< q t))
(assert (< r u))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- t q) (ite (= newvar1 (_ bv1 1)) symconst_1 symconst_2))
    (ite (= newvar1 (_ bv1 1)) (psign_extend (- t q) symconst_1) (psign_extend (- u r) symconst_2))
))
(check-sat)
