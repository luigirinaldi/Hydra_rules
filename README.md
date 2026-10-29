# Hydra rules

Translation from the `gen.cpp` file to testcases occurs as follows:
- Parse the file
- Extract comments
- Parse the Souper-IR
- Translate Souper -> parametric AST
    - For each variable, introduce a fresh bitwidth variable, except for `i1` ones, which stay `i1`:
      an `i1` is a truth value, and the rules about one rely on it (`zext(x) != 0` is `x`,
      `0 - zext(x)` is `sext(x)`), so most of them are false at wider widths. A rule whose widths
      are all `i1` is then not parametric, and is skipped
    - For every operation that changes the width (ext and trunc) introduce symbolic constraints on the widths
        - a zext can only happen if the result width is strictly (not sure if the condition is strict?) larger than the original width
    - Every width is at least 1 (Souper has no `i0`): a width that no other condition bounds from
      below gets `w > 0`. At width 0 the only value is 0, so the constant `1` is `0` and a `trunc` to
      it drops every bit: rules such as opt_2318, opt_2482, opt_2593, opt_3272 and opt_3315 are false
      there
    - For every binary operand introduce an equality constraint between the two width operators
    - For `select` conditions enforce the resulting bitwidth to be `1`
    - Apply symbolic constraints
        - For every symbolic equality constraint, replace any occurrence of the widths with the new width
- Once the rewrite has been parametrised, translate it to `pbv` and `bwlang`
    - In `pbv` (SMT-LIB), an `i1` variable is a `(_ BitVec 1)`, not a `Bool`: blase's blasewuzla
      parses no `Bool` variables. Where the rule uses it as a truth value (a `select`'s condition,
      an operand of `and`/`or`/`xor`/`not`) it is `(= x (_ bv1 1))`, and as a bit (`zext`, the bv
      ops) it is `x`. The other `i1`s (comparisons, connectives, constants) are `Bool`s

Every `pc` is a precondition, and so are the side conditions that some ops and variable
attributes imply (below).

## Dataflow ops

Some rules only hold given a *dataflow fact*: something LLVM's analyses know about a value at
compile time. Hydra makes the facts symbolic: variables named `symDF_*` stand for masks that the
generated C++ computes when it matches the rule (e.g. `util::symdb(DB, I, x, B)` binds `x` to the
demanded bits of the instruction `I`).

- `demandedmask x, DB`: only the bits of `x` set in `DB` are *demanded*, i.e. observed by the
  users of `x`, so the rewrite only has to be correct on those bits. It is encoded as `x & DB`.
  The rules wrap both `infer` and `result` in it with the same mask, so the query checks
  `(lhs & DB) = (rhs & DB)`.
- `knownzeros x, K`: the bits set in `K` are zero in `x`: `x & K = 0`.
- `knownones x, K`: the bits set in `K` are one in `x`: `x & K = K`.

`knownzeros` and `knownones` appear as `pc`s, relating a constant to a mask. For example, opt_3940:

```
C2 <<=1 @db           ; pc: knownones C2, DB (every demanded bit is one in C2)
  |=
v0 & C2  =>  v0       ; both sides wrapped in demandedmask _, DB
```

is `(C2 & DB) = DB → ((C2 & v0) & DB) = (v0 & DB)`: on the demanded bits, `& C2` is `& 1`. On its
own, `v0 & C2 = v0` is false. In opt_4023, `symDF_K0` is a second mask, of the known zeros of a
constant, which is chained the same way.

## Other ops and attributes

| Souper | encoding |
|---|---|
| `subnsw a, b` (poison on signed overflow, so only on the lhs) | `a - b`, with the precondition `((a ^ b) & (a ^ (a - b))) >=s 0` (no signed overflow) |
| `sdivexact a, b` (poison if inexact, so only on the lhs) | `sdiv a b`, with the precondition `srem a b = 0` |
| `freeze x` | `x`: the identity on values that are not poison |
| `logb x` (of a power of two) | a fresh `logb_x`, with the preconditions `x = 1 << logb_x` and `logb_x <u width(x)` |
| `var (powerOfTwo)` | the preconditions `x != 0` and `x & (x - 1) = 0` |
| `var (nonNegative)` | the precondition `0 <=s x` |

`knownBits=` and `range=` attributes give bit patterns or ranges at a fixed width, so those rules
are skipped as non-parametric.


## Manual fixes

`MANUAL_FIXES` in `extract_rules.py` patches the generated SMT-LIB of a few rules that come out
false (each patch must apply exactly once, so a change to the extraction that moves them fails
loudly). With the patches, each holds at every width and is still parametric. They are of two kinds.

### Quirks of this translation

The generalisation does not know which widths must stay equal to each other, or concrete, so these
rules come out false at most widths. The rules themselves are fine: the translation picks the wrong
widths for them. (Width 0 is the same kind of quirk, handled for every rule by `w > 0`, above.)

- opt_2784, `trunc((v3 & 0xFFFFFFFF)) => trunc(v3)`: the constant 0xFFFFFFFF ((2^32)-1) is stored
  in a 64-bit variable because it masks the bits the trunc to i32 keeps. Kept as a constant, it only
  fits a trunc to 32 bits; it becomes the all-ones constant of the trunc's width, zero extended:
  `(pzero_extend (- q s) (bvnot (int_to_pbv s 0)))`.
- opt_3998: its `trunc` goes back to `newvar0`'s width (i8 to i8), but gets a fresh width `v` that
  only has to be smaller than the `zext`'s; it is `newvar0`'s: `(assert (= v q))`.

### Bugs in Hydra

These rules are false as Hydra generalises them, at a width LLVM has: applied there, they would
miscompile. Souper's rule is correct at its own width; the bug is Hydra's claim that it holds at
the other widths, not a quirk of this translation, whose query states the rule faithfully.

- opt_3682, `(newvar0 -nsw 1) <s v3 => newvar0 <=s v3` (Souper: i32): false at width 1 (`i1`),
  where the constant 1 is -1 as a signed value, so `newvar0 -nsw 1` is `newvar0 + 1`. The `nsw`
  precondition does not exclude it: `newvar0 = -1`, `v3 = 0` satisfy it (`-1 - (-1) = 0`), and then
  `0 <s 0` is false but `-1 <=s 0` is true. The constant 1 keeps its value from width 2:
  `(assert (>= q 2))` replaces `(assert (> q 0))`, with the explanation as `; Note:` comments in
  the query. `unsound/opt_3682.lean` checks the counterexample at width 1 with `bv_decide`
  (`lean unsound/opt_3682.lean`, with Lean v4.35.0-rc1).

## Type-check errors

#### Bit-vector exception

- `BVXor` related:
    - opt_1232
    - opt_3414
- Failure reason unclear:
    - opt_2969 (select of sext is same as sext of select)
    - opt_2456 (select of zext is same as zext of select)

#### Seg-Faults

- Extract on variable causes seg-fault:
    - opt_2895
    - opt_3212
- `int_to_pbv` on a constant that is not in `[0, 1, k]`:
    - opt_3056
    - opt_1784
    - opt_1978
