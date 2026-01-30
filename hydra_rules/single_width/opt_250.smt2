; Opt : 250
; %v0:i8 = var ; v0
; %symconst_2:i8 = var ; symconst_2
; %2:i8 = sub %v0, %symconst_2
; %3:i8 = sub 0:i8, %2
; infer %3
; %4:i8 = sub %symconst_2, %v0
; result %4
; 
; 0 - (v0 - C2)
;   =>
; C2 - v0
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (int_to_pbv q 0) (bvsub v0 symconst_2))
    (bvsub symconst_2 v0)
))
(check-sat)
