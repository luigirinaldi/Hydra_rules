; Opt : 2448
; %v2:i2 = var ; v2
; %symconst_1:i2 = var (nonNegative) ; symconst_1
; %2:i2 = and %v2, %symconst_1
; %3:i4 = zext %2
; %4:i8 = zext %3
; infer %4
; %5:i8 = sext %2
; result %5
; 
; zext(zext((v2 & C1 (nonNegative))))
;   =>
; sext((v2 & C1))
(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v2 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (< q t))
(assert (< r t))
(assert (bvsle (int_to_pbv q 0) symconst_1))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t r) (pzero_extend (- r q) (bvand v2 symconst_1)))
    (psign_extend (- t q) (bvand v2 symconst_1))
))
(check-sat)
