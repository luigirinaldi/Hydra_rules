; Opt : 3945
; %symconst_1:i32 = var ; symconst_1
; %symDF_K1:i32 = var ; symDF_K1
; %2:i1 = knownones %symconst_1, %symDF_K1
; pc %2 1:i1
; %symDF_DB:i32 = var ; symDF_DB
; %4:i1 = knownones %symDF_K1, %symDF_DB
; pc %4 1:i1
; %newvar0:i32 = var ; newvar0
; %6:i32 = or %symconst_1, %newvar0
; %7:i32 = demandedmask %6, %symDF_DB
; infer %7
; %8:i32 = demandedmask %symconst_1, %symDF_DB
; result %8
; 
; symconst_1.k1 <<=1 @db
;   |= 
; let var0 = C1 | newvar0;
; var0
;   =>
; C1
(set-logic ALL)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec s))
(declare-fun symDF_DB () (_ BitVec s))
(declare-fun symDF_K1 () (_ BitVec s))
(declare-fun symconst_1 () (_ BitVec s))

; Preconditions:
(assert (= (bvand symDF_K1 symDF_DB) symDF_DB))
(assert (= (bvand symconst_1 symDF_K1) symDF_K1))

; assert lhs != rhs:
(assert (distinct 
    (bvand (bvor symconst_1 newvar0) symDF_DB)
    (bvand symconst_1 symDF_DB)
))
(check-sat)
