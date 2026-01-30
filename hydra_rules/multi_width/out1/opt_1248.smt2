; Opt : 1248
; %v0:i64 = var ; v0
; %1:i64 = sub %v0, 1:i64 (hasExternalUses)
; %2:i64 = and 1:i64, %1
; %3:i1 = ne 0:i64, %2
; %4:i1 = xor 1:i1, %3
; infer %4
; %5:i1 = trunc %v0
; result %5
; 
; ~(((v0 - 1) & 1) != 0)
;   =>
; trunc(v0)
(set-logic ALL)
(declare-const t Int)
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (> t 1))

; assert lhs != rhs:
(assert (distinct 
    (ite (not (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) (bvsub v0 (int_to_pbv t 1))))) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 v0)
))
(check-sat)
