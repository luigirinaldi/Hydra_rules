; Opt : 3998
; %symconst_1:i8 = var ; symconst_1
; %symDF_K1:i8 = var ; symDF_K1
; %2:i1 = knownones %symconst_1, %symDF_K1
; pc %2 1:i1
; %symDF_DB:i32 = var ; symDF_DB
; %4:i32 = zext %symDF_K1
; %5:i1 = eq %symDF_DB, %4
; pc %5 1:i1
; %newvar0:i8 = var ; newvar0
; %7:i8 = and %symconst_1, %newvar0
; %8:i32 = zext %7
; %9:i8 = trunc %8
; %10:i32 = zext %9
; %11:i32 = demandedmask %10, %symDF_DB
; infer %11
; %12:i32 = sext %newvar0
; %13:i32 = demandedmask %12, %symDF_DB
; result %13
; 
; @db == zext(symconst_1.k1)
;   |= 
; let var3 = (C1 & newvar0);
; let var2 = zext(var3);
; let var1 = trunc(var2);
; let var0 = zext(var1);
; var0
;   =>
; let var4 = sext(newvar0);
; var4
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-const u Int)
(declare-const v Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symDF_DB () (_ BitVec s))
(declare-fun symDF_K1 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))
(assert (< q u))
(assert (< v s))
(assert (> u v))
(assert (= (bvand symconst_1 symDF_K1) symDF_K1))
(assert (= symDF_DB (pzero_extend (- s q) symDF_K1)))
(assert (= v q))

; assert lhs != rhs:
(assert (distinct 
    (bvand (pzero_extend (- s v) (pextract (- v 1) 0 (pzero_extend (- u q) (bvand symconst_1 newvar0)))) symDF_DB)
    (bvand (psign_extend (- s q) newvar0) symDF_DB)
))
(check-sat)
