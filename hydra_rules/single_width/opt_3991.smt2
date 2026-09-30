; Opt : 3991
; %symDF_DB:i32 = var ; symDF_DB
; %symconst_3:i32 = var ; symconst_3
; %2:i1 = knownzeros %symDF_DB, %symconst_3
; pc %2 1:i1
; %v0:i32 = var ; v0
; %4:i32 = and %symconst_3, %v0
; %5:i32 = demandedmask %4, %symDF_DB
; infer %5
; %6:i32 = demandedmask 0:i32, %symDF_DB
; result %6
; 
; @db <<=0 C3
;   |= 
; v0 & C3
;   =>
; 0
(set-logic ALL)
(declare-const r Int)
(declare-fun symDF_DB () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (= (bvand symDF_DB symconst_3) (int_to_pbv r 0)))

; assert lhs != rhs:
(assert (distinct 
    (bvand (bvand symconst_3 v0) symDF_DB)
    (bvand (int_to_pbv r 0) symDF_DB)
))
(check-sat)
