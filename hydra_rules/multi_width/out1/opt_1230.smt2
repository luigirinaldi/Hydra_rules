; Opt : 1230
; %symconst_1:i8 = var ; symconst_1
; %newvar1:i4 = var ; newvar1
; %2:i4 = width %newvar1
; %3:i8 = zext %2
; %4:i8 = shl 1:i8, %3
; %5:i8 = sub %4, 1:i8
; %6:i1 = ule %symconst_1, %5
; pc %6 1:i1
; %7:i8 = zext %newvar1
; %8:i1 = ne %symconst_1, %7
; %9:i1 = xor 1:i1, %8
; infer %9
; %10:i4 = trunc %symconst_1
; %11:i1 = eq %newvar1, %10
; result %11
; 
; C1 <=u ((1 << zext(width(newvar1))) - 1)
;   |= 
; ~(C1 != zext(newvar1))
;   =>
; newvar1 == trunc(C1)
(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const x Int)
(declare-fun newvar1 () (_ BitVec x))
(declare-fun symconst_1 () (_ BitVec t))

; Preconditions:
(assert (< s t))
(assert (< x t))
(assert (> t x))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv t 1) (pzero_extend (- t x) (int_to_pbv x x))) (int_to_pbv t 1))))

; assert lhs != rhs:
(assert (distinct 
    (not (distinct symconst_1 (pzero_extend (- t x) newvar1)))
    (= newvar1 (pextract (- x 1) 0 symconst_1))
))
(check-sat)
