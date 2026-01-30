; Opt : 3165
; %newvar0:i64 = var ; newvar0
; %newvar5:i64 = var ; newvar5
; %2:i64 = sub %newvar0, %newvar5
; %3:i1 = eq 0:i64, %2
; infer %3
; %4:i1 = eq %newvar0, %newvar5
; result %4
; 
; (newvar0 - newvar5) == 0
;   =>
; newvar5 == newvar0
(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun newvar5 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (= (int_to_pbv r 0) (bvsub newvar0 newvar5))
    (= newvar0 newvar5)
))
(check-sat)
