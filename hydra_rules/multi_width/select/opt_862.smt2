; Opt : 862
; %symconst_3:i16 = var ; symconst_3
; %newvar0:i1 = var ; newvar0
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %4:i32 = select %newvar0, %symconst_1, %symconst_2
; %5:i16 = trunc %4
; %6:i16 = and %symconst_3, %5
; infer %6
; %7:i32 = select 1:i1, %symconst_1, %symconst_2
; %8:i16 = trunc %7
; %9:i16 = and %symconst_3, %8
; %10:i32 = select 0:i1, %symconst_1, %symconst_2
; %11:i16 = trunc %10
; %12:i16 = and %symconst_3, %11
; %13:i16 = select %newvar0, %9, %12
; result %13
; 
; C3 & trunc((select newvar0 C1 C2))
;   =>
; select newvar0 (C3 & trunc((select 1 C1 C2))) (C3 & trunc((select 0 C1 C2)))
(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec t))

; Preconditions:
(assert (> s t))
(assert (> s t))
(assert (> s t))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_3 (pextract (- t 1) 0 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (bvand symconst_3 (pextract (- t 1) 0 (ite true symconst_1 symconst_2))) (bvand symconst_3 (pextract (- t 1) 0 (ite false symconst_1 symconst_2))))
))
(check-sat)
