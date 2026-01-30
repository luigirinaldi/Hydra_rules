; Opt : 2791
; %symconst_3:i32 = var ; symconst_3
; %newvar0:i1 = var ; newvar0
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %4:i32 = select %newvar0, %symconst_1, %symconst_2
; %5:i32 = or %symconst_3, %4
; %6:i8 = trunc %5
; infer %6
; %7:i32 = select 1:i1, %symconst_1, %symconst_2
; %8:i32 = or %symconst_3, %7
; %9:i8 = trunc %8
; %10:i32 = select 0:i1, %symconst_1, %symconst_2
; %11:i32 = or %symconst_3, %10
; %12:i8 = trunc %11
; %13:i8 = select %newvar0, %9, %12
; result %13
; 
; trunc((C3 | (select newvar0 C1 C2)))
;   =>
; select newvar0 trunc((C3 | (select 1 C1 C2))) trunc((C3 | (select 0 C1 C2)))
(set-logic ALL)
(declare-const s Int)
(declare-const x Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))

; Preconditions:
(assert (> s x))
(assert (> s x))
(assert (> s x))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- x 1) 0 (bvor symconst_3 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (pextract (- x 1) 0 (bvor symconst_3 (ite true symconst_1 symconst_2))) (pextract (- x 1) 0 (bvor symconst_3 (ite false symconst_1 symconst_2))))
))
(check-sat)
