; Opt : 263
; %v0:i8 = var ; v0
; %symconst_1:i8 = var ; symconst_1
; %2:i8 = add %v0, %symconst_1
; %3:i8 = sub %2, %symconst_1
; infer %3
; result %v0
; 
; (v0 + C1) - C1
;   =>
; v0
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (bvadd v0 symconst_1) symconst_1)
    v0
))
(check-sat)
