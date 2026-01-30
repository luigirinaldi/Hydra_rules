; Opt : 2593
; %newvar6:i32 = var ; newvar6
; %1:i32 = and 1:i32, %newvar6
; %2:i1 = ne 0:i32, %1
; %3:i32 = select %2, 1:i32, 0:i32
; %4:i8 = trunc %3
; %5:i32 = zext %4
; infer %5
; result %1
; 
; zext(trunc((select ((newvar6 & 1) != 0) 1 0)))
;   =>
; newvar6 & 1
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun newvar6 () (_ BitVec r))

; Preconditions:
(assert (< u r))
(assert (> t u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r u) (pextract (- u 1) 0 (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) newvar6)) (int_to_pbv t 1) (int_to_pbv t 0))))
    (bvand (int_to_pbv r 1) newvar6)
))
(check-sat)
