; Opt : 3275
; %newvar2:i1 = var ; newvar2
; %1:i32 = zext %newvar2
; %newvar1:i1 = var ; newvar1
; %3:i1 = xor 1:i1, %newvar1
; %4:i32 = zext %3
; %5:i32 = or %1, %4
; %6:i1 = ne 0:i32, %5
; infer %6
; %7:i1 = ule %newvar1, %newvar2
; result %7
; 
; (zext(newvar2) | zext(~newvar1)) != 0
;   =>
; newvar1 <=u newvar2
(set-logic ALL)
(declare-const q Int)
(declare-const u Int)
(declare-fun newvar1 () (_ BitVec q))
(declare-fun newvar2 () (_ BitVec q))

; Preconditions:
(assert (< q u))
(assert (< q u))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv u 0) (bvor (pzero_extend (- u q) newvar2) (pzero_extend (- u q) (bvnot newvar1))))
    (bvule newvar1 newvar2)
))
(check-sat)
