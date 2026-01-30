; Opt : 1243
; %symconst_1:i16 = var ; symconst_1
; %symconst_2:i16 = var ; symconst_2
; %2:i1 = ne %symconst_1, %symconst_2
; pc %2 1:i1
; %newvar0:i1 = var ; newvar0
; %4:i16 = select %newvar0, %symconst_1, %symconst_2
; %5:i1 = ne %symconst_1, %4
; %6:i1 = xor 1:i1, %5
; infer %6
; result %newvar0
; 
; C2 != C1
;   |= 
; ~(C1 != (select newvar0 C1 C2))
;   =>
; newvar0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (not (distinct symconst_1 (ite newvar0 symconst_1 symconst_2)))
    newvar0
))
(check-sat)
