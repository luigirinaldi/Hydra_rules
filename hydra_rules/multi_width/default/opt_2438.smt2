; Opt : 2438
; %symconst_1:i4 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i4 = trunc %v0
; %3:i4 = and %symconst_1, %2
; %4:i8 = zext %3
; infer %4
; %5:i8 = zext %symconst_1
; %6:i8 = and %v0, %5
; result %6
; 
; zext((C1 & trunc(v0)))
;   =>
; v0 & zext(C1)
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< r t))
(assert (< r t))
(assert (> t r))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t r) (bvand symconst_1 (pextract (- r 1) 0 v0)))
    (bvand v0 (pzero_extend (- t r) symconst_1))
))
(check-sat)
