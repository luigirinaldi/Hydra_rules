; Opt : 625
; %newvar0:i16 = var ; newvar0
; %1:i16 = and 65535:i16, %newvar0
; infer %1
; result %newvar0
; 
; newvar0 & 0xFFFF
;   =>
; newvar0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvand (bvnot (int_to_pbv q 0)) newvar0)
    newvar0
))
(check-sat)
