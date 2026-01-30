; Opt : 3102
; %symconst_1:i8 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i8 = sub 0:i8, %v0
; %3:i1 = eq %symconst_1, %2
; infer %3
; %4:i8 = sub 0:i8, %symconst_1
; %5:i1 = eq %v0, %4
; result %5
; 
; C1 == (0 - v0)
;   =>
; v0 == (0 - C1)
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (bvsub (int_to_pbv q 0) v0))
    (= v0 (bvsub (int_to_pbv q 0) symconst_1))
))
(check-sat)
