; Opt : 781
; %symconst_2:i32 = var ; symconst_2
; %v0:i1 = var ; v0
; %2:i32 = select %v0, 0:i32, %symconst_2
; %3:i32 = and %symconst_2, %2
; infer %3
; result %2
; 
; C2 & (select v0 0 C2)
;   =>
; select v0 0 C2
(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () Bool)

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_2 (ite v0 (int_to_pbv r 0) symconst_2))
    (ite v0 (int_to_pbv r 0) symconst_2)
))
(check-sat)
