# Hydra rules

### Opt : 310

```
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%2:i32 = sub 0:i32, %1
infer %2
%3:i32 = sext %newvar0
result %3

0 - zext(newvar0)
  =>
sext(newvar0)
```

this only holds for var of width = 1?