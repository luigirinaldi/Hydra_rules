(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar3 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (< q t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (distinct (int_to_pbv r 0) (pzero_extend (- r q) newvar3)) (_ bv1 1) (_ bv0 1)))
    (pzero_extend (- t q) newvar3)
))
(check-sat)
