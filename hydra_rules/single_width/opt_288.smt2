; Opt : 288
; %newvar1:i32 = var ; newvar1
; %1:i32 = sub %newvar1, 0:i32
; infer %1
; result %newvar1
; 
; newvar1 - 0
;   =>
; newvar1
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub newvar1 (int_to_pbv q 0))
    newvar1
))
(check-sat)
