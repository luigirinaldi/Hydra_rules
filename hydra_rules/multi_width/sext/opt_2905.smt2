; Opt : 2905
; %symconst_1:i32 = var ; symconst_1
; %v0:i8 = var ; v0
; %2:i32 = sext %v0
; %3:i32 = add %symconst_1, %2
; %symconst_2:i32 = var ; symconst_2
; %5:i32 = subnsw %3, %symconst_2
; %6:i8 = trunc %5
; infer %6
; %7:i32 = sub %symconst_1, %symconst_2
; %8:i8 = trunc %7
; %9:i8 = add %v0, %8
; result %9
; 
; trunc(((C1 + sext(v0)) -nsw C2))
;   =>
; v0 + trunc((C1 - C2))
(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec u))

; Preconditions:
(assert (< u r))
(assert (> r u))
(assert (> r u))
(assert (bvsle (int_to_pbv r 0) (bvand (bvxor (bvadd symconst_1 (psign_extend (- r u) v0)) symconst_2) (bvxor (bvadd symconst_1 (psign_extend (- r u) v0)) (bvsub (bvadd symconst_1 (psign_extend (- r u) v0)) symconst_2)))))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- u 1) 0 (bvsub (bvadd symconst_1 (psign_extend (- r u) v0)) symconst_2))
    (bvadd v0 (pextract (- u 1) 0 (bvsub symconst_1 symconst_2)))
))
(check-sat)
