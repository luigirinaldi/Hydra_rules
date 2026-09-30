; Opt : 67
; %symconst_2:i8 = var ; symconst_2
; %v0:i8 = var ; v0
; %2:i8 = sdiv %v0, 1:i8
; %3:i8 = add %symconst_2, %2
; infer %3
; %4:i8 = add %symconst_2, %v0
; result %4
; 
; C2 + (v0 /s 1)
;   =>
; v0 + C2
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvadd symconst_2 (bvsdiv v0 (int_to_pbv r 1)))
    (bvadd symconst_2 v0)
))
(check-sat)
