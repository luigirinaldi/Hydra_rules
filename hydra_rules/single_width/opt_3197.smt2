; Opt : 3197
; %symconst_1:i32 = var ; symconst_1
; %symconst_2:i32 = var ; symconst_2
; %2:i1 = ne %symconst_1, %symconst_2
; pc %2 1:i1
; %newvar1:i1 = var ; newvar1
; %4:i32 = select %newvar1, %symconst_2, %symconst_1
; %5:i1 = ne %symconst_1, %4
; infer %5
; result %newvar1
; 
; C2 != C1
;   |= 
; C1 != (select newvar1 C2 C1)
;   =>
; newvar1
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (distinct symconst_1 (ite newvar1 symconst_2 symconst_1))
    newvar1
))
(check-sat)
