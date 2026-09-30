; Opt : 320
; %v0:i32 = var ; v0
; %newvar0:i32 = var ; newvar0
; %2:i32 = add %v0, %newvar0
; %3:i32 = subnsw %2, %newvar0
; infer %3
; result %v0
; 
; (v0 + newvar0) -nsw newvar0
;   =>
; v0
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (bvsle (int_to_pbv q 0) (bvand (bvxor (bvadd v0 newvar0) newvar0) (bvxor (bvadd v0 newvar0) (bvsub (bvadd v0 newvar0) newvar0)))))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (bvadd v0 newvar0) newvar0)
    v0
))
(check-sat)
