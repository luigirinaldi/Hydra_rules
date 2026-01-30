; Opt : 1295
; %newvar2:i64 = var ; newvar2
; %1:i64 = and 18446744073709551615:i64, %newvar2
; %2:i64 = xor 18446744073709551615:i64, %1
; infer %2
; %3:i64 = sub 18446744073709551615:i64, %newvar2
; result %3
; 
; ~(newvar2 & 0xFFFFFFFFFFFFFFFF)
;   =>
; 0xFFFFFFFFFFFFFFFF - newvar2
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar2 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvxor (bvnot (int_to_pbv q 0)) (bvand (bvnot (int_to_pbv q 0)) newvar2))
    (bvsub (bvnot (int_to_pbv q 0)) newvar2)
))
(check-sat)
