; Opt : 2456
; %v0:i1 = var ; v0
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %3:i32 = select %v0, %symconst_1, %symconst_2
; %4:i64 = zext %3
; infer %4
; %5:i64 = zext %symconst_1
; %6:i64 = zext %symconst_2
; %7:i64 = select %v0, %5, %6
; result %7
; 
; zext((select v0 C1 C2))
;   =>
; select v0 zext(C1) zext(C2)
(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () Bool)

; Preconditions:
(assert (< r u))
(assert (< r u))
(assert (< r u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- u r) (ite v0 symconst_1 symconst_2))
    (ite v0 (pzero_extend (- u r) symconst_1) (pzero_extend (- u r) symconst_2))
))
(check-sat)
