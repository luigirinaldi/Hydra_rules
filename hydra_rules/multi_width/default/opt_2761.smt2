; Opt : 2761
; %symconst_1:i32 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i32 = zext %v0
; %3:i32 = and %symconst_1, %2
; %4:i8 = trunc %3
; infer %4
; %5:i8 = trunc %symconst_1
; %6:i8 = and %v0, %5
; result %6
; 
; trunc((C1 & zext(v0)))
;   =>
; v0 & trunc(C1)
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< t r))
(assert (> r t))
(assert (> r t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvand symconst_1 (pzero_extend (- r t) v0)))
    (bvand v0 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
