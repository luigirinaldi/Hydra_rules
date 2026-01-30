; Opt : 3407
; %symconst_2:i32 = var ; symconst_2
; %symconst_1:i32 = var ; symconst_1
; %2:i1 = ult %symconst_2, %symconst_1
; pc %2 1:i1
; %newvar1:i1 = var ; newvar1
; %4:i32 = select %newvar1, %symconst_1, %symconst_2
; %newvar4:i1 = var ; newvar4
; %6:i32 = select %newvar4, %symconst_1, %symconst_2
; %7:i1 = ne %4, %6
; infer %7
; %8:i1 = xor %newvar1, %newvar4
; result %8
; 
; C2 <u C1
;   |= 
; (select newvar1 C1 C2) != (select newvar4 C1 C2)
;   =>
; newvar4 ^ newvar1
(set-logic ALL)
(declare-const p Int)
(declare-fun newvar1 () Bool)
(declare-fun newvar4 () Bool)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec p))

; Preconditions:
(assert (bvult symconst_2 symconst_1))

; assert lhs != rhs:
(assert (distinct 
    (distinct (ite newvar1 symconst_1 symconst_2) (ite newvar4 symconst_1 symconst_2))
    (xor newvar1 newvar4)
))
(check-sat)
