; Opt : 285
; %symconst_1:i16 = var ; symconst_1
; %symconst_2:i8 = var ; symconst_2
; %2:i16 = zext %symconst_2
; %3:i1 = eq %symconst_1, %2
; pc %3 1:i1
; %newvar4:i16 = var ; newvar4
; %5:i16 = add %symconst_1, %newvar4
; %6:i8 = trunc %5
; %7:i8 = sub %6, %symconst_2
; infer %7
; %8:i8 = trunc %newvar4
; result %8
; 
; C1 == zext(C2)
;   |= 
; trunc((C1 + newvar4)) - C2
;   =>
; trunc(newvar4)
(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun newvar4 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (> r q))
(assert (> r q))
(assert (= symconst_1 (pzero_extend (- r q) symconst_2)))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (pextract (- q 1) 0 (bvadd symconst_1 newvar4)) symconst_2)
    (pextract (- q 1) 0 newvar4)
))
(check-sat)
