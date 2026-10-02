; Opt : 2784
; %v3:i64 = var ; v3
; %1:i64 = and 4294967295:i64, %v3
; %2:i32 = trunc %1
; infer %2
; %3:i32 = trunc %v3
; result %3
; 
; trunc((v3 & 0xFFFFFFFF))
;   =>
; trunc(v3)
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun v3 () (_ BitVec q))

; Preconditions:
(assert (> q s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (bvand (pzero_extend (- q s) (bvnot (int_to_pbv s 0))) v3))
    (pextract (- s 1) 0 v3)
))
(check-sat)
