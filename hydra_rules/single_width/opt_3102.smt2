(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (= symconst_1 (bvsub (int_to_pbv q 0) v0))
    (= v0 (bvsub (int_to_pbv q 0) symconst_1))
))
(check-sat)
