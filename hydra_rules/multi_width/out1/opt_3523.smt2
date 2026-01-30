; Opt : 3523
; %symconst_1:i64 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i8 = width %v0
; %3:i64 = zext %2
; %4:i64 = shl 1:i64, %3
; %5:i64 = sub %4, 1:i64
; %6:i1 = ule %symconst_1, %5
; pc %6 1:i1
; %7:i64 = zext %v0
; %8:i1 = ult %7, %symconst_1
; infer %8
; %9:i8 = trunc %symconst_1
; %10:i1 = ult %v0, %9
; result %10
; 
; C1 <=u ((1 << zext(width(v0))) - 1)
;   |= 
; zext(v0) <u C1
;   =>
; v0 <u trunc(C1)
(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const w Int)
(declare-fun symconst_1 () (_ BitVec t))
(declare-fun v0 () (_ BitVec w))

; Preconditions:
(assert (< s t))
(assert (< w t))
(assert (> t w))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv t 1) (pzero_extend (- t w) (int_to_pbv w w))) (int_to_pbv t 1))))

; assert lhs != rhs:
(assert (distinct 
    (bvult (pzero_extend (- t w) v0) symconst_1)
    (bvult v0 (pextract (- w 1) 0 symconst_1))
))
(check-sat)
