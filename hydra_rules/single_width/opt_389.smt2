; Opt : 389
; %symconst_1:i8 = var ; symconst_1
; %newvar1:i8 = var ; newvar1
; %2:i8 = sdivexact %newvar1, %symconst_1
; %3:i8 = mul %symconst_1, %2
; infer %3
; %4:i8 = freeze %newvar1
; result %4
; 
; C1 * (newvar1 sdivexact C1)
;   =>
; freeze(newvar1)
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; Preconditions:
(assert (= (bvsrem newvar1 symconst_1) (int_to_pbv q 0)))

; assert lhs != rhs:
(assert (distinct 
    (bvmul symconst_1 (bvsdiv newvar1 symconst_1))
    newvar1
))
(check-sat)
