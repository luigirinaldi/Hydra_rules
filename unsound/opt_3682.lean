import Std.Tactic.BVDecide

/-!
opt_3682, `(newvar0 -nsw 1) <s v3 => newvar0 <=s v3`: a bug in Hydra's generalisation (see the
README). At width 1 the constant 1 is -1 as a signed value, so `newvar0 -nsw 1` is `newvar0 + 1`;
the nsw precondition holds for newvar0 = -1 (-1 - (-1) = 0), and then, with v3 = 0, `0 <s 0` is
false but `-1 <=s 0` is true. This is the query of `hydra_rules/single_width/opt_3682.smt2` without
its `q >= 2`, at q = 1. Only that there is a counterexample is checked, not which one.
-/

/-- error: The prover found a counterexample -/
#guard_msgs (substring := true) in
example
    (newvar0 v3 : BitVec 1)
    (h0 : ((0#1).sle ((newvar0 ^^^ (1#1)) &&& (newvar0 ^^^ (newvar0 - (1#1))))))
    : (((newvar0 - (1#1)).slt v3) = (newvar0.sle v3)) := by
  bv_decide
