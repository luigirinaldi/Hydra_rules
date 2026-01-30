; Opt : 64
; %v0:i8 = var ; v0
; %symconst_2:i8 = var ; symconst_2
; %2:i8 = sub %v0, %symconst_2
; %3:i8 = add 255:i8, %2
; infer %3
; %4:i8 = xor 255:i8, %symconst_2
; %5:i8 = add %v0, %4
; result %5
; 
; (v0 - C2) + 0xFF
;   =>
; v0 + ~C2
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvadd (bvnot (int_to_pbv r 0)) (bvsub v0 symconst_2))
    (bvadd v0 (bvxor (bvnot (int_to_pbv r 0)) symconst_2))
))
(check-sat)
