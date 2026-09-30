; Opt : 612
; %symconst_3:i32 = var ; symconst_3
; %symDF_K1:i32 = var ; symDF_K1
; %2:i1 = knownones %symconst_3, %symDF_K1
; pc %2 1:i1
; %symconst_5:i32 = var ; symconst_5
; %4:i1 = knownones %symDF_K1, %symconst_5
; pc %4 1:i1
; %newvar0:i32 = var ; newvar0
; %6:i32 = and %symconst_3, %newvar0
; %7:i32 = and %symconst_5, %6
; infer %7
; %8:i32 = and %symconst_5, %newvar0
; result %8
; 
; symconst_3.k1 <<=1 C5
;   |= 
; let var0 = (C3 & newvar0);
; C5 & var0
;   =>
; C5 & newvar0
(set-logic ALL)
(declare-const p Int)
(declare-fun newvar0 () (_ BitVec p))
(declare-fun symDF_K1 () (_ BitVec p))
(declare-fun symconst_3 () (_ BitVec p))
(declare-fun symconst_5 () (_ BitVec p))

; Preconditions:
(assert (= (bvand symDF_K1 symconst_5) symconst_5))
(assert (= (bvand symconst_3 symDF_K1) symDF_K1))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_5 (bvand symconst_3 newvar0))
    (bvand symconst_5 newvar0)
))
(check-sat)
