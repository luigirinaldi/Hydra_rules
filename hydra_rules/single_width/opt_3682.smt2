; Opt : 3682
; %newvar0:i32 = var ; newvar0
; %1:i32 = subnsw %newvar0, 1:i32
; %v3:i32 = var ; v3
; %3:i1 = slt %1, %v3
; infer %3
; %4:i1 = sle %newvar0, %v3
; result %4
; 
; (newvar0 -nsw 1) <s v3
;   =>
; newvar0 <=s v3
(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun v3 () (_ BitVec q))

; Preconditions:
(assert (bvsle (int_to_pbv q 0) (bvand (bvxor newvar0 (int_to_pbv q 1)) (bvxor newvar0 (bvsub newvar0 (int_to_pbv q 1))))))

; assert lhs != rhs:
(assert (distinct 
    (bvslt (bvsub newvar0 (int_to_pbv q 1)) v3)
    (bvsle newvar0 v3)
))
(check-sat)
