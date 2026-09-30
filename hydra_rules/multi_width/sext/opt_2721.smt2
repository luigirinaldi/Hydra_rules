; Opt : 2721
; %v0:i4 = var ; v0
; %symconst_1:i4 = var ; symconst_1
; %2:i4 = add %v0, %symconst_1
; %3:i4 = subnsw %2, %symconst_1
; %4:i8 = sext %3
; infer %4
; %5:i8 = sext %v0
; result %5
; 
; sext(((v0 + C1) -nsw C1))
;   =>
; sext(v0)
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))
(assert (bvsle (int_to_pbv q 0) (bvand (bvxor (bvadd v0 symconst_1) symconst_1) (bvxor (bvadd v0 symconst_1) (bvsub (bvadd v0 symconst_1) symconst_1)))))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s q) (bvsub (bvadd v0 symconst_1) symconst_1))
    (psign_extend (- s q) v0)
))
(check-sat)
