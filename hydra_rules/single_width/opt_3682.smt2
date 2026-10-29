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
; Note: A bug in Hydra, not a quirk of the translation: Hydra generalises this rule unsoundly. It is
; Note: false at width 1 (an i1), where the constant 1 is -1 as a signed value, so `newvar0 -nsw 1` is
; Note: `newvar0 + 1`. The nsw precondition does not exclude it: newvar0 = -1, v3 = 0 satisfy it
; Note: (-1 - (-1) = 0), and then `0 <s 0` is false but `-1 <=s 0` is true. The constant 1 only keeps
; Note: its value from width 2, so q >= 2.
(assert (>= q 2))
(assert (bvsle (int_to_pbv q 0) (bvand (bvxor newvar0 (int_to_pbv q 1)) (bvxor newvar0 (bvsub newvar0 (int_to_pbv q 1))))))

; assert lhs != rhs:
(assert (distinct 
    (bvslt (bvsub newvar0 (int_to_pbv q 1)) v3)
    (bvsle newvar0 v3)
))
(check-sat)
