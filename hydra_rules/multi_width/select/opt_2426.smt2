; Opt : 2426
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %2:i1 = ne %symconst_1, %symconst_2
; pc %2 1:i1
; %newvar1:i1 = var ; newvar1
; %4:i32 = select %newvar1, %symconst_2, %symconst_1
; %5:i1 = ne %symconst_1, %4
; %6:i8 = zext %5
; infer %6
; %7:i8 = zext %newvar1
; result %7
; 
; C2 != C1
;   |= 
; zext((C1 != (select newvar1 C2 C1)))
;   =>
; zext(newvar1)
(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (< 1 t))
(assert (< 1 t))
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (distinct symconst_1 (ite newvar1 symconst_2 symconst_1)) (_ bv1 1) (_ bv0 1)))
    (pzero_extend (- t 1) (ite newvar1 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
