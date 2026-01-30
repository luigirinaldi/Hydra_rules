; Opt : 2414
; %newvar2:i1 = var ; newvar2
; %1:i32 = zext %newvar2
; %newvar7:i1 = var ; newvar7
; %3:i32 = zext %newvar7
; %4:i32 = or %1, %3
; %5:i1 = ne 0:i32, %4
; %6:i8 = zext %5
; infer %6
; %7:i8 = trunc %4
; result %7
; 
; zext(((zext(newvar2) | zext(newvar7)) != 0))
;   =>
; trunc((zext(newvar2) | zext(newvar7)))
(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-const t Int)
(declare-const w Int)
(declare-const x Int)
(declare-fun newvar2 () (_ BitVec q))
(declare-fun newvar7 () (_ BitVec s))

; Preconditions:
(assert (< q t))
(assert (< q w))
(assert (< s t))
(assert (< s w))
(assert (< 1 x))
(assert (> w x))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- x 1) (ite (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t q) newvar2) (pzero_extend (- t s) newvar7))) (_ bv1 1) (_ bv0 1)))
    (pextract (- x 1) 0 (bvor (pzero_extend (- w q) newvar2) (pzero_extend (- w s) newvar7)))
))
(check-sat)
