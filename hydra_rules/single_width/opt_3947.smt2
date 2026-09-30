; Opt : 3947
; %symconst_3:i32 = var ; symconst_3
; %symDF_DB:i32 = var ; symDF_DB
; %2:i32 = xor 4294967295:i32, %symDF_DB
; %3:i1 = eq %symconst_3, %2
; pc %3 1:i1
; %newvar0:i32 = var ; newvar0
; %5:i32 = and %symconst_3, %newvar0
; %6:i32 = demandedmask %5, %symDF_DB
; infer %6
; %7:i32 = demandedmask 0:i32, %symDF_DB
; result %7
; 
; C3 == ~@db
;   |= 
; C3 & newvar0
;   =>
; 0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symDF_DB () (_ BitVec q))
(declare-fun symconst_3 () (_ BitVec q))

; Preconditions:
(assert (= symconst_3 (bvxor (bvnot (int_to_pbv q 0)) symDF_DB)))

; assert lhs != rhs:
(assert (distinct 
    (bvand (bvand symconst_3 newvar0) symDF_DB)
    (bvand (int_to_pbv q 0) symDF_DB)
))
(check-sat)
