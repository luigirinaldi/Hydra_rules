; Opt : 884
; %v0:i8 = var ; v0
; %symDF_K0:i8 = var ; symDF_K0
; %2:i1 = knownzeros %v0, %symDF_K0
; pc %2 1:i1
; %symconst_2:i8 = var ; symconst_2
; %4:i8 = xor 255:i8, %symDF_K0
; %5:i1 = eq %symconst_2, %4
; pc %5 1:i1
; %6:i8 = and %v0, %symconst_2
; infer %6
; result %v0
; 
; C2 == ~v0.k0
;   |= 
; v0 & C2
;   =>
; v0
(set-logic ALL)
(declare-const q Int)
(declare-fun symDF_K0 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (= (bvand v0 symDF_K0) (int_to_pbv q 0)))
(assert (= symconst_2 (bvxor (bvnot (int_to_pbv q 0)) symDF_K0)))

; assert lhs != rhs:
(assert (distinct 
    (bvand v0 symconst_2)
    v0
))
(check-sat)
