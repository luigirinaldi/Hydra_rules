; Opt : 503
; %v0:i16 = var ; v0
; %symconst_1:i16 = var (powerOfTwo) ; symconst_1
; %2:i16 = udiv %v0, %symconst_1
; infer %2
; %3:i16 = logb %symconst_1
; %4:i16 = lshr %v0, %3
; result %4
; 
; v0 /u C1 (powerOfTwo)
;   =>
; v0 >>l logb(C1)
(set-logic ALL)
(declare-const q Int)
(declare-fun logb_symconst_1 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (= (bvand symconst_1 (bvsub symconst_1 (int_to_pbv q 1))) (int_to_pbv q 0)))
(assert (= symconst_1 (bvshl (int_to_pbv q 1) logb_symconst_1)))
(assert (distinct symconst_1 (int_to_pbv q 0)))
(assert (bvult logb_symconst_1 (int_to_pbv q q)))

; assert lhs != rhs:
(assert (distinct 
    (bvudiv v0 symconst_1)
    (bvlshr v0 logb_symconst_1)
))
(check-sat)
