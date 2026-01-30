; Opt : 392
; %newvar2:i32 = var ; newvar2
; %1:i32 = mul 1:i32, %newvar2
; infer %1
; result %newvar2
; 
; newvar2 * 1
;   =>
; newvar2
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar2 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvmul (int_to_pbv q 1) newvar2)
    newvar2
))
(check-sat)
