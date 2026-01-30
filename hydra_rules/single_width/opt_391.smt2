; Opt : 391
; %newvar0:i8 = var ; newvar0
; %symconst_1:i8 = var ; symconst_1
; %2:i8 = sub %newvar0, %symconst_1
; %3:i8 = mul 255:i8, %2
; infer %3
; %4:i8 = sub %symconst_1, %newvar0
; result %4
; 
; (newvar0 - C1) * 0xFF
;   =>
; C1 - newvar0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvmul (bvnot (int_to_pbv q 0)) (bvsub newvar0 symconst_1))
    (bvsub symconst_1 newvar0)
))
(check-sat)
