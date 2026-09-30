; Opt : 3182
; %newvar0:i32 = var ; newvar0
; %symDF_K0:i32 = var ; symDF_K0
; %2:i1 = knownzeros %newvar0, %symDF_K0
; pc %2 1:i1
; %symconst_4:i32 = var ; symconst_4
; %4:i1 = knownones %symDF_K0, %symconst_4
; pc %4 1:i1
; %symconst_1:i32 = var ; symconst_1
; %6:i32 = and %newvar0, %symconst_4
; %7:i1 = ne %symconst_1, %6
; infer %7
; %8:i32 = sub %symconst_1, 1:i32
; %9:i1 = ult %8, %symconst_1
; result %9
; 
; newvar0.k0 <<=1 C4
;   |= 
; let var0 = (C4 & newvar0);
; C1 != var0
;   =>
; let var1 = (C1 - 1);
; var1 <u C1
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun symDF_K0 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_4 () (_ BitVec r))

; Preconditions:
(assert (= (bvand newvar0 symDF_K0) (int_to_pbv r 0)))
(assert (= (bvand symDF_K0 symconst_4) symconst_4))

; assert lhs != rhs:
(assert (distinct 
    (distinct symconst_1 (bvand newvar0 symconst_4))
    (bvult (bvsub symconst_1 (int_to_pbv r 1)) symconst_1)
))
(check-sat)
