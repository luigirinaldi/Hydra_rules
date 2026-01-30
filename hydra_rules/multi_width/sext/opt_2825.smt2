; Opt : 2825
; %v0:i8 = var ; v0
; %1:i32 = sext %v0
; %symconst_1:i32 = var ; symconst_1
; %3:i32 = sub %1, %symconst_1
; %4:i8 = trunc %3
; infer %4
; %5:i32 = sub 0:i32, %symconst_1
; %6:i8 = trunc %5
; %7:i8 = add %v0, %6
; result %7
; 
; trunc((sext(v0) - C1))
;   =>
; v0 + trunc((0 - C1))
(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec u))

; Preconditions:
(assert (< u r))
(assert (> r u))
(assert (> r u))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- u 1) 0 (bvsub (psign_extend (- r u) v0) symconst_1))
    (bvadd v0 (pextract (- u 1) 0 (bvsub (int_to_pbv r 0) symconst_1)))
))
(check-sat)
