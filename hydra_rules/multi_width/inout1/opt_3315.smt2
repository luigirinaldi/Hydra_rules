(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar5 () Bool)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< r s))
(assert (< 1 q))
(assert (< 1 s))
(assert (> q r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (pzero_extend (- s 1) (ite v0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- s r) (pextract (- r 1) 0 (pzero_extend (- q 1) (ite newvar5 (_ bv1 1) (_ bv0 1))))))
    (xor v0 newvar5)
))
(check-sat)
