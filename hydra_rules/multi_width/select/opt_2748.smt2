; Opt : 2748
; %newvar1:i1 = var ; newvar1
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %3:i32 = select %newvar1, %symconst_1, %symconst_2
; %4:i8 = trunc %3
; infer %4
; %5:i8 = trunc %symconst_1
; %6:i8 = trunc %symconst_2
; %7:i8 = select %newvar1, %5, %6
; result %7
; 
; trunc((select newvar1 C1 C2))
;   =>
; select newvar1 trunc(C1) trunc(C2)
(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))

; Preconditions:
(assert (> r u))
(assert (> r u))
(assert (> r u))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- u 1) 0 (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (pextract (- u 1) 0 symconst_1) (pextract (- u 1) 0 symconst_2))
))
(check-sat)
