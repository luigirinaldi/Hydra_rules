# Hydra rules

Translation from the `gen.cpp` file to testcases occurs as follows:
- Parse the file
- Extract comments
- Parse the Souper-IR
- Translate Souper -> parametric AST
    - For each variable of concrete width > 1, introduce a fresh bitwidth variable
    - For every operation that changes the width (ext and trunc) introduce symbolic constraints on the widths
        - a zext can only happen if the result width is strictly (not sure if the condition is strict?) larger than the original width
    - For every binary operand introduce an equality constraint between the two width operators
    - For `select` conditions enforce the resulting bitwidth to be `1`
    - Apply symbolic constraints
        - For every symbolic equality constraint, replace any occurrence of the widths with the new width
- Once the rewrite has been parametrised, translate it to `pbv` and `bwlang`


## Type-check errors

#### Bit-vector exception

- `BVXor` related:
    - opt_1232
    - opt_3414
- Failure reason unclear:
    - opt_2969 (select of sext is same as sext of select)
    - opt_2969 (select of zext is same as zext of select)

#### Seg-Faults

- Extract on variable causes seg-fault:
    - opt_2895
    - opt_3212
- `int_to_pbv` on a constant that is not in `[0, 1, k]`:
    - opt_3056
    - opt_1784
    - opt_1978
