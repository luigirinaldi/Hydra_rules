; Opt : 1978
; %v0:i32 = var ; v0
; %1:i32 = and 536870912:i32, %v0
; %2:i1 = ne 0:i32, %1
; %3:i32 = select %2, 536870912:i32, 0:i32
; infer %3
; result %1
; 
; select ((v0 & 0x20000000) != 0) 0x20000000 0
;   =>
; v0 & 0x20000000
(set-logic ALL)
(declare-const t Int)
(declare-fun v0 () (_ BitVec t))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 536870912) v0)) (int_to_pbv t 536870912) (int_to_pbv t 0))
    (bvand (int_to_pbv t 536870912) v0)
))
(check-sat)
