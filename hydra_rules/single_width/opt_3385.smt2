; Opt : 3385
; %symconst_1:i8 = var ; symconst_1
; %symconst_2:i8 = var ; symconst_2
; %2:i1 = ne %symconst_1, %symconst_2
; pc %2 1:i1
; %v0:i1 = var ; v0
; %4:i8 = select %v0, %symconst_1, %symconst_2
; %5:i1 = ne %symconst_1, %4
; infer %5
; %6:i1 = xor 1:i1, %v0
; result %6
; 
; C2 != C1
;   |= 
; C1 != (select v0 C1 C2)
;   =>
; ~v0
(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () Bool)

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (distinct symconst_1 (ite v0 symconst_1 symconst_2))
    (not v0)
))
(check-sat)
