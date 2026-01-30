; Opt : 1669
; %v0:i32 = var ; v0
; %newvar0:i32 = var ; newvar0
; %2:i32 = shl 1:i32, %newvar0
; %3:i32 = and %v0, %2
; %4:i1 = ne 0:i32, %3
; %5:i32 = select %4, 1:i32, 0:i32
; infer %5
; %6:i32 = lshr %3, %newvar0
; result %6
; 
; select ((v0 & (1 << newvar0)) != 0) 1 0
;   =>
; (v0 & (1 << newvar0)) >>l newvar0
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (bvand v0 (bvshl (int_to_pbv r 1) newvar0))) (int_to_pbv r 1) (int_to_pbv r 0))
    (bvlshr (bvand v0 (bvshl (int_to_pbv r 1) newvar0)) newvar0)
))
(check-sat)
