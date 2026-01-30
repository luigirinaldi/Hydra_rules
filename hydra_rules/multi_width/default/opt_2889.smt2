; Opt : 2889
; %v0:i8 = var ; v0
; %1:i32 = zext %v0
; %symconst_1:i32 = var ; symconst_1
; %3:i32 = shl %1, %symconst_1
; %4:i8 = trunc %3
; infer %4
; %5:i32 = shl 1:i32, %symconst_1
; %6:i8 = trunc %5
; %7:i8 = mul %v0, %6
; result %7
; 
; trunc((zext(v0) << C1))
;   =>
; v0 * trunc((1 << C1))
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
    (pextract (- u 1) 0 (bvshl (pzero_extend (- r u) v0) symconst_1))
    (bvmul v0 (pextract (- u 1) 0 (bvshl (int_to_pbv r 1) symconst_1)))
))
(check-sat)
