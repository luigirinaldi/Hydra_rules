; Opt : 772
; %newvar0:i32 = var ; newvar0
; %symDF_K0:i32 = var ; symDF_K0
; %2:i1 = knownzeros %newvar0, %symDF_K0
; pc %2 1:i1
; %symconst_3:i32 = var ; symconst_3
; %4:i1 = knownones %symDF_K0, %symconst_3
; pc %4 1:i1
; %5:i32 = and %newvar0, %symconst_3
; infer %5
; result 0:i32
; 
; newvar0.k0 <<=1 C3
;   |= 
; C3 & newvar0
;   =>
; 0
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun symDF_K0 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))

; Preconditions:
(assert (= (bvand newvar0 symDF_K0) (int_to_pbv r 0)))
(assert (= (bvand symDF_K0 symconst_3) symconst_3))

; assert lhs != rhs:
(assert (distinct 
    (bvand newvar0 symconst_3)
    (int_to_pbv r 0)
))
(check-sat)
