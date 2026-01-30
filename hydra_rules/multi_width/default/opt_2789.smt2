; Opt : 2789
; %symconst_1:i32 = var ; symconst_1
; %newvar2:i8 = var ; newvar2
; %2:i32 = zext %newvar2
; %3:i32 = or %symconst_1, %2
; %4:i8 = trunc %3
; infer %4
; %5:i8 = trunc %symconst_1
; %6:i8 = or %newvar2, %5
; result %6
; 
; trunc((C1 | zext(newvar2)))
;   =>
; newvar2 | trunc(C1)
(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar2 () (_ BitVec t))
(declare-fun symconst_1 () (_ BitVec r))

; Preconditions:
(assert (< t r))
(assert (> r t))
(assert (> r t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvor symconst_1 (pzero_extend (- r t) newvar2)))
    (bvor newvar2 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
