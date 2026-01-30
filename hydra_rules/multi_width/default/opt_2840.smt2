; Opt : 2840
; %symconst_1:i32 = var ; symconst_1
; %newvar1:i8 = var ; newvar1
; %2:i32 = zext %newvar1
; %3:i32 = add %symconst_1, %2
; %4:i8 = trunc %3
; infer %4
; %5:i8 = trunc %symconst_1
; %6:i8 = add %newvar1, %5
; result %6
; 
; trunc((C1 + zext(newvar1)))
;   =>
; newvar1 + trunc(C1)
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar1 () (_ BitVec t))
(declare-fun symconst_1 () (_ BitVec r))

; Preconditions:
(assert (< t r))
(assert (> r t))
(assert (> r t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvadd symconst_1 (pzero_extend (- r t) newvar1)))
    (bvadd newvar1 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
