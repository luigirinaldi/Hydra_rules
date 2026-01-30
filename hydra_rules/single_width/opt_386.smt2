; Opt : 386
; %newvar5:i64 = var ; newvar5
; %newvar2:i64 = var ; newvar2
; %2:i64 = shl 1:i64, %newvar2
; %3:i64 = mul %newvar5, %2
; infer %3
; %4:i64 = shl %newvar5, %newvar2
; result %4
; 
; newvar5 * (1 << newvar2)
;   =>
; newvar5 << newvar2
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar2 () (_ BitVec q))
(declare-fun newvar5 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvmul newvar5 (bvshl (int_to_pbv q 1) newvar2))
    (bvshl newvar5 newvar2)
))
(check-sat)
