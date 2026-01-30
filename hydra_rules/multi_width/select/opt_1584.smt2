; Opt : 1584
; %newvar0:i8 = var ; newvar0
; %1:i8 = and 1:i8, %newvar0
; %2:i32 = zext %1
; %3:i1 = ne 0:i32, %2
; %4:i32 = select %3, 1:i32, 0:i32
; infer %4
; result %2
; 
; select (zext((newvar0 & 1)) != 0) 1 0
;   =>
; zext((newvar0 & 1))
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r u))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) newvar0))) (int_to_pbv u 1) (int_to_pbv u 0))
    (pzero_extend (- u r) (bvand (int_to_pbv r 1) newvar0))
))
(check-sat)
