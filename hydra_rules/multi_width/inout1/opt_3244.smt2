; Opt : 3244
; %v0:i1 = var ; v0
; %1:i32 = zext %v0
; %newvar52:i1 = var ; newvar52
; %3:i32 = zext %newvar52
; %4:i32 = xor %1, %3
; %5:i1 = ne 0:i32, %4
; infer %5
; %6:i1 = xor %v0, %newvar52
; result %6
; 
; (zext(v0) ^ zext(newvar52)) != 0
;   =>
; v0 ^ newvar52
(set-logic ALL)
(declare-const t Int)
(declare-fun newvar52 () Bool)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< 1 t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv t 0) (bvxor (pzero_extend (- t 1) (ite v0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- t 1) (ite newvar52 (_ bv1 1) (_ bv0 1)))))
    (xor v0 newvar52)
))
(check-sat)
