; Opt : 2720
; %symconst_1:i4 = var ; symconst_1
; %newvar0:i4 = var ; newvar0
; %2:i4 = add %symconst_1, %newvar0
; %3:i4 = subnsw %2, %symconst_1
; %4:i8 = sext %3
; infer %4
; %5:i8 = sext %newvar0
; result %5
; 
; sext(((C1 + newvar0) -nsw C1))
;   =>
; sext(newvar0)
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))
(assert (bvsle (int_to_pbv q 0) (bvand (bvxor (bvadd symconst_1 newvar0) symconst_1) (bvxor (bvadd symconst_1 newvar0) (bvsub (bvadd symconst_1 newvar0) symconst_1)))))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s q) (bvsub (bvadd symconst_1 newvar0) symconst_1))
    (psign_extend (- s q) newvar0)
))
(check-sat)
