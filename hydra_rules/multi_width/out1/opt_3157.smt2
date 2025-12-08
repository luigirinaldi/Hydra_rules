(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const w Int)
(declare-fun newvar0 () (_ BitVec w))
(declare-fun symconst_1 () (_ BitVec t))

; Preconditions:
(assert (< s t))
(assert (< w t))
(assert (> t w))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv t 1) (pzero_extend (- t w) (int_to_pbv w w))) (int_to_pbv t 1))))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (pzero_extend (- t w) newvar0))
    (= newvar0 (pextract (- w 1) 0 symconst_1))
))
(check-sat)
