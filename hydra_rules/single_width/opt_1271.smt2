(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (bvxor (int_to_pbv q 1) (= (int_to_pbv q 0) v0))
    (bvslt (int_to_pbv q 0) v0)
))
(check-sat)
