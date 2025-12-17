(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))

; Preconditions:
(assert (< r u))
(assert (< r u))
(assert (< r u))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- u r) (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (psign_extend (- u r) symconst_1) (psign_extend (- u r) symconst_2))
))
(check-sat)
