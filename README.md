# Hydra rules

Translation from the `gen.cpp` file to testcases occurs as follows:
- Parse the file
- Extract comments
- Parse the Souper-IR
- Translate Souper -> parametric AST
    - For each variable, introduce a fresh bitwidth variable (`i1` ones too: Souper often types a
      variable `i1` when the rule holds at any width; see [Manual fixes](#manual-fixes) for when it
      does not)
    - For every operation that changes the width (ext and trunc) introduce symbolic constraints on the widths
        - a zext can only happen if the result width is strictly (not sure if the condition is strict?) larger than the original width
    - For every binary operand introduce an equality constraint between the two width operators
    - For `select` conditions enforce the resulting bitwidth to be `1`
    - Apply symbolic constraints
        - For every symbolic equality constraint, replace any occurrence of the widths with the new width
- Once the rewrite has been parametrised, translate it to `pbv` and `bwlang`

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

The generalisation does not know which widths must stay equal to each other, or concrete, so a few
rules come out false at most widths: their counterexamples are genuine. `MANUAL_FIXES` in
`extract_rules.py` patches their generated SMT-LIB (each patch must apply exactly once, so a change
to the extraction that moves them fails loudly). With the patches, each holds at every width and is
still parametric:

- opt_2784, `trunc((v3 & 0xFFFFFFFF)) => trunc(v3)`: the constant 0xFFFFFFFF ((2^32)-1) is stored
  in a 64-bit variable because it masks the bits the trunc to i32 keeps. Kept as a constant, it only
  fits a trunc to 32 bits; it becomes the all-ones constant of the trunc's width, zero extended:
  `(pzero_extend (- q s) (bvnot (int_to_pbv s 0)))`.
- opt_310, `0 - zext(newvar0) => sext(newvar0)`, and opt_2703,
  `sext((0 - zext(newvar0))) => sext(newvar0)`: these hold for a 1-bit `newvar0` only (for a
  wider one, `0 - zext(x)` is not `sext(x)`), so `newvar0` stays an `i1`: `(assert (= q 1))`. They
  stay parametric in the other widths.
- opt_3998: its `trunc` goes back to `newvar0`'s width (i8 to i8), but gets a fresh width `v` that
  only has to be smaller than the `zext`'s; it is `newvar0`'s: `(assert (= v q))`.

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
