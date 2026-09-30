; Opt : 3957
; %symconst_1:i32 = var ; symconst_1
; %symDF_K1:i32 = var ; symDF_K1
; %2:i1 = knownones %symconst_1, %symDF_K1
; pc %2 1:i1
; %symDF_DB:i64 = var ; symDF_DB
; %4:i64 = zext %symDF_K1
; %5:i1 = eq %symDF_DB, %4
; pc %5 1:i1
; %newvar0:i32 = var ; newvar0
; %7:i32 = and %symconst_1, %newvar0
; %8:i64 = zext %7
; %9:i64 = demandedmask %8, %symDF_DB
; infer %9
; %10:i64 = sext %newvar0
; %11:i64 = demandedmask %10, %symDF_DB
; result %11
; 
; @db == zext(symconst_1.k1)
;   |=
; let var1 = (C1 & newvar0);
; let var0 = zext(var1);
; var0
;   =>
; let var2 = sext(newvar0);
; var2
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symDF_DB () (_ BitVec s))
(declare-fun symDF_K1 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))
(assert (< q s))
(assert (= (bvand symconst_1 symDF_K1) symDF_K1))
(assert (= symDF_DB (pzero_extend (- s q) symDF_K1)))

; assert lhs != rhs:
(assert (distinct 
    (bvand (pzero_extend (- s q) (bvand symconst_1 newvar0)) symDF_DB)
    (bvand (psign_extend (- s q) newvar0) symDF_DB)
))
(check-sat)
