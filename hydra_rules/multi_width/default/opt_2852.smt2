; Opt : 2852
; %symconst_1:i32 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i32 = zext %v0
; %3:i32 = sub %symconst_1, %2
; %4:i8 = trunc %3
; infer %4
; %5:i8 = trunc %symconst_1
; %6:i8 = sub %5, %v0
; result %6
; 
; trunc((C1 - zext(v0)))
;   =>
; trunc(C1) - v0
(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (> r q))
(assert (> r q))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- q 1) 0 (bvsub symconst_1 (pzero_extend (- r q) v0)))
    (bvsub (pextract (- q 1) 0 symconst_1) v0)
))
(check-sat)
