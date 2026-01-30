; Opt : 1212
; %symconst_1:i8 = var ; symconst_1
; %symconst_2:i8 = var ; symconst_2
; %2:i1 = ne %symconst_1, %symconst_2
; pc %2 1:i1
; %newvar0:i8 = var ; newvar0
; %4:i1 = ne %symconst_1, %newvar0
; %5:i8 = select %4, %symconst_2, %symconst_1
; %6:i1 = ne %symconst_1, %5
; %7:i1 = xor 1:i1, %6
; infer %7
; %8:i1 = eq %symconst_1, %newvar0
; result %8
; 
; C2 != C1
;   |= 
; ~(C1 != (select (C1 != newvar0) C2 C1))
;   =>
; C1 == newvar0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (not (distinct symconst_1 (ite (distinct symconst_1 newvar0) symconst_2 symconst_1)))
    (= symconst_1 newvar0)
))
(check-sat)
