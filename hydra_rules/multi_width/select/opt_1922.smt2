; Opt : 1922
; %v0:i1 = var ; v0
; %1:i32 = zext %v0
; %2:i1 = ne 0:i32, %1
; %symconst_2:i32 = var ; symconst_2
; %v3:i32 = var ; v3
; %5:i32 = select %2, %symconst_2, %v3
; infer %5
; %6:i32 = select %v0, %symconst_2, %v3
; result %6
; 
; select (zext(v0) != 0) C2 v3
;   =>
; select v0 C2 v3
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_2 () (_ BitVec t))
(declare-fun v0 () Bool)
(declare-fun v3 () (_ BitVec t))

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r 1) (ite v0 (_ bv1 1) (_ bv0 1)))) symconst_2 v3)
    (ite v0 symconst_2 v3)
))
(check-sat)
