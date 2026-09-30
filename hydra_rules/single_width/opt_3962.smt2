; Opt : 3962
; %symconst_5:i8 = var ; symconst_5
; %symconst_4:i8 = var ; symconst_4
; %v0:i8 = var ; v0
; %3:i8 = and %symconst_4, %v0
; %4:i8 = and %symconst_5, %3
; %symDF_DB:i8 = var ; symDF_DB
; %6:i8 = demandedmask %4, %symDF_DB
; infer %6
; %7:i8 = and %symconst_5, %symDF_DB
; %8:i8 = and %symconst_4, %7
; %9:i8 = and %v0, %8
; %10:i8 = demandedmask %9, %symDF_DB
; result %10
; 
; C5 & (v0 & C4)
;   =>
; v0 & (C4 & (C5 & @db))
(set-logic ALL)
(declare-const q Int)
(declare-fun symDF_DB () (_ BitVec q))
(declare-fun symconst_4 () (_ BitVec q))
(declare-fun symconst_5 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvand (bvand symconst_5 (bvand symconst_4 v0)) symDF_DB)
    (bvand (bvand v0 (bvand symconst_4 (bvand symconst_5 symDF_DB))) symDF_DB)
))
(check-sat)
