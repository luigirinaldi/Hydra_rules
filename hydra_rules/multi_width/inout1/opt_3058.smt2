; Opt : 3058
; %v0:i1 = var ; v0
; %1:i32 = zext %v0
; %2:i1 = eq 0:i32, %1
; infer %2
; %3:i1 = xor 1:i1, %v0
; result %3
; 
; zext(v0) == 0
;   =>
; ~v0
(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (= (int_to_pbv r 0) (pzero_extend (- r 1) (ite v0 (_ bv1 1) (_ bv0 1))))
    (not v0)
))
(check-sat)
