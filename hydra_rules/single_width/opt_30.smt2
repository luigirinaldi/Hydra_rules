; Opt : 30
; %v0:i64 = var ; v0
; %1:i64 = xor 18446744073709551615:i64, %v0
; %2:i64 = add 1:i64, %1
; infer %2
; %3:i64 = mul 18446744073709551615:i64, %v0
; result %3
; 
; ~v0 + 1
;   =>
; v0 * 0xFFFFFFFFFFFFFFFF
(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvadd (int_to_pbv q 1) (bvxor (bvnot (int_to_pbv q 0)) v0))
    (bvmul (bvnot (int_to_pbv q 0)) v0)
))
(check-sat)
