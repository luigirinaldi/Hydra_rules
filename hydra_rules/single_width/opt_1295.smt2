(set-logic ALL)
(declare-const q Int)
(declare-fun newvar2 () (_ BitVec r))

(assert (distinct 
    (bvxor (int_to_pbv q 18446744073709551615) (bvand (int_to_pbv q 18446744073709551615) newvar2))
    (bvsub (int_to_pbv q 18446744073709551615) newvar2)
))
(check-sat)
