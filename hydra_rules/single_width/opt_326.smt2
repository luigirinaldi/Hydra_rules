; Opt : 326
; %v0:i8 = var ; v0
; %1:i8 = sub 0:i8, %v0
; %symconst_2:i8 = var ; symconst_2
; %3:i8 = subnsw %1, %symconst_2
; infer %3
; %4:i8 = sub 0:i8, %symconst_2
; %5:i8 = sub %4, %v0
; result %5
; 
; (0 - v0) -nsw C2
;   =>
; (0 - C2) - v0
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (bvsle (int_to_pbv r 0) (bvand (bvxor (bvsub (int_to_pbv r 0) v0) symconst_2) (bvxor (bvsub (int_to_pbv r 0) v0) (bvsub (bvsub (int_to_pbv r 0) v0) symconst_2)))))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (bvsub (int_to_pbv r 0) v0) symconst_2)
    (bvsub (bvsub (int_to_pbv r 0) symconst_2) v0)
))
(check-sat)
