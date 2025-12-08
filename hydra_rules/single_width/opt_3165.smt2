(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun newvar5 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (= (int_to_pbv r 0) (bvsub newvar0 newvar5))
    (= newvar0 newvar5)
))
(check-sat)
