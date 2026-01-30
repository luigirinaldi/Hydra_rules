; Opt : 2599
; %v0:i8 = var ; v0
; %1:i8 = and 1:i8, %v0
; %2:i32 = zext %1
; %3:i1 = ne 0:i32, %2
; %4:i8 = zext %3
; infer %4
; result %1
; 
; zext((zext((v0 & 1)) != 0))
;   =>
; v0 & 1
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r 1) (ite (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) v0))) (_ bv1 1) (_ bv0 1)))
    (bvand (int_to_pbv r 1) v0)
))
(check-sat)
