; Opt : 1784
; %newvar0:i32 = var ; newvar0
; %1:i32 = and 2:i32, %newvar0
; %2:i1 = ne 0:i32, %1
; %3:i32 = select %2, 2:i32, 0:i32
; infer %3
; result %1
; 
; select ((newvar0 & 2) != 0) 2 0
;   =>
; newvar0 & 2
(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 2) newvar0)) (int_to_pbv t 2) (int_to_pbv t 0))
    (bvand (int_to_pbv t 2) newvar0)
))
(check-sat)
