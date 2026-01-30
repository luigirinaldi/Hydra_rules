; Opt : 3487
; %newvar0:i16 = var ; newvar0
; %1:i16 = and 1:i16, %newvar0
; %2:i32 = zext %1
; %3:i1 = ne 0:i32, %2
; infer %3
; %4:i1 = trunc %newvar0
; result %4
; 
; zext((newvar0 & 1)) != 0
;   =>
; trunc(newvar0)
(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (> r 1))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) newvar0))) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 newvar0)
))
(check-sat)
