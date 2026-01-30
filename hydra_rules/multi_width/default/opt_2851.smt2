; Opt : 2851
; %symconst_1:i64 = var ; symconst_1
; %1:i1 = ult 0:i64, %symconst_1
; %v0:i8 = var ; v0
; %3:i8 = width %v0
; %4:i64 = zext %3
; %5:i1 = ult %symconst_1, %4
; %6:i1 = and %1, %5
; pc %6 1:i1
; %7:i64 = zext %v0
; %8:i64 = lshr %7, %symconst_1
; %9:i8 = trunc %8
; infer %9
; %10:i8 = trunc %symconst_1
; %11:i8 = lshr %v0, %10
; result %11
; 
; (0 <u C1) & (C1 <u zext(width(v0)))
;   |= 
; trunc((zext(v0) >>l C1))
;   =>
; v0 >>l trunc(C1)
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
(assert (> t w))
(assert (and (bvult (int_to_pbv t 0) symconst_1) (bvult symconst_1 (pzero_extend (- t w) (int_to_pbv w w)))))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- w 1) 0 (bvlshr (pzero_extend (- t w) v0) symconst_1))
    (bvlshr v0 (pextract (- w 1) 0 symconst_1))
))
(check-sat)
