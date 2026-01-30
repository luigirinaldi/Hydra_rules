; Opt : 2483
; %v0:i32 = var ; v0
; %1:i32 = and 1:i32, %v0
; %2:i1 = eq 0:i32, %1
; %3:i32 = zext %2
; infer %3
; %4:i32 = sub 1:i32, %1
; result %4
; 
; zext(((v0 & 1) == 0))
;   =>
; 1 - (v0 & 1)
(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r 1) (ite (= (int_to_pbv r 0) (bvand (int_to_pbv r 1) v0)) (_ bv1 1) (_ bv0 1)))
    (bvsub (int_to_pbv r 1) (bvand (int_to_pbv r 1) v0))
))
(check-sat)
