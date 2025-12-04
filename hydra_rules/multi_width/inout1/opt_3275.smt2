(set-logic ALL)
(declare-const u Int)
(declare-fun newvar2 () (_ BitVec q))
(declare-fun newvar1 () (_ BitVec t))

(assert (distinct 
    (distinct (int_to_pbv u 0) (bvor (pzero_extend (- u u) newvar2) (pzero_extend (- u u) (bvxor (int_to_pbv u 1) newvar1))))
    (bvule newvar1 newvar2)
))
(check-sat)
