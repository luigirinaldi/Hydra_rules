; Opt : 2443
; %newvar0:i32 = var ; newvar0
; %1:i32 = and 1:i32, %newvar0
; %2:i1 = ne 0:i32, %1
; %3:i8 = zext %2
; infer %3
; %4:i8 = trunc %1
; result %4
; 
; zext(((newvar0 & 1) != 0))
;   =>
; trunc((newvar0 & 1))
(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (< 1 u))
(assert (> r u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- u 1) (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) newvar0)) (_ bv1 1) (_ bv0 1)))
    (pextract (- u 1) 0 (bvand (int_to_pbv r 1) newvar0))
))
(check-sat)
