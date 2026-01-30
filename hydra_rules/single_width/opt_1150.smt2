; Opt : 1150
; %symconst_3:i32 = var ; symconst_3
; %newvar1:i1 = var ; newvar1
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %4:i32 = select %newvar1, %symconst_1, %symconst_2
; %5:i32 = or %symconst_3, %4
; infer %5
; %6:i32 = or %symconst_3, %symconst_1
; %7:i32 = or %symconst_3, %symconst_2
; %8:i32 = select %newvar1, %6, %7
; result %8
; 
; C3 | (select newvar1 C1 C2)
;   =>
; select newvar1 (C3 | C1) (C3 | C2)
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvor symconst_3 (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (bvor symconst_3 symconst_1) (bvor symconst_3 symconst_2))
))
(check-sat)
