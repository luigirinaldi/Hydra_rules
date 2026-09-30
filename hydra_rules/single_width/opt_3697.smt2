; Opt : 3697
; %v0:i32 = var ; v0
; %v1:i32 = var ; v1
; %2:i32 = subnsw %v0, %v1
; %3:i1 = slt %2, 0:i32
; infer %3
; %4:i1 = slt %v0, %v1
; result %4
; 
; (v0 -nsw v1) <s 0
;   =>
; v0 <s v1
(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v1 () (_ BitVec r))

; Preconditions:
(assert (bvsle (int_to_pbv r 0) (bvand (bvxor v0 v1) (bvxor v0 (bvsub v0 v1)))))

; assert lhs != rhs:
(assert (distinct 
    (bvslt (bvsub v0 v1) (int_to_pbv r 0))
    (bvslt v0 v1)
))
(check-sat)
