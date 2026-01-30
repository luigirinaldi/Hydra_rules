; Opt : 3503
; %symconst_1:i32 = var ; symconst_1
; %1:i1 = ult 0:i32, %symconst_1
; %v0:i8 = var ; v0
; %3:i8 = width %v0
; %4:i32 = zext %3
; %5:i1 = ule %symconst_1, %4
; %6:i1 = and %1, %5
; pc %6 1:i1
; %7:i32 = zext %v0
; %8:i1 = ult %7, %symconst_1
; infer %8
; %9:i8 = trunc %symconst_1
; %10:i1 = ult %v0, %9
; result %10
; 
; (0 <u C1) & (C1 <=u zext(width(v0)))
;   |= 
; zext(v0) <u C1
;   =>
; v0 <u trunc(C1)
(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const v Int)
(declare-fun symconst_1 () (_ BitVec t))
(declare-fun v0 () (_ BitVec v))

; Preconditions:
(assert (< s t))
(assert (< v t))
(assert (> t v))
(assert (and (bvult (int_to_pbv t 0) symconst_1) (bvule symconst_1 (pzero_extend (- t v) (int_to_pbv v v)))))

; assert lhs != rhs:
(assert (distinct 
    (bvult (pzero_extend (- t v) v0) symconst_1)
    (bvult v0 (pextract (- v 1) 0 symconst_1))
))
(check-sat)
