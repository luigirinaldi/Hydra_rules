; Opt : 3189
; %symconst_6:i32 = var ; symconst_6
; %symconst_5:i32 = var ; symconst_5
; %2:i1 = ult %symconst_6, %symconst_5
; pc %2 1:i1
; %newvar0:i64 = var ; newvar0
; %4:i64 = and 1:i64, %newvar0
; %5:i1 = ne 0:i64, %4
; %6:i32 = select %5, %symconst_5, %symconst_6
; %7:i1 = ne %symconst_6, %6
; infer %7
; %8:i1 = trunc %newvar0
; result %8
; 
; C6 <u C5
;   |= 
; C6 != (select ((newvar0 & 1) != 0) C5 C6)
;   =>
; trunc(newvar0)
(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))
(declare-fun symconst_5 () (_ BitVec q))
(declare-fun symconst_6 () (_ BitVec q))

; Preconditions:
(assert (> t 1))
(assert (bvult symconst_6 symconst_5))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct symconst_6 (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)) symconst_5 symconst_6)) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 newvar0)
))
(check-sat)
