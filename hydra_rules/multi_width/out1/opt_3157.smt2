; Opt : 3157
; %symconst_1:i8 = var ; symconst_1
; %newvar0:i4 = var ; newvar0
; %2:i4 = width %newvar0
; %3:i8 = zext %2
; %4:i8 = shl 1:i8, %3
; %5:i8 = sub %4, 1:i8
; %6:i1 = ule %symconst_1, %5
; pc %6 1:i1
; %7:i8 = zext %newvar0
; %8:i1 = eq %symconst_1, %7
; infer %8
; %9:i4 = trunc %symconst_1
; %10:i1 = eq %newvar0, %9
; result %10
; 
; C1 <=u ((1 << zext(width(newvar0))) - 1)
;   |= 
; C1 == zext(newvar0)
;   =>
; newvar0 == trunc(C1)
(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const w Int)
(declare-fun newvar0 () (_ BitVec w))
(declare-fun symconst_1 () (_ BitVec t))

; Preconditions:
(assert (< s t))
(assert (< w t))
(assert (> t w))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv t 1) (pzero_extend (- t w) (int_to_pbv w w))) (int_to_pbv t 1))))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (pzero_extend (- t w) newvar0))
    (= newvar0 (pextract (- w 1) 0 symconst_1))
))
(check-sat)
