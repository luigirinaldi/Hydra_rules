Value *f(llvm::Instruction *I, IRBuilder *B) {
/* Opt : 3157
%symconst_1:i8 = var ; symconst_1
%newvar0:i4 = var ; newvar0
%2:i4 = width %newvar0
%3:i8 = zext %2
%4:i8 = shl 1:i8, %3
%5:i8 = sub %4, 1:i8
%6:i1 = ule %symconst_1, %5
pc %6 1:i1
%7:i8 = zext %newvar0
%8:i1 = eq %symconst_1, %7
infer %8
%9:i4 = trunc %symconst_1
%10:i1 = eq %newvar0, %9
result %10

C1 <=u ((1 << zext(width(newvar0))) - 1)
  |= 
C1 == zext(newvar0)
  =>
newvar0 == trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3157) && match(I, m_c_ICmp(P0, m_Constant(&x3), m_ZExt(m_Value(x2))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x2) && (ule(util::V(x3), sub(shl(llvm::APInt(8, 1), util::W(x2).zext(64)), llvm::APInt(8, 1))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(3157, 1);
  return ret;

}
}
}}

/* Opt : 3197
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%2:i1 = ne %symconst_1, %symconst_2
pc %2 1:i1
%newvar1:i1 = var ; newvar1
%4:i32 = select %newvar1, %symconst_2, %symconst_1
%5:i1 = ne %symconst_1, %4
infer %5
result %newvar1

C2 != C1
  |= 
C1 != (select newvar1 C2 C1)
  =>
newvar1
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3197) && match(I, m_c_ICmp(P0, m_Constant(&x2), m_Select(m_Value(x3), m_Constant(&x1), m_Deferred(x2))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x3,1) && (ne(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = x3;
if (util::check_width(ret, I)) {
  St.hit(3197, 4);
  return ret;

}
}
}}

/* Opt : 1677
%newvar3:i1 = var ; newvar3
%1:i16 = select %newvar3, 1:i16, 0:i16
infer %1
%2:i16 = zext %newvar3
result %2

select newvar3 1 0
  =>
zext(newvar3)
*/
{
llvm::Value *x0 = nullptr;
if (util::filter(F, 1677) && match(I, m_Select(m_Value(x0), m_ExtInt("1", 16), m_Zero()))) {
if (util::check_width(x0,1) && util::dc(DT, I, x0)) {
  auto ret = B->CreateZExt(x0, T(I));
if (util::check_width(ret, I)) {
  St.hit(1677, 2);
  return ret;

}
}
}}

/* Opt : 2426
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%2:i1 = ne %symconst_1, %symconst_2
pc %2 1:i1
%newvar1:i1 = var ; newvar1
%4:i32 = select %newvar1, %symconst_2, %symconst_1
%5:i1 = ne %symconst_1, %4
%6:i8 = zext %5
infer %6
%7:i8 = zext %newvar1
result %7

C2 != C1
  |= 
zext((C1 != (select newvar1 C2 C1)))
  =>
zext(newvar1)
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2426) && match(I, m_ZExt(m_c_ICmp(P0, m_Constant(&x2), m_Select(m_Value(x4), m_Constant(&x1), m_Deferred(x2)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x4,1) && util::dc(DT, I, x4) && (ne(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateZExt(x4, T(I));
if (util::check_width(ret, I)) {
  St.hit(2426, 4);
  return ret;

}
}
}}

/* Opt : 2743
%newvar0:i16 = var ; newvar0
%1:i32 = zext %newvar0
%2:i16 = trunc %1
infer %2
result %newvar0

trunc(zext(newvar0))
  =>
newvar0
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2743) && match(I, m_Trunc(m_ZExt(m_Value(x2))))) {
  auto ret = x2;
if (util::check_width(ret, I)) {
  St.hit(2743, 2);
  return ret;

}
}
}
/* Opt : 1534
%symconst_9:i32 = var ; symconst_9
%symconst_8:i32 = var ; symconst_8
%2:i1 = ult %symconst_9, %symconst_8
pc %2 1:i1
%newvar1:i1 = var ; newvar1
%4:i32 = select %newvar1, %symconst_8, %symconst_9
%5:i1 = ne %symconst_9, %4
%symconst_3:i8 = var ; symconst_3
%symconst_7:i8 = var ; symconst_7
%8:i8 = select %5, %symconst_3, %symconst_7
infer %8
%9:i8 = select %newvar1, %symconst_3, %symconst_7
result %9

C9 <u C8
  |= 
select (C9 != (select newvar1 C8 C9)) C3 C7
  =>
select newvar1 C3 C7
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1534) && match(I, m_Select(m_c_ICmp(P0, m_Constant(&x2), m_Select(m_Value(x5), m_Constant(&x1), m_Deferred(x2))), m_Constant(&x4), m_Constant(&x3)))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x5,1) && util::dc(DT, I, x5) && util::dc(DT, I, x4) && util::dc(DT, I, x3) && (ult(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateSelect(x5, x4, x3);
if (util::check_width(ret, I)) {
  St.hit(1534, 4);
  return ret;

}
}
}}

/* Opt : 3174
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%2:i1 = ne 0:i32, %1
infer %2
result %newvar0

zext(newvar0) != 0
  =>
newvar0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3174) && match(I, m_c_ICmp(P0, m_Zero(), m_ZExt(m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x1,1)) {
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(3174, 2);
  return ret;

}
}
}}

/* Opt : 37
%v0:i32 = var ; v0
%1:i32 = add 0:i32, %v0
infer %1
result %v0

v0 + 0
  =>
v0
*/
{
llvm::Value *x0 = nullptr;
if (util::filter(F, 37) && match(I, m_c_Add(m_Zero(), m_Value(x0)))) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(37, 1);
  return ret;

}
}
}
/* Opt : 2789
%symconst_1:i32 = var ; symconst_1
%newvar2:i8 = var ; newvar2
%2:i32 = zext %newvar2
%3:i32 = or %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = or %newvar2, %5
result %6

trunc((C1 | zext(newvar2)))
  =>
newvar2 | trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2789) && match(I, m_Trunc(m_c_Or(m_Constant(&x3), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateOr(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2789, 2);
  return ret;

}
}
}}

/* Opt : 3296
%v0:i32 = var ; v0
%1:i32 = and 1:i32, %v0
%2:i1 = ne 0:i32, %1
infer %2
%3:i1 = trunc %v0
result %3

(v0 & 1) != 0
  =>
trunc(v0)
*/
{
llvm::Value *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3296) && match(I, m_c_ICmp(P0, m_Zero(), m_c_And(m_ExtInt("1", 32), m_Value(x0))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x0)) {
  auto ret = B->CreateTrunc(x0, T(I));
if (util::check_width(ret, I)) {
  St.hit(3296, 1);
  return ret;

}
}
}}

/* Opt : 2712
%newvar0:i32 = var ; newvar0
%1:i32 = add 0:i32, %newvar0
%2:i64 = sext %1
infer %2
%3:i64 = sext %newvar0
result %3

sext((newvar0 + 0))
  =>
sext(newvar0)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2712) && match(I, m_SExt(m_c_Add(m_Zero(), m_Value(x1))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateSExt(x1, T(I));
if (util::check_width(ret, I)) {
  St.hit(2712, 1);
  return ret;

}
}
}}

/* Opt : 392
%newvar2:i32 = var ; newvar2
%1:i32 = mul 1:i32, %newvar2
infer %1
result %newvar2

newvar2 * 1
  =>
newvar2
*/
{
llvm::Value *x0 = nullptr;
if (util::filter(F, 392) && match(I, m_c_Mul(m_ExtInt("1", 32), m_Value(x0)))) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(392, 1);
  return ret;

}
}
}
/* Opt : 2931
%symconst_1:i32 = var ; symconst_1
%1:i1 = ult 0:i32, %symconst_1
%v1:i8 = var ; v1
%3:i8 = width %v1
%4:i32 = zext %3
%5:i1 = ule %symconst_1, %4
%6:i1 = and %1, %5
pc %6 1:i1
%7:i32 = zext %v1
%8:i1 = eq %symconst_1, %7
infer %8
%9:i8 = trunc %symconst_1
%10:i1 = eq %v1, %9
result %10

(0 <u C1) & (C1 <=u zext(width(v1)))
  |= 
C1 == zext(v1)
  =>
v1 == trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2931) && match(I, m_c_ICmp(P0, m_Constant(&x4), m_ZExt(m_Value(x3))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x3) && ((ult(llvm::APInt(32, 0), util::V(x4)) & ule(util::V(x4), util::W(x3).zext(64))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x3, B->CreateTrunc(x4, T(x3)));
if (util::check_width(ret, I)) {
  St.hit(2931, 1);
  return ret;

}
}
}}

/* Opt : 503
%v0:i16 = var ; v0
%symconst_1:i16 = var (powerOfTwo) ; symconst_1
%2:i16 = udiv %v0, %symconst_1
infer %2
%3:i16 = logb %symconst_1
%4:i16 = lshr %v0, %3
result %4

v0 /u C1 (powerOfTwo)
  =>
v0 >>l logb(C1)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 503) && match(I, m_UDiv(m_Value(x1), m_Constant(&x0)))) {
if (util::pow2(x0) && util::dc(DT, I, x1)) {
  auto ret = B->CreateLShr(x1, B->CreateLogB(x0));
if (util::check_width(ret, I)) {
  St.hit(503, 4);
  return ret;

}
}
}}

/* Opt : 3940
%symconst_2:i64 = var ; symconst_2
%symDF_DB:i64 = var ; symDF_DB
%2:i1 = knownones %symconst_2, %symDF_DB
pc %2 1:i1
%v0:i64 = var ; v0
%4:i64 = and %symconst_2, %v0
%5:i64 = demandedmask %4, %symDF_DB
infer %5
%6:i64 = demandedmask %v0, %symDF_DB
result %6

C2 <<=1 @db
  |= 
v0 & C2
  =>
v0

{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
if (util::filter(F, 3940) && match(I, m_c_And(m_Constant(&x3), m_Value(x4)))) {
if (util::symdb(DB, I, x2, B) && util::dc(DT, I, x4) && util::dc(DT, I, x2) && util::symk1test(x3, x2)) {
  auto ret = x4;
if (util::check_width(ret, I)) {
  St.hit(3940, 1);
  return ret;

}
}
}}*/

/* Opt : 4023
%symconst_1:i64 = var ; symconst_1
%symDF_K0:i64 = var ; symDF_K0
%2:i1 = knownzeros %symconst_1, %symDF_K0
pc %2 1:i1
%symDF_DB:i64 = var ; symDF_DB
%4:i1 = knownones %symDF_K0, %symDF_DB
pc %4 1:i1
%newvar1:i64 = var ; newvar1
%newvar3:i64 = var ; newvar3
%7:i64 = and %symconst_1, %newvar3
%8:i64 = or %newvar1, %7
%9:i64 = demandedmask %8, %symDF_DB
infer %9
%10:i64 = demandedmask %newvar1, %symDF_DB
result %10

symconst_1.k0 <<=1 @db
  |= 
let var1 = (C1 & newvar3);
let var0 = newvar1 | var1;
var0
  =>
newvar1
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr, *x7 = nullptr, *x6 = nullptr;
if (util::filter(F, 4023) && match(I, m_c_Or(m_Value(x7), m_c_And(m_Constant(&x5), m_Value(x6))))) {
if (util::symk0bind(x5, x3, B) && util::symdb(DB, I, x2, B) && util::dc(DT, I, x7) && util::dc(DT, I, x2) && util::symk1test(x3, x2)) {
  auto ret = x7;
if (util::check_width(ret, I)) {
  St.hit(4023, 2);
  return ret;

}
}
}}

/* Opt : 36
%symconst_1:i8 = var ; symconst_1
%v0:i8 = var ; v0
%2:i8 = add %symconst_1, %v0
%3:i8 = add %symconst_1, %2
infer %3
%4:i8 = add %symconst_1, %symconst_1
%5:i8 = add %v0, %4
result %5

C1 + (v0 + C1)
  =>
v0 + (C1 + C1)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 36) && match(I, m_c_Add(m_Constant(&x1), m_c_Add(m_Deferred(x1), m_Value(x0))))) {
if (util::dc(DT, I, x0)) {
  auto ret = B->CreateAdd(x0, B->CreateAdd(x1, x1));
if (util::check_width(ret, I)) {
  St.hit(36, 1);
  return ret;

}
}
}}

/* Opt : 2761
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = zext %v0
%3:i32 = and %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = and %v0, %5
result %6

trunc((C1 & zext(v0)))
  =>
v0 & trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2761) && match(I, m_Trunc(m_c_And(m_Constant(&x3), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateAnd(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2761, 2);
  return ret;

}
}
}}

/* Opt : 1250
%newvar0:i8 = var ; newvar0
%symconst_1:i8 = var ; symconst_1
%2:i1 = ne %newvar0, %symconst_1
%3:i1 = xor 1:i1, %2
infer %3
%4:i1 = eq %newvar0, %symconst_1
result %4

~(C1 != newvar0)
  =>
C1 == newvar0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1250) && match(I, m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Value(x2), m_Constant(&x1))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x1)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x2, x1);
if (util::check_width(ret, I)) {
  St.hit(1250, 1);
  return ret;

}
}
}}

/* Opt : 3523
%symconst_1:i64 = var ; symconst_1
%v0:i8 = var ; v0
%2:i8 = width %v0
%3:i64 = zext %2
%4:i64 = shl 1:i64, %3
%5:i64 = sub %4, 1:i64
%6:i1 = ule %symconst_1, %5
pc %6 1:i1
%7:i64 = zext %v0
%8:i1 = ult %7, %symconst_1
infer %8
%9:i8 = trunc %symconst_1
%10:i1 = ult %v0, %9
result %10

C1 <=u ((1 << zext(width(v0))) - 1)
  |= 
zext(v0) <u C1
  =>
v0 <u trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3523) && match(I, m_ICmp(P0, m_ZExt(m_Value(x2)), m_Constant(&x3)))) {
if (P0 == ICmpInst::ICMP_ULT && util::dc(DT, I, x2) && (ule(util::V(x3), sub(shl(llvm::APInt(64, 1), util::W(x2).zext(64)), llvm::APInt(64, 1))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULT, x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(3523, 1);
  return ret;

}
}
}}

/* Opt : 3414
%newvar0:i1 = var ; newvar0
%1:i32 = select %newvar0, 1:i32, 0:i32
%newvar5:i1 = var ; newvar5
%3:i32 = zext %newvar5
%4:i32 = xor %1, %3
%5:i1 = ne 0:i32, %4
infer %5
%6:i1 = xor %newvar0, %newvar5
result %6

((select newvar0 1 0) ^ zext(newvar5)) != 0
  =>
newvar5 ^ newvar0
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3414) && match(I, m_c_ICmp(P0, m_Zero(), m_c_Xor(m_Select(m_Value(x2), m_ExtInt("1", 32), m_Zero()), m_ZExt(m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x2,1) && util::check_width(x1,1) && util::dc(DT, I, x2) && util::dc(DT, I, x1)) {
  auto ret = B->CreateXor(x2, x1);
if (util::check_width(ret, I)) {
  St.hit(3414, 5);
  return ret;

}
}
}}

/* Opt : 1635
%symconst_6:i32 = var ; symconst_6
%symconst_7:i32 = var ; symconst_7
%2:i32 = sub %symconst_6, %symconst_7
%3:i1 = eq 1:i32, %2
pc %3 1:i1
%v0:i32 = var ; v0
%5:i32 = and 1:i32, %v0
%6:i1 = ne 0:i32, %5
%7:i32 = select %6, %symconst_6, %symconst_7
infer %7
%8:i32 = add %symconst_7, %5
result %8

(C6 - C7) == 1
  |= 
let var0 = (v0 & 1);
select (var0 != 0) C6 C7
  =>
C7 + var0
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr, *x4 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1635) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), &x4 <<= m_c_And(&x5 <<= m_ExtInt("1", 32), m_Value(x3))), m_Constant(&x2), m_Constant(&x1)))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x1) && util::dc(DT, I, x4) && util::dc(DT, I, x3) && (eq(llvm::APInt(32, 1), sub(util::V(x2), util::V(x1))) == llvm::APInt(1, 1))) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateAdd(x1, x4);
if (util::check_width(ret, I)) {
  St.hit(1635, 3);
  return ret;

}
}
}}

/* Opt : 625
%newvar0:i16 = var ; newvar0
%1:i16 = and 65535:i16, %newvar0
infer %1
result %newvar0

newvar0 & 0xFFFF
  =>
newvar0
*/
{
llvm::Value *x0 = nullptr;
if (util::filter(F, 625) && match(I, m_c_And(m_AllOnes(), m_Value(x0)))) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(625, 1);
  return ret;

}
}
}
/* Opt : 3948
%v0:i64 = var ; v0
%symDF_K0:i64 = var ; symDF_K0
%2:i1 = knownzeros %v0, %symDF_K0
pc %2 1:i1
%symconst_2:i64 = var ; symconst_2
%4:i64 = or %symDF_K0, %symconst_2
%symDF_DB:i64 = var ; symDF_DB
%6:i64 = xor 18446744073709551615:i64, %symDF_DB
%7:i64 = or %4, %6
%8:i1 = eq 18446744073709551615:i64, %7
pc %8 1:i1
%9:i64 = and %v0, %symconst_2
%10:i64 = demandedmask %9, %symDF_DB
infer %10
%11:i64 = demandedmask %v0, %symDF_DB
result %11

((C2 | v0.k0) | ~@db) == 0xFFFFFFFFFFFFFFFF
  |=
let var0 = v0 & C2;
var0
  =>
v0

{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr;
if (util::filter(F, 3948) && match(I, m_c_And(m_Value(x5), m_Constant(&x2)))) {

if (util::symk0bind(x5, x3, B) && util::symdb(DB, I, x1, B) && 
util::dc(DT, I, x5) && util::dc(DT, I, x1) &&
(or_(or_(util::V(x3), util::V(x2)), 
flip(util::V(x1)))).isAllOnesValue()) {

  auto ret = x5;
if (util::check_width(ret, I)) {
  St.hit(3948, 1);
  return ret;

}
}
}}
*/

/* Opt : 2448
%v2:i2 = var ; v2
%symconst_1:i2 = var (nonNegative) ; symconst_1
%2:i2 = and %v2, %symconst_1
%3:i4 = zext %2
%4:i8 = zext %3
infer %4
%5:i8 = sext %2
result %5

zext(zext((v2 & C1 (nonNegative))))
  =>
sext((v2 & C1))
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x4 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2448) && match(I, m_ZExt(m_ZExt(&x4 <<= m_c_And(m_Value(x3), m_Constant(&x2)))))) {
if (util::nn(x2) && util::dc(DT, I, x4) && util::dc(DT, I, x3) && util::dc(DT, I, x2)) {
  auto ret = B->CreateSExt(x4, T(I));
if (util::check_width(ret, I)) {
  St.hit(2448, 1);
  return ret;

}
}
}}

/* Opt : 2989
%v0:i8 = var ; v0
%1:i32 = sext %v0 (hasExternalUses)
%v2:i8 = var ; v2
%3:i32 = sext %v2
%4:i1 = eq %1, %3
infer %4
%5:i1 = eq %v0, %v2
result %5

sext(v0) == sext(v2)
  =>
v2 == v0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2989) && match(I, m_c_ICmp(P0, m_SExt(m_Value(x3)), m_SExt(m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x3) && util::dc(DT, I, x1)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x3, x1);
if (util::check_width(ret, I)) {
  St.hit(2989, 2);
  return ret;

}
}
}}

/* Opt : 3328
%newvar0:i64 = var ; newvar0
%1:i64 = srem %newvar0, 2:i64
%2:i1 = ne 0:i64, %1
infer %2
%3:i1 = trunc %newvar0
result %3

(newvar0 %s 2) != 0
  =>
trunc(newvar0)
*/
{
llvm::Value *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3328) && match(I, m_c_ICmp(P0, m_Zero(), m_SRem(m_Value(x0), m_ExtInt("2", 64))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x0)) {
  auto ret = B->CreateTrunc(x0, T(I));
if (util::check_width(ret, I)) {
  St.hit(3328, 5);
  return ret;

}
}
}}

/* Opt : 3487
%newvar0:i16 = var ; newvar0
%1:i16 = and 1:i16, %newvar0
%2:i32 = zext %1
%3:i1 = ne 0:i32, %2
infer %3
%4:i1 = trunc %newvar0
result %4

zext((newvar0 & 1)) != 0
  =>
trunc(newvar0)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3487) && match(I, m_c_ICmp(P0, m_Zero(), m_ZExt(m_c_And(m_ExtInt("1", 16), m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x1)) {
  auto ret = B->CreateTrunc(x1, T(I));
if (util::check_width(ret, I)) {
  St.hit(3487, 2);
  return ret;

}
}
}}

/* Opt : 583
%newvar0:i8 = var ; newvar0
%symconst_1:i8 = var (powerOfTwo) ; symconst_1
%2:i8 = urem %newvar0, %symconst_1
infer %2
%3:i8 = sub %symconst_1, 1:i8
%4:i8 = and %newvar0, %3
result %4

newvar0 %u C1 (powerOfTwo)
  =>
newvar0 & (C1 - 1)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 583) && match(I, m_URem(m_Value(x1), m_Constant(&x0)))) {
if (util::pow2(x0) && util::dc(DT, I, x1)) {
  auto C0 = C(8, 1, B);
  auto ret = B->CreateAnd(x1, B->CreateSub(x0, C0(x0)));
if (util::check_width(ret, I)) {
  St.hit(583, 4);
  return ret;

}
}
}}

/* Opt : 3189
%symconst_6:i32 = var ; symconst_6
%symconst_5:i32 = var ; symconst_5
%2:i1 = ult %symconst_6, %symconst_5
pc %2 1:i1
%newvar0:i64 = var ; newvar0
%4:i64 = and 1:i64, %newvar0
%5:i1 = ne 0:i64, %4
%6:i32 = select %5, %symconst_5, %symconst_6
%7:i1 = ne %symconst_6, %6
infer %7
%8:i1 = trunc %newvar0
result %8

C6 <u C5
  |= 
C6 != (select ((newvar0 & 1) != 0) C5 C6)
  =>
trunc(newvar0)
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P1, P0;
if (util::filter(F, 3189) && match(I, m_c_ICmp(P0, m_Constant(&x2), m_Select(m_c_ICmp(P1, m_Zero(), m_c_And(m_ExtInt("1", 64), m_Value(x3))), m_Constant(&x1), m_Deferred(x2))))) {
if (P0 == ICmpInst::ICMP_NE && P1 == ICmpInst::ICMP_NE && util::dc(DT, I, x3) && (ult(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateTrunc(x3, T(I));
if (util::check_width(ret, I)) {
  St.hit(3189, 5);
  return ret;

}
}
}}

/* Opt : 1099
%symconst_3:i8 = var ; symconst_3
%newvar5:i1 = var ; newvar5
%symconst_1:i8 = var ; symconst_1
%3:i8 = select %newvar5, %symconst_1, 0:i8
%4:i8 = or %symconst_3, %3
infer %4
%5:i8 = or %symconst_3, %symconst_1
%6:i8 = select %newvar5, %5, %symconst_3
result %6

C3 | (select newvar5 C1 0)
  =>
select newvar5 (C3 | C1) C3
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1099) && match(I, m_c_Or(m_Constant(&x2), m_Select(m_Value(x1), m_Constant(&x0), m_Zero())))) {
if (util::check_width(x1,1) && util::dc(DT, I, x1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateSelect(x1, B->CreateOr(x2, x0), x2);
if (util::check_width(ret, I)) {
  St.hit(1099, 1);
  return ret;

}
}
}}

/* Opt : 2748
%newvar1:i1 = var ; newvar1
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%3:i32 = select %newvar1, %symconst_1, %symconst_2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = trunc %symconst_2
%7:i8 = select %newvar1, %5, %6
result %7

trunc((select newvar1 C1 C2))
  =>
select newvar1 trunc(C1) trunc(C2)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2748) && match(I, m_Trunc(m_Select(m_Value(x3), m_Constant(&x2), m_Constant(&x1))))) {
if (util::check_width(x3,1) && util::dc(DT, I, x3)) {
  auto ret = B->CreateSelect(x3, B->CreateTrunc(x2, T(8, B)), B->CreateTrunc(x1, T(8, B)));
if (util::check_width(ret, I)) {
  St.hit(2748, 1);
  return ret;

}
}
}}

/* Opt : 1669
%v0:i32 = var ; v0
%newvar0:i32 = var ; newvar0
%2:i32 = shl 1:i32, %newvar0
%3:i32 = and %v0, %2
%4:i1 = ne 0:i32, %3
%5:i32 = select %4, 1:i32, 0:i32
infer %5
%6:i32 = lshr %3, %newvar0
result %6

select ((v0 & (1 << newvar0)) != 0) 1 0
  =>
(v0 & (1 << newvar0)) >>l newvar0
*/
{
llvm::Value *x4 = nullptr, *x1 = nullptr, *x0 = nullptr, *x3 = nullptr, *x2 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1669) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), &x2 <<= m_c_And(m_Value(x1), &x3 <<= m_Shl(&x4 <<= m_ExtInt("1", 32), m_Value(x0)))), &x4 <<= m_ExtInt("1", 32), m_Zero()))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x1) && util::dc(DT, I, x3) && util::dc(DT, I, x0)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateLShr(x2, x0);
if (util::check_width(ret, I)) {
  St.hit(1669, 3);
  return ret;

}
}
}}

/* Opt : 1097
%newvar0:i8 = var ; newvar0
%1:i8 = or 0:i8, %newvar0
infer %1
result %newvar0

newvar0 | 0
  =>
newvar0
*/
{
llvm::Value *x0 = nullptr;
if (util::filter(F, 1097) && match(I, m_c_Or(m_Zero(), m_Value(x0)))) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(1097, 1);
  return ret;

}
}
}
/* Opt : 2696
%newvar1:i1 = var ; newvar1
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%3:i32 = select %newvar1, %symconst_1, %symconst_2
%4:i64 = sext %3
infer %4
%5:i64 = sext %symconst_1
%6:i64 = sext %symconst_2
%7:i64 = select %newvar1, %5, %6
result %7

sext((select newvar1 C1 C2))
  =>
select newvar1 sext(C1) sext(C2)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2696) && match(I, m_SExt(m_Select(m_Value(x3), m_Constant(&x2), m_Constant(&x1))))) {
if (util::check_width(x3,1) && util::dc(DT, I, x3)) {
  auto ret = B->CreateSelect(x3, B->CreateSExt(x2, T(64, B)), B->CreateSExt(x1, T(64, B)));
if (util::check_width(ret, I)) {
  St.hit(2696, 1);
  return ret;

}
}
}}

/* Opt : 2626
%v0:i8 = var ; v0
%1:i32 = zext %v0
%2:i64 = zext %1
infer %2
%3:i64 = zext %v0
result %3

zext(zext(v0))
  =>
zext(v0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2626) && match(I, m_ZExt(m_ZExt(m_Value(x2))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateZExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2626, 1);
  return ret;

}
}
}}

/* Opt : 3244
%v0:i1 = var ; v0
%1:i32 = zext %v0
%newvar52:i1 = var ; newvar52
%3:i32 = zext %newvar52
%4:i32 = xor %1, %3
%5:i1 = ne 0:i32, %4
infer %5
%6:i1 = xor %v0, %newvar52
result %6

(zext(v0) ^ zext(newvar52)) != 0
  =>
v0 ^ newvar52
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3244) && match(I, m_c_ICmp(P0, m_Zero(), m_c_Xor(m_ZExt(m_Value(x3)), m_ZExt(m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x3,1) && util::check_width(x1,1) && util::dc(DT, I, x3) && util::dc(DT, I, x1)) {
  auto ret = B->CreateXor(x3, x1);
if (util::check_width(ret, I)) {
  St.hit(3244, 3);
  return ret;

}
}
}}

/* Opt : 263
%v0:i8 = var ; v0
%symconst_1:i8 = var ; symconst_1
%2:i8 = add %v0, %symconst_1
%3:i8 = sub %2, %symconst_1
infer %3
result %v0

(v0 + C1) - C1
  =>
v0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 263) && match(I, m_Sub(m_c_Add(m_Value(x1), m_Constant(&x0)), m_Deferred(x0)))) {
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(263, 2);
  return ret;

}
}
}
/* Opt : 1247
%newvar4:i1 = var ; newvar4
%1:i1 = xor 1:i1, %newvar4
%2:i1 = xor 1:i1, %1
infer %2
result %newvar4

~~newvar4
  =>
newvar4
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1247) && match(I, m_c_Xor(m_AllOnes(), m_c_Xor(m_AllOnes(), m_Value(x2))))) {
if (util::check_width(x2,1)) {
  auto ret = x2;
if (util::check_width(ret, I)) {
  St.hit(1247, 2);
  return ret;

}
}
}}

/* Opt : 2746
%v0:i8 = var ; v0
%1:i32 = sext %v0
%2:i8 = trunc %1
infer %2
result %v0

trunc(sext(v0))
  =>
v0
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2746) && match(I, m_Trunc(m_SExt(m_Value(x2))))) {
  auto ret = x2;
if (util::check_width(ret, I)) {
  St.hit(2746, 2);
  return ret;

}
}
}
/* Opt : 2482
%v0:i32 = var ; v0
%1:i32 = and 1:i32, %v0
%2:i1 = ne 0:i32, %1
%3:i32 = select %2, 1:i32, 0:i32
%4:i1 = ne 0:i32, %3
%5:i1 = xor 1:i1, %4
%6:i32 = zext %5
infer %6
%7:i32 = sub 1:i32, %1
result %7

zext(~((select ((v0 & 1) != 0) 1 0) != 0))
  =>
1 - (v0 & 1)
*/
{
llvm::Value *x3 = nullptr, *x5 = nullptr, *x2 = nullptr, *x4 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P1, P0;
if (util::filter(F, 2482) && match(I, m_ZExt(m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Zero(), m_Select(m_c_ICmp(P1, m_Zero(), &x4 <<= m_c_And(&x5 <<= m_ExtInt("1", 32), m_Value(x2))), &x5 <<= m_ExtInt("1", 32), m_Zero())))))) {
if (P0 == ICmpInst::ICMP_NE && P1 == ICmpInst::ICMP_NE && util::dc(DT, I, x4) && util::dc(DT, I, x2)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateSub(C0(x4), x4);
if (util::check_width(ret, I)) {
  St.hit(2482, 6);
  return ret;

}
}
}}

/* Opt : 2097
%newvar0:i8 = var ; newvar0
%1:i8 = and 1:i8, %newvar0
%2:i1 = ne 0:i8, %1
%symconst_3:i8 = var ; symconst_3
%4:i8 = select %2, %symconst_3, 0:i8
infer %4
%5:i8 = mul %symconst_3, %1
result %5

select ((newvar0 & 1) != 0) C3 0
  =>
C3 * (newvar0 & 1)
*/
{
llvm::Value *x3 = nullptr, *x1 = nullptr, *x2 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2097) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), &x2 <<= m_c_And(&x3 <<= m_ExtInt("1", 8), m_Value(x1))), m_Constant(&x0), m_Zero()))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto C0 = C(8, 1, B);
  auto ret = B->CreateMul(x2, x0);
if (util::check_width(ret, I)) {
  St.hit(2097, 3);
  return ret;

}
}
}}

/* Opt : 2840
%symconst_1:i32 = var ; symconst_1
%newvar1:i8 = var ; newvar1
%2:i32 = zext %newvar1
%3:i32 = add %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = add %newvar1, %5
result %6

trunc((C1 + zext(newvar1)))
  =>
newvar1 + trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2840) && match(I, m_Trunc(m_c_Add(m_Constant(&x3), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateAdd(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2840, 2);
  return ret;

}
}
}}

/* Opt : 2862
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = sext %v0
%3:i32 = add %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = add %v0, %5
result %6

trunc((C1 + sext(v0)))
  =>
v0 + trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2862) && match(I, m_Trunc(m_c_Add(m_Constant(&x3), m_SExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateAdd(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2862, 2);
  return ret;

}
}
}}

/* Opt : 2438
%symconst_1:i4 = var ; symconst_1
%v0:i8 = var ; v0
%2:i4 = trunc %v0
%3:i4 = and %symconst_1, %2
%4:i8 = zext %3
infer %4
%5:i8 = zext %symconst_1
%6:i8 = and %v0, %5
result %6

zext((C1 & trunc(v0)))
  =>
v0 & zext(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2438) && match(I, m_ZExt(m_c_And(m_Constant(&x3), m_Trunc(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateAnd(x2, B->CreateZExt(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2438, 2);
  return ret;

}
}
}}

/* Opt : 878
%symconst_2:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11111) ; symconst_2
%1:i32 = width %symconst_2
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%symconst_1:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx11) ; symconst_1
%4:i32 = width %symconst_1
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%newvar2:i8 = var ; newvar2
%7:i8 = width %newvar2
%8:i1 = eq 8:i8, %7
pc %8 1:i1
%9:i32 = zext %newvar2
%10:i32 = width %9
%11:i1 = eq 32:i32, %10
pc %11 1:i1
%12:i32 = ashr %9, %symconst_1
%13:i32 = and %symconst_2, %12
infer %13
result %12

width(C2 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11111)) == 32 && 
width(C1 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx11)) == 32 && 
width(newvar2) == 8 && 
let var0 = zext(newvar2);
width(var0) == 32
  |= 
let var1 = (var0 >>a C1);
C2 & var1
  =>
var1
*/
{
llvm::Value *x0 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr;
if (util::filter(F, 878) && match(I, m_c_And(m_Constant(&x4), &x5 <<= m_AShr(&x1 <<= m_ZExt(m_Value(x2)), m_Constant(&x3))))) {
if (util::dc(DT, I, x1) && util::dc(DT, I, x2) && util::dc(DT, I, x3) && util::k1(x4, "11111", 32) && util::k1(x3, "11", 32) && util::check_width(x4,32) && util::check_width(x3,32) && util::check_width(x2,8) && util::check_width(x1,32)) {
  auto ret = x5;
if (util::check_width(ret, I)) {
  St.hit(878, 1);
  return ret;

}
}
}}

/* Opt : 1212
%symconst_1:i8 = var ; symconst_1
%symconst_2:i8 = var ; symconst_2
%2:i1 = ne %symconst_1, %symconst_2
pc %2 1:i1
%newvar0:i8 = var ; newvar0
%4:i1 = ne %symconst_1, %newvar0
%5:i8 = select %4, %symconst_2, %symconst_1
%6:i1 = ne %symconst_1, %5
%7:i1 = xor 1:i1, %6
infer %7
%8:i1 = eq %symconst_1, %newvar0
result %8

C2 != C1
  |= 
~(C1 != (select (C1 != newvar0) C2 C1))
  =>
C1 == newvar0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P1, P0;
if (util::filter(F, 1212) && match(I, m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Constant(&x2), m_Select(m_c_ICmp(P1, m_Deferred(x2), m_Value(x4)), m_Constant(&x1), m_Deferred(x2)))))) {
if (P0 == ICmpInst::ICMP_NE && P1 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x4) && (ne(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x2, x4);
if (util::check_width(ret, I)) {
  St.hit(1212, 5);
  return ret;

}
}
}}

/* Opt : 2750
%v0:i8 = var ; v0
%1:i32 = zext %v0
%newvar1:i8 = var ; newvar1
%3:i32 = zext %newvar1
%4:i32 = or %1, %3
%5:i8 = trunc %4
infer %5
%6:i8 = or %v0, %newvar1
result %6

trunc((zext(v0) | zext(newvar1)))
  =>
v0 | newvar1
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2750) && match(I, m_Trunc(m_c_Or(m_ZExt(m_Value(x4)), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x4) && util::dc(DT, I, x2)) {
  auto ret = B->CreateOr(x4, x2);
if (util::check_width(ret, I)) {
  St.hit(2750, 3);
  return ret;

}
}
}}

/* Opt : 2720
%symconst_1:i4 = var ; symconst_1
%newvar0:i4 = var ; newvar0
%2:i4 = add %symconst_1, %newvar0
%3:i4 = subnsw %2, %symconst_1
%4:i8 = sext %3
infer %4
%5:i8 = sext %newvar0
result %5

sext(((C1 + newvar0) -nsw C1))
  =>
sext(newvar0)
*/
{
llvm::Value *x1 = nullptr, *x2 = nullptr, *x0 = nullptr;
if (util::filter(F, 2720) && match(I, m_SExt(m_NSWSub(m_c_Add(m_Constant(&x1), m_Value(x2)), m_Deferred(x1))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateSExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2720, 2);
  return ret;

}
}
}}

/* Opt : 2365
%newvar3:i1 = var ; newvar3
%1:i32 = zext %newvar3
%2:i1 = ne 0:i32, %1
%3:i32 = zext %2
infer %3
result %1

zext((zext(newvar3) != 0))
  =>
zext(newvar3)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2365) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), &x1 <<= m_ZExt(m_Value(x2)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x2,1) && util::dc(DT, I, x2)) {
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(2365, 2);
  return ret;

}
}
}}

/* Opt : 612
%symconst_3:i32 = var ; symconst_3
%symDF_K1:i32 = var ; symDF_K1
%2:i1 = knownones %symconst_3, %symDF_K1
pc %2 1:i1
%symconst_5:i32 = var ; symconst_5
%4:i1 = knownones %symDF_K1, %symconst_5
pc %4 1:i1
%newvar0:i32 = var ; newvar0
%6:i32 = and %symconst_3, %newvar0
%7:i32 = and %symconst_5, %6
infer %7
%8:i32 = and %symconst_5, %newvar0
result %8

symconst_3.k1 <<=1 C5
  |= 
let var0 = (C3 & newvar0);
C5 & var0
  =>
C5 & newvar0
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr, *x6 = nullptr;
if (util::filter(F, 612) && match(I, m_c_And(m_Constant(&x2), m_c_And(m_Constant(&x5), m_Value(x6))))) {
if (util::symk1bind(x5, x3, B) && util::dc(DT, I, x2) && util::dc(DT, I, x6) && util::symk1test(x3, x2)) {
  auto ret = B->CreateAnd(x2, x6);
if (util::check_width(ret, I)) {
  St.hit(612, 1);
  return ret;

}
}
}}

/* Opt : 2318
%v0:i32 = var ; v0
%1:i32 = and 1:i32, %v0
%2:i1 = ne 0:i32, %1
%3:i32 = select %2, 1:i32, 0:i32
%4:i1 = ne 0:i32, %3
%5:i8 = zext %4
infer %5
%6:i8 = trunc %1
result %6

zext(((select ((v0 & 1) != 0) 1 0) != 0))
  =>
trunc((v0 & 1))
*/
{
llvm::Value *x3 = nullptr, *x1 = nullptr, *x2 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P1, P0;
if (util::filter(F, 2318) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), m_Select(m_c_ICmp(P1, m_Zero(), &x2 <<= m_c_And(&x3 <<= m_ExtInt("1", 32), m_Value(x1))), &x3 <<= m_ExtInt("1", 32), m_Zero()))))) {
if (P0 == ICmpInst::ICMP_NE && P1 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x1)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateTrunc(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2318, 5);
  return ret;

}
}
}}

/* Opt : 1122
%symconst_2:i8 = var ; symconst_2
%symconst_1:i8 = var ; symconst_1
%2:i8 = xor 255:i8, %symconst_1
%3:i1 = eq %symconst_2, %2
pc %3 1:i1
%v0:i8 = var ; v0
%5:i8 = and %symconst_2, %v0
%6:i8 = or %symconst_1, %5
infer %6
%7:i8 = or %symconst_1, %v0
result %7

C2 == ~C1
  |= 
C1 | (v0 & C2)
  =>
v0 | C1
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
if (util::filter(F, 1122) && match(I, m_c_Or(m_Constant(&x1), m_c_And(m_Constant(&x2), m_Value(x3))))) {
if (util::dc(DT, I, x1) && util::dc(DT, I, x3) && (eq(util::V(x2), flip(util::V(x1))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateOr(x1, x3);
if (util::check_width(ret, I)) {
  St.hit(1122, 1);
  return ret;

}
}
}}

/* Opt : 1237
%symconst_1:i8 = var ; symconst_1
%v0:i8 = var ; v0
%2:i8 = and %symconst_1, %v0
%3:i1 = eq %symconst_1, %2
%4:i1 = xor 1:i1, %3
infer %4
%5:i1 = ult %2, %symconst_1
result %5

~(C1 == (v0 & C1))
  =>
(v0 & C1) <u C1
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1237) && match(I, m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Constant(&x2), &x4 <<= m_c_And(m_Deferred(x2), m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x4) && util::dc(DT, I, x2) && util::dc(DT, I, x1)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULT, x4, x2);
if (util::check_width(ret, I)) {
  St.hit(1237, 1);
  return ret;

}
}
}}

/* Opt : 3968
%symconst_1:i32 = var ; symconst_1
%symDF_K1:i32 = var ; symDF_K1
%2:i1 = knownones %symconst_1, %symDF_K1
pc %2 1:i1
%symDF_DB:i32 = var ; symDF_DB
%4:i1 = knownones %symDF_K1, %symDF_DB
pc %4 1:i1
%v0:i32 = var ; v0
%newvar0:i32 = var ; newvar0
%7:i32 = and %symconst_1, %newvar0
%8:i32 = or %v0, %7
%9:i32 = demandedmask %8, %symDF_DB
infer %9
%10:i32 = or %v0, %newvar0
%11:i32 = demandedmask %10, %symDF_DB
result %11

symconst_1.k1 <<=1 @db
  |= 
let var1 = (C1 & newvar0);
let var0 = v0 | var1;
var0
  =>
let var2 = v0 | newvar0;
var2
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr, *x7 = nullptr, *x6 = nullptr;
if (util::filter(F, 3968) && match(I, m_c_Or(m_Value(x7), m_c_And(m_Constant(&x5), m_Value(x6))))) {
if (util::symk1bind(x5, x3, B) && util::symdb(DB, I, x2, B) && util::dc(DT, I, x2) && util::symk1test(x3, x2)) {
  auto ret = B->CreateOr(x7, x6);
if (util::check_width(ret, I)) {
  St.hit(3968, 1);
  return ret;

}
}
}}

/* Opt : 3156
%symconst_5:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11010) ; symconst_5
%1:i32 = width %symconst_5
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%v0:i32 = var ; v0
%4:i32 = width %v0
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%6:i32 = and 469762048:i32, %v0
%7:i32 = lshr %6, %symconst_5
%8:i1 = eq 7:i32, %7
infer %8
%9:i1 = eq 469762048:i32, %6
result %9

width(C5 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11010)) == 32 && 
width(v0) == 32
  |= 
let var1 = (v0 & 0x1C000000);
let var0 = (var1 >>l C5);
var0 == 7
  =>
var1 == 0x1C000000
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3156) && match(I, m_c_ICmp(P0, m_ExtInt("7", 32), m_LShr(&x3 <<= m_c_And(m_Value(x1), &x4 <<= m_ExtInt("469762048", 32)), m_Constant(&x2))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x3) && util::dc(DT, I, x1) && util::k1(x2, "11010", 32) && util::k0(x2, "101", 32) && util::check_width(x2,32) && util::check_width(x1,32)) {
  auto C0 = C(32, 469762048, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, C0(x3), x3);
if (util::check_width(ret, I)) {
  St.hit(3156, 1);
  return ret;

}
}
}}

/* Opt : 19
%v0:i64 = var (range=[0,1)) ; v0
%symconst_1:i64 = var ; symconst_1
%2:i64 = add %v0, %symconst_1
infer %2
result %symconst_1

v0 (range=[0,1)) + C1
  =>
C1
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 19) && match(I, m_c_Add(m_Value(x1), m_Constant(&x0)))) {
if (util::cr(x1, "0", "1")) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(19, 1);
  return ret;

}
}
}}

/* Opt : 1978
%v0:i32 = var ; v0
%1:i32 = and 536870912:i32, %v0
%2:i1 = ne 0:i32, %1
%3:i32 = select %2, 536870912:i32, 0:i32
infer %3
result %1

select ((v0 & 0x20000000) != 0) 0x20000000 0
  =>
v0 & 0x20000000
*/
{
llvm::Value *x2 = nullptr, *x0 = nullptr, *x1 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1978) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), &x1 <<= m_c_And(&x2 <<= m_ExtInt("536870912", 32), m_Value(x0))), &x2 <<= m_ExtInt("536870912", 32), m_Zero()))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x0)) {
  auto C0 = C(32, 536870912, B);
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(1978, 4);
  return ret;

}
}
}}

/* Opt : 2793
%v0:i16 = var ; v0
%1:i32 = zext %v0
%v3:i16 = var ; v3
%3:i32 = zext %v3
%4:i32 = add %1, %3
%5:i16 = trunc %4
infer %5
%6:i16 = add %v0, %v3
result %6

trunc((zext(v0) + zext(v3)))
  =>
v3 + v0
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2793) && match(I, m_Trunc(m_c_Add(m_ZExt(m_Value(x4)), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x4) && util::dc(DT, I, x2)) {
  auto ret = B->CreateAdd(x4, x2);
if (util::check_width(ret, I)) {
  St.hit(2793, 3);
  return ret;

}
}
}}

/* Opt : 884
%v0:i8 = var ; v0
%symDF_K0:i8 = var ; symDF_K0
%2:i1 = knownzeros %v0, %symDF_K0
pc %2 1:i1
%symconst_2:i8 = var ; symconst_2
%4:i8 = xor 255:i8, %symDF_K0
%5:i1 = eq %symconst_2, %4
pc %5 1:i1
%6:i8 = and %v0, %symconst_2
infer %6
result %v0

C2 == ~v0.k0
  |= 
v0 & C2
  =>
v0
*/
{
llvm::Value *x0 = nullptr, *x4 = nullptr, *x1 = nullptr, *x3 = nullptr, *x2 = nullptr;
if (util::filter(F, 884) && match(I, m_c_And(m_Value(x4), m_Constant(&x2)))) {
if (util::symk0bind(x4, x1, B) && (eq(util::V(x2), flip(util::V(x1))) == llvm::APInt(1, 1))) {
  auto ret = x4;
if (util::check_width(ret, I)) {
  St.hit(884, 1);
  return ret;

}
}
}}

/* Opt : 3356
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%newvar1:i1 = var ; newvar1
%3:i32 = zext %newvar1
%4:i1 = ne %1, %3
infer %4
%5:i1 = xor %newvar0, %newvar1
result %5

zext(newvar0) != zext(newvar1)
  =>
newvar1 ^ newvar0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3356) && match(I, m_c_ICmp(P0, m_ZExt(m_Value(x3)), m_ZExt(m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x3,1) && util::check_width(x1,1) && util::dc(DT, I, x3) && util::dc(DT, I, x1)) {
  auto ret = B->CreateXor(x3, x1);
if (util::check_width(ret, I)) {
  St.hit(3356, 2);
  return ret;

}
}
}}

/* Opt : 251
%v0:i64 = var ; v0
%v1:i64 = var ; v1
%2:i64 = sub %v0, %v1
%3:i64 = sub 0:i64, %2
infer %3
%4:i64 = sub %v1, %v0
result %4

0 - (v0 - v1)
  =>
v1 - v0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 251) && match(I, m_Sub(m_Zero(), m_Sub(m_Value(x1), m_Value(x0))))) {
if (util::dc(DT, I, x0) && util::dc(DT, I, x1)) {
  auto ret = B->CreateSub(x0, x1);
if (util::check_width(ret, I)) {
  St.hit(251, 1);
  return ret;

}
}
}}

/* Opt : 471
%newvar0:i32 = var ; newvar0
%1:i32 = width %newvar0
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%symconst_5:i32 = var (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) ; symconst_5
%4:i32 = width %symconst_5
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%6:i32 = and %newvar0, %symconst_5
%7:i32 = mul 2:i32, %6
%8:i32 = add 1:i32, %7
%9:i32 = udiv %8, 8:i32
infer %9
%10:i32 = ashr %6, 2:i32
result %10

width(newvar0) == 32 && 
width(C5 (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)) == 32
  |= 
let var2 = (C5 & newvar0);
let var1 = (var2 * 2);
let var0 = (var1 + 1);
var0 /u 8
  =>
var2 >>a 2
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
if (util::filter(F, 471) && match(I, m_UDiv(m_c_Add(m_ExtInt("1", 32), m_c_Mul(&x3 <<= m_ExtInt("2", 32), &x4 <<= m_c_And(m_Value(x2), m_Constant(&x1)))), m_ExtInt("8", 32)))) {
if (util::dc(DT, I, x4) && util::dc(DT, I, x2) && util::dc(DT, I, x1) && util::k0(x1, "10000000000000000000000000000000", 32) && util::check_width(x2,32) && util::check_width(x1,32)) {
  auto C0 = C(32, 2, B);
  auto ret = B->CreateAShr(x4, C0(x4));
if (util::check_width(ret, I)) {
  St.hit(471, 6);
  return ret;

}
}
}}

/* Opt : 2903
%symconst_1:i32 = var ; symconst_1
%1:i1 = ult 0:i32, %symconst_1
%v0:i8 = var ; v0
%3:i8 = width %v0
%4:i32 = zext %3
%5:i1 = ult %symconst_1, %4
%6:i1 = and %1, %5
pc %6 1:i1
%7:i32 = zext %v0
%8:i32 = ashr %7, %symconst_1
%9:i8 = trunc %8
infer %9
%10:i8 = trunc %symconst_1
%11:i8 = lshr %v0, %10
result %11

(0 <u C1) & (C1 <u zext(width(v0)))
  |= 
trunc((zext(v0) >>a C1))
  =>
v0 >>l trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x6 = nullptr, *x5 = nullptr;
if (util::filter(F, 2903) && match(I, m_Trunc(m_AShr(m_ZExt(m_Value(x3)), m_Constant(&x4))))) {
if (util::dc(DT, I, x3) && ((ult(llvm::APInt(32, 0), util::V(x4)) & ult(util::V(x4), util::W(x3).zext(64))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateLShr(x3, B->CreateTrunc(x4, T(x3)));
if (util::check_width(ret, I)) {
  St.hit(2903, 2);
  return ret;

}
}
}}

/* Opt : 293
%v0:i8 = var ; v0
%symconst_1:i8 = var ; symconst_1
%2:i8 = add %v0, %symconst_1
%symconst_2:i8 = var ; symconst_2
%4:i8 = sub %2, %symconst_2
infer %4
%5:i8 = sub %symconst_1, %symconst_2
%6:i8 = add %v0, %5
result %6

(v0 + C1) - C2
  =>
v0 + (C1 - C2)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 293) && match(I, m_Sub(m_c_Add(m_Value(x2), m_Constant(&x1)), m_Constant(&x0)))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateAdd(x2, B->CreateSub(x1, x0));
if (util::check_width(ret, I)) {
  St.hit(293, 1);
  return ret;

}
}
}}

/* Opt : 3182
%newvar0:i32 = var ; newvar0
%symDF_K0:i32 = var ; symDF_K0
%2:i1 = knownzeros %newvar0, %symDF_K0
pc %2 1:i1
%symconst_4:i32 = var ; symconst_4
%4:i1 = knownones %symDF_K0, %symconst_4
pc %4 1:i1
%symconst_1:i32 = var ; symconst_1
%6:i32 = and %newvar0, %symconst_4
%7:i1 = ne %symconst_1, %6
infer %7
%8:i32 = sub %symconst_1, 1:i32
%9:i1 = ult %8, %symconst_1
result %9

newvar0.k0 <<=1 C4
  |= 
let var0 = (C4 & newvar0);
C1 != var0
  =>
let var1 = (C1 - 1);
var1 <u C1
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr, *x6 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3182) && match(I, m_c_ICmp(P0, m_Constant(&x6), m_c_And(m_Value(x5), m_Constant(&x2))))) {
if (util::symk0bind(x5, x3, B) && P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x6) && util::symk1test(x3, x2)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULT, B->CreateSub(x6, C0(x6)), x6);
if (util::check_width(ret, I)) {
  St.hit(3182, 2);
  return ret;

}
}
}}

/* Opt : 2895
%newvar0:i64 = var ; newvar0
%1:i32 = trunc %newvar0
%2:i16 = trunc %1
infer %2
%3:i16 = trunc %newvar0
result %3

trunc(trunc(newvar0))
  =>
trunc(newvar0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2895) && match(I, m_Trunc(m_Trunc(m_Value(x2))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateTrunc(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2895, 1);
  return ret;

}
}
}}

/* Opt : 2817
%newvar0:i8 = var ; newvar0
%1:i32 = zext %newvar0
%symconst_1:i32 = var ; symconst_1
%3:i32 = sub %1, %symconst_1
%4:i8 = trunc %3
infer %4
%5:i32 = sub 0:i32, %symconst_1
%6:i8 = trunc %5
%7:i8 = add %newvar0, %6
result %7

trunc((zext(newvar0) - C1))
  =>
newvar0 + trunc((0 - C1))
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2817) && match(I, m_Trunc(m_Sub(m_ZExt(m_Value(x3)), m_Constant(&x1))))) {
if (util::dc(DT, I, x3)) {
  auto C0 = C(32, 0, B);
  auto ret = B->CreateAdd(x3, B->CreateTrunc(B->CreateSub(C0(x1), x1), T(x3)));
if (util::check_width(ret, I)) {
  St.hit(2817, 2);
  return ret;

}
}
}}

/* Opt : 2731
%v0:i16 = var ; v0
%1:i32 = zext %v0 (hasExternalUses)
%v2:i16 = var ; v2
%3:i32 = zext %v2
%4:i32 = and %1, %3
%5:i16 = trunc %4
infer %5
%6:i16 = and %v0, %v2
result %6

trunc((zext(v0) & zext(v2)))
  =>
v2 & v0
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2731) && match(I, m_Trunc(m_c_And(m_ZExt(m_Value(x4)), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x4) && util::dc(DT, I, x2)) {
  auto ret = B->CreateAnd(x4, x2);
if (util::check_width(ret, I)) {
  St.hit(2731, 3);
  return ret;

}
}
}}

/* Opt : 1502
%newvar0:i1 = var ; newvar0
%symconst_1:i8 = var ; symconst_1
%2:i8 = select %newvar0, %symconst_1, %symconst_1
infer %2
result %symconst_1

select newvar0 C1 C1
  =>
C1
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1502) && match(I, m_Select(m_Value(x1), m_Constant(&x0), m_Deferred(x0)))) {
if (util::check_width(x1,1)) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(1502, 3);
  return ret;

}
}
}}

/* Opt : 3604
%v5:i16 = var ; v5
%1:i32 = zext %v5
%v0:i16 = var ; v0
%3:i32 = zext %v0 (hasExternalUses)
%4:i1 = slt %1, %3
infer %4
%5:i1 = ult %v5, %v0
result %5

zext(v5) <s zext(v0)
  =>
v5 <u v0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3604) && match(I, m_ICmp(P0, m_ZExt(m_Value(x3)), m_ZExt(m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_SLT && util::dc(DT, I, x3) && util::dc(DT, I, x1)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULT, x3, x1);
if (util::check_width(ret, I)) {
  St.hit(3604, 2);
  return ret;

}
}
}}

/* Opt : 2791
%symconst_3:i32 = var ; symconst_3
%newvar0:i1 = var ; newvar0
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%4:i32 = select %newvar0, %symconst_1, %symconst_2
%5:i32 = or %symconst_3, %4
%6:i8 = trunc %5
infer %6
%7:i32 = select 1:i1, %symconst_1, %symconst_2
%8:i32 = or %symconst_3, %7
%9:i8 = trunc %8
%10:i32 = select 0:i1, %symconst_1, %symconst_2
%11:i32 = or %symconst_3, %10
%12:i8 = trunc %11
%13:i8 = select %newvar0, %9, %12
result %13

trunc((C3 | (select newvar0 C1 C2)))
  =>
select newvar0 trunc((C3 | (select 1 C1 C2))) trunc((C3 | (select 0 C1 C2)))
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2791) && match(I, m_Trunc(m_c_Or(m_Constant(&x4), m_Select(m_Value(x3), m_Constant(&x2), m_Constant(&x1)))))) {
if (util::check_width(x3,1) && util::dc(DT, I, x3)) {
  auto C0 = C(1, -1, B);
  auto C1 = C(1, 0, B);
  auto ret = B->CreateSelect(x3, B->CreateTrunc(B->CreateOr(x4, B->CreateSelect(C0(), x2, x1)), T(8, B)), B->CreateTrunc(B->CreateOr(x4, B->CreateSelect(C1(), x2, x1)), T(8, B)));
if (util::check_width(ret, I)) {
  St.hit(2791, 2);
  return ret;

}
}
}}

/* Opt : 2542
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%2:i1 = ne 0:i32, %1
%3:i8 = zext %2
infer %3
%4:i8 = zext %newvar0
result %4

zext((zext(newvar0) != 0))
  =>
zext(newvar0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2542) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), m_ZExt(m_Value(x2)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x2,1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateZExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2542, 2);
  return ret;

}
}
}}

/* Opt : 1451
%v0:i32 = var ; v0
%symconst_3:i32 = var (knownBits=11111111xxxxxxxxxxxxxxxxxxxxxxxx) ; symconst_3
%2:i32 = and %v0, %symconst_3
%symconst_4:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11xxx) ; symconst_4
%4:i32 = lshr %2, %symconst_4
infer %4
%5:i32 = lshr %v0, %symconst_4
result %5

(v0 & C3 (knownBits=11111111xxxxxxxxxxxxxxxxxxxxxxxx)) >>l C4 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11xxx)
  =>
v0 >>l C4
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1451) && match(I, m_LShr(m_c_And(m_Value(x2), m_Constant(&x1)), m_Constant(&x0)))) {
if (util::dc(DT, I, x2) && util::dc(DT, I, x0) && util::k1(x1, "11111111000000000000000000000000", 32) && util::k1(x0, "11000", 32)) {
  auto ret = B->CreateLShr(x2, x0);
if (util::check_width(ret, I)) {
  St.hit(1451, 1);
  return ret;

}
}
}}

/* Opt : 3165
%newvar0:i64 = var ; newvar0
%newvar5:i64 = var ; newvar5
%2:i64 = sub %newvar0, %newvar5
%3:i1 = eq 0:i64, %2
infer %3
%4:i1 = eq %newvar0, %newvar5
result %4

(newvar0 - newvar5) == 0
  =>
newvar5 == newvar0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3165) && match(I, m_c_ICmp(P0, m_Zero(), m_Sub(m_Value(x1), m_Value(x0))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x1, x0);
if (util::check_width(ret, I)) {
  St.hit(3165, 1);
  return ret;

}
}
}}

/* Opt : 3991
%symDF_DB:i32 = var ; symDF_DB
%symconst_3:i32 = var ; symconst_3
%2:i1 = knownzeros %symDF_DB, %symconst_3
pc %2 1:i1
%v0:i32 = var ; v0
%4:i32 = and %symconst_3, %v0
%5:i32 = demandedmask %4, %symDF_DB
infer %5
%6:i32 = demandedmask 0:i32, %symDF_DB
result %6

@db <<=0 C3
  |= 
v0 & C3
  =>
0
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
if (util::filter(F, 3991) && match(I, m_c_And(m_Constant(&x2), m_Value(x4)))) {
if (util::symdb(DB, I, x3, B) && util::dc(DT, I, x3) && util::symk0test(x3, x2)) {
  auto C0 = C(32, 0, B);
  auto ret = C0(I);
if (util::check_width(ret, I)) {
  St.hit(3991, 2);
  return ret;

}
}
}}

/* Opt : 1295
%newvar2:i64 = var ; newvar2
%1:i64 = and 18446744073709551615:i64, %newvar2
%2:i64 = xor 18446744073709551615:i64, %1
infer %2
%3:i64 = sub 18446744073709551615:i64, %newvar2
result %3

~(newvar2 & 0xFFFFFFFFFFFFFFFF)
  =>
0xFFFFFFFFFFFFFFFF - newvar2
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1295) && match(I, m_c_Xor(&x1 <<= m_AllOnes(), m_c_And(&x1 <<= m_AllOnes(), m_Value(x0))))) {
if (util::dc(DT, I, x0)) {
  auto C0 = C(64, -1, B);
  auto ret = B->CreateSub(C0(x0), x0);
if (util::check_width(ret, I)) {
  St.hit(1295, 1);
  return ret;

}
}
}}

/* Opt : 1271
%v0:i32 = var (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) ; v0
%1:i1 = eq 0:i32, %v0
%2:i1 = xor 1:i1, %1
infer %2
%3:i1 = slt 0:i32, %v0
result %3

~(v0 (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) == 0)
  =>
0 <s v0
*/
{
llvm::Value *x2 = nullptr, *x3 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1271) && match(I, m_c_Xor(m_AllOnes(), m_c_ICmp(P0, &x3 <<= m_Zero(), m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x1) && util::k0(x1, "10000000000000000000000000000000", 32)) {
  auto C0 = C(32, 0, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_SLT, C0(x1), x1);
if (util::check_width(ret, I)) {
  St.hit(1271, 1);
  return ret;

}
}
}}

/* Opt : 772
%newvar0:i32 = var ; newvar0
%symDF_K0:i32 = var ; symDF_K0
%2:i1 = knownzeros %newvar0, %symDF_K0
pc %2 1:i1
%symconst_3:i32 = var ; symconst_3
%4:i1 = knownones %symDF_K0, %symconst_3
pc %4 1:i1
%5:i32 = and %newvar0, %symconst_3
infer %5
result 0:i32

newvar0.k0 <<=1 C3
  |= 
C3 & newvar0
  =>
0
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr;
if (util::filter(F, 772) && match(I, m_c_And(m_Value(x5), m_Constant(&x2)))) {
if (util::symk0bind(x5, x3, B) && util::symk1test(x3, x2)) {
  auto C0 = C(32, 0, B);
  auto ret = C0(I);
if (util::check_width(ret, I)) {
  St.hit(772, 1);
  return ret;

}
}
}}

/* Opt : 3368
%newvar0:i8 = var ; newvar0
%1:i1 = ne %newvar0, %newvar0
infer %1
%2:i1 = ne 0:i8, 0:i8
result %2

newvar0 != newvar0
  =>
0 != 0
*/
{
llvm::Value *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3368) && match(I, m_c_ICmp(P0, m_Value(x0), m_Deferred(x0)))) {
if (P0 == ICmpInst::ICMP_NE) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_NE, C0(), C0());
if (util::check_width(ret, I)) {
  St.hit(3368, 1);
  return ret;

}
}
}}

/* Opt : 2695
%v0:i16 = var ; v0
%1:i32 = sext %v0
%2:i64 = sext %1
infer %2
%3:i64 = sext %v0
result %3

sext(sext(v0))
  =>
sext(v0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2695) && match(I, m_SExt(m_SExt(m_Value(x2))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateSExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2695, 1);
  return ret;

}
}
}}

/* Opt : 1723
%symconst_7:i32 = var ; symconst_7
%symconst_8:i32 = var ; symconst_8
%2:i32 = mul 2:i32, %symconst_8
%3:i1 = eq %symconst_7, %2
pc %3 1:i1
%4:i32 = width %symconst_7
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%6:i32 = width %symconst_8
%7:i1 = eq 32:i32, %6
pc %7 1:i1
%newvar0:i32 = var ; newvar0
%9:i32 = width %newvar0
%10:i1 = eq 32:i32, %9
pc %10 1:i1
%11:i32 = and 1:i32, %newvar0
%12:i1 = ne 0:i32, %11
%13:i32 = select %12, %symconst_7, %symconst_8
infer %13
%14:i32 = shl %symconst_8, %11
result %14

C7 == (C8 * 2) && 
width(C7) == 32 && 
width(C8) == 32 && 
width(newvar0) == 32
  |= 
let var1 = (newvar0 & 1);
let var0 = (var1 != 0);
select var0 C7 C8
  =>
C8 << var1
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1723) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), &x4 <<= m_c_And(&x5 <<= m_ExtInt("1", 32), m_Value(x1))), m_Constant(&x3), m_Constant(&x2)))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x4) && util::dc(DT, I, x1) && (eq(util::V(x3), mul(llvm::APInt(32, 2), util::V(x2))) == llvm::APInt(1, 1)) && util::check_width(x3,32) && util::check_width(x2,32) && util::check_width(x1,32)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateShl(x2, x4);
if (util::check_width(ret, I)) {
  St.hit(1723, 3);
  return ret;

}
}
}}

/* Opt : 70
%symconst_1:i8 = var ; symconst_1
%symconst_2:i8 = var ; symconst_2
%2:i8 = mul 255:i8, %symconst_2
%3:i1 = eq %symconst_1, %2
pc %3 1:i1
%v1:i8 = var ; v1
%5:i8 = add %symconst_1, %v1
%6:i8 = add %symconst_2, %5
infer %6
result %v1

C1 == (C2 * 0xFF)
  |= 
C2 + (v1 + C1)
  =>
v1
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
if (util::filter(F, 70) && match(I, m_c_Add(m_Constant(&x1), m_c_Add(m_Constant(&x2), m_Value(x3))))) {
if ((eq(util::V(x2), mul(llvm::APInt(8, 255), util::V(x1))) == llvm::APInt(1, 1))) {
  auto ret = x3;
if (util::check_width(ret, I)) {
  St.hit(70, 2);
  return ret;

}
}
}}

/* Opt : 2986
%v1:i8 = var ; v1
%symconst_2:i8 = var ; symconst_2
%2:i8 = add %v1, %symconst_2
%3:i1 = eq 0:i8, %2
infer %3
%4:i8 = sub 0:i8, %symconst_2
%5:i1 = eq %v1, %4
result %5

(v1 + C2) == 0
  =>
v1 == (0 - C2)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2986) && match(I, m_c_ICmp(P0, &x2 <<= m_Zero(), m_c_Add(m_Value(x1), m_Constant(&x0))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x1)) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x1, B->CreateSub(C0(x0), x0));
if (util::check_width(ret, I)) {
  St.hit(2986, 1);
  return ret;

}
}
}}

/* Opt : 3315
%v0:i1 = var ; v0
%1:i32 = zext %v0
%newvar5:i1 = var ; newvar5
%3:i32 = zext %newvar5
%4:i8 = trunc %3
%5:i32 = zext %4
%6:i1 = ne %1, %5
infer %6
%7:i1 = xor %v0, %newvar5
result %7

zext(v0) != zext(trunc(zext(newvar5)))
  =>
v0 ^ newvar5
*/
{
llvm::Value *x5 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3315) && match(I, m_c_ICmp(P0, m_ZExt(m_Value(x5)), m_ZExt(m_Trunc(m_ZExt(m_Value(x3))))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x5,1) && util::check_width(x3,1) && util::dc(DT, I, x5) && util::dc(DT, I, x3)) {
  auto ret = B->CreateXor(x5, x3);
if (util::check_width(ret, I)) {
  St.hit(3315, 4);
  return ret;

}
}
}}

/* Opt : 3272
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%2:i8 = trunc %1
%3:i1 = ne 0:i8, %2
infer %3
result %newvar0

trunc(zext(newvar0)) != 0
  =>
newvar0
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3272) && match(I, m_c_ICmp(P0, m_Zero(), m_Trunc(m_ZExt(m_Value(x2)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x2,1)) {
  auto ret = x2;
if (util::check_width(ret, I)) {
  St.hit(3272, 3);
  return ret;

}
}
}}

/* Opt : 288
%newvar1:i32 = var ; newvar1
%1:i32 = sub %newvar1, 0:i32
infer %1
result %newvar1

newvar1 - 0
  =>
newvar1
*/
{
llvm::Value *x0 = nullptr;
if (util::filter(F, 288) && match(I, m_Sub(m_Value(x0), m_Zero()))) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(288, 1);
  return ret;

}
}
}
/* Opt : 2873
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = zext %v0
%3:i32 = xor %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = xor %v0, %5
result %6

trunc((C1 ^ zext(v0)))
  =>
v0 ^ trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2873) && match(I, m_Trunc(m_c_Xor(m_Constant(&x3), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateXor(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2873, 2);
  return ret;

}
}
}}

/* Opt : 2424
%symconst_2:i8 = var ; symconst_2
%v0:i8 = var ; v0
%2:i8 = width %v0
%3:i1 = ult %symconst_2, %2
pc %3 1:i1
%4:i8 = and %symconst_2, %v0
%5:i1 = ne 0:i8, %4
%6:i1 = xor 1:i1, %5
%7:i8 = zext %6
infer %7
%8:i8 = sub 1:i8, %symconst_2
%9:i8 = add %symconst_2, %8
%10:i8 = ashr %9, %4
result %10

C2 <u width(v0)
  |= 
let var0 = (v0 & C2);
zext(~(var0 != 0))
  =>
(C2 + (1 - C2)) >>a var0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2424) && match(I, m_ZExt(m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Zero(), &x5 <<= m_c_And(m_Constant(&x2), m_Value(x1))))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x5) && util::dc(DT, I, x2) && util::dc(DT, I, x1) && (ult(util::V(x2), util::W(x1)) == llvm::APInt(1, 1))) {
  auto C0 = C(8, 1, B);
  auto ret = B->CreateAShr(B->CreateAdd(x2, B->CreateSub(C0(x2), x2)), x5);
if (util::check_width(ret, I)) {
  St.hit(2424, 2);
  return ret;

}
}
}}

/* Opt : 1120
%symconst_4:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11000) ; symconst_4
%1:i32 = width %symconst_4
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%v0:i32 = var ; v0
%4:i32 = width %v0
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%symconst_6:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxx11111111) ; symconst_6
%7:i32 = width %symconst_6
%8:i1 = eq 32:i32, %7
pc %8 1:i1
%symconst_2:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx01000) ; symconst_2
%10:i32 = width %symconst_2
%11:i1 = eq 32:i32, %10
pc %11 1:i1
%symconst_3:i32 = var (knownBits=11111111xxxxxxxxxxxxxxxxxxxxxxxx) ; symconst_3
%13:i32 = width %symconst_3
%14:i1 = eq 32:i32, %13
pc %14 1:i1
%15:i32 = and 16711680:i32, %v0
%16:i32 = lshr %15, %symconst_2
%17:i32 = and %v0, %symconst_3
%18:i32 = lshr %17, %symconst_4
%19:i32 = or %16, %18
%20:i32 = and 65280:i32, %v0
%21:i32 = shl %20, %symconst_2
%22:i32 = or %19, %21
%23:i32 = and %v0, %symconst_6
%24:i32 = shl %23, %symconst_4
%25:i32 = or %22, %24
infer %25
%26:i32 = bswap %v0
result %26

width(C4 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx11000)) == 32 && 
width(v0) == 32 && 
width(C6 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxx11111111)) == 32 && 
width(C2 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxx01000)) == 32 && 
width(C3 (knownBits=11111111xxxxxxxxxxxxxxxxxxxxxxxx)) == 32
  |= 
let var3 = (v0 & 0xFF0000);
let var2 = (var3 >>l C2);
let var5 = (v0 & C3);
let var4 = (var5 >>l C4);
let var1 = (var2 | var4);
let var7 = (v0 & 0xFF00);
let var6 = (var7 << C2);
let var0 = (var1 | var6);
let var9 = (v0 & C6);
let var8 = (var9 << C4);
var0 | var8
  =>
bswap(v0)
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr;
if (util::filter(F, 1120) && match(I, m_c_Or(m_c_Or(m_c_Or(m_LShr(m_c_And(m_Value(x4), m_ExtInt("16711680", 32)), m_Constant(&x2)), m_LShr(m_c_And(m_Deferred(x4), m_Constant(&x1)), m_Constant(&x5))), m_Shl(m_c_And(m_ExtInt("65280", 32), m_Deferred(x4)), m_Deferred(x2))), m_Shl(m_c_And(m_Deferred(x4), m_Constant(&x3)), m_Deferred(x5))))) {
if (util::dc(DT, I, x4) && util::k1(x5, "11000", 32) && util::k0(x5, "111", 32) && util::k1(x3, "11111111", 32) && util::k1(x2, "1000", 32) && util::k0(x2, "10111", 32) && util::k1(x1, "11111111000000000000000000000000", 32) && util::check_width(x5,32) && util::check_width(x4,32) && util::check_width(x3,32) && util::check_width(x2,32) && util::check_width(x1,32)) {
  auto ret = B->CreateBSwap(x4);
if (util::check_width(ret, I)) {
  St.hit(1120, 6);
  return ret;

}
}
}}

/* Opt : 1116
%symconst_1:i8 = var ; symconst_1
%symconst_2:i8 = var ; symconst_2
%v0:i8 = var ; v0
%3:i8 = or %symconst_2, %v0
%4:i8 = or %symconst_1, %3
infer %4
%5:i8 = or %symconst_1, %symconst_2
%6:i8 = or %v0, %5
result %6

C1 | (v0 | C2)
  =>
v0 | (C2 | C1)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1116) && match(I, m_c_Or(m_Constant(&x2), m_c_Or(m_Constant(&x1), m_Value(x0))))) {
if (util::dc(DT, I, x0)) {
  auto ret = B->CreateOr(x0, B->CreateOr(x2, x1));
if (util::check_width(ret, I)) {
  St.hit(1116, 1);
  return ret;

}
}
}}

/* Opt : 3607
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i8 = width %v0
%3:i32 = zext %2
%4:i32 = shl 1:i32, %3
%5:i32 = sub %4, 1:i32
%6:i1 = ule %symconst_1, %5
pc %6 1:i1
%7:i32 = zext %v0
%8:i1 = slt %7, %symconst_1
infer %8
%9:i8 = trunc %symconst_1
%10:i1 = ult %v0, %9
result %10

C1 <=u ((1 << zext(width(v0))) - 1)
  |= 
zext(v0) <s C1
  =>
v0 <u trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3607) && match(I, m_ICmp(P0, m_ZExt(m_Value(x2)), m_Constant(&x3)))) {
if (P0 == ICmpInst::ICMP_SLT && util::dc(DT, I, x2) && (ule(util::V(x3), sub(shl(llvm::APInt(32, 1), util::W(x2).zext(64)), llvm::APInt(32, 1))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULT, x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(3607, 1);
  return ret;

}
}
}}

/* Opt : 2483
%v0:i32 = var ; v0
%1:i32 = and 1:i32, %v0
%2:i1 = eq 0:i32, %1
%3:i32 = zext %2
infer %3
%4:i32 = sub 1:i32, %1
result %4

zext(((v0 & 1) == 0))
  =>
1 - (v0 & 1)
*/
{
llvm::Value *x3 = nullptr, *x1 = nullptr, *x2 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2483) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), &x2 <<= m_c_And(&x3 <<= m_ExtInt("1", 32), m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x2) && util::dc(DT, I, x1)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateSub(C0(x2), x2);
if (util::check_width(ret, I)) {
  St.hit(2483, 1);
  return ret;

}
}
}}

/* Opt : 67
%symconst_2:i8 = var ; symconst_2
%v0:i8 = var ; v0
%2:i8 = sdiv %v0, 1:i8
%3:i8 = add %symconst_2, %2
infer %3
%4:i8 = add %symconst_2, %v0
result %4

C2 + (v0 /s 1)
  =>
v0 + C2
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 67) && match(I, m_c_Add(m_Constant(&x1), m_SDiv(m_Value(x0), m_ExtInt("1", 8))))) {
if (util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto ret = B->CreateAdd(x1, x0);
if (util::check_width(ret, I)) {
  St.hit(67, 5);
  return ret;

}
}
}}

/* Opt : 54
%symconst_2:i8 = var ; symconst_2
%symconst_3:i8 = var ; symconst_3
%v0:i8 = var ; v0
%symconst_1:i8 = var ; symconst_1
%4:i8 = add %v0, %symconst_1
%5:i8 = add %symconst_3, %4
%6:i8 = add %symconst_2, %5
infer %6
%7:i8 = add %symconst_2, %symconst_1
%8:i8 = add %symconst_3, %7
%9:i8 = add %v0, %8
result %9

C2 + (C3 + (v0 + C1))
  =>
v0 + (C3 + (C2 + C1))
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 54) && match(I, m_c_Add(m_Constant(&x3), m_c_Add(m_Constant(&x2), m_c_Add(m_Value(x1), m_Constant(&x0)))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateAdd(x1, B->CreateAdd(x2, B->CreateAdd(x3, x0)));
if (util::check_width(ret, I)) {
  St.hit(54, 2);
  return ret;

}
}
}}

/* Opt : 547
%v0:i64 = var ; v0
%1:i64 = sdiv %v0, 1:i64
infer %1
result %v0

v0 /s 1
  =>
v0
*/
{
llvm::Value *x0 = nullptr;
if (util::filter(F, 547) && match(I, m_SDiv(m_Value(x0), m_ExtInt("1", 64)))) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(547, 5);
  return ret;

}
}
}
/* Opt : 3965
%symconst_7:i32 = var ; symconst_7
%symDF_DB:i32 = var ; symDF_DB
%symconst_8:i32 = var ; symconst_8
%3:i32 = lshr %symDF_DB, %symconst_8
%4:i1 = eq %symconst_7, %3
pc %4 1:i1
%newvar0:i32 = var ; newvar0
%6:i32 = and %symconst_7, %newvar0
%7:i32 = shl %6, %symconst_8
%8:i32 = demandedmask %7, %symDF_DB
infer %8
%9:i32 = shl 1:i32, %symconst_8
%10:i32 = mul %newvar0, %9
%11:i32 = demandedmask %10, %symDF_DB
result %11

C7 == (@db >>l C8)
  |=
(C7 & newvar0) << C8
  =>
newvar0 * (1 << C8)
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
if (util::filter(F, 3965) && match(I, m_Shl(m_c_And(m_Constant(&x3), m_Value(x4)), m_Constant(&x1)))) {
if (util::symdb(DB, I, x2, B) && util::dc(DT, I, x2) && (eq(util::V(x3), util::V(x2).lshr(util::V(x1))) == llvm::APInt(1, 1))) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateMul(x4, B->CreateShl(C0(x1), x1));
if (util::check_width(ret, I)) {
  St.hit(3965, 1);
  return ret;

}
}
}}

/* Opt : 2889
%v0:i8 = var ; v0
%1:i32 = zext %v0
%symconst_1:i32 = var ; symconst_1
%3:i32 = shl %1, %symconst_1
%4:i8 = trunc %3
infer %4
%5:i32 = shl 1:i32, %symconst_1
%6:i8 = trunc %5
%7:i8 = mul %v0, %6
result %7

trunc((zext(v0) << C1))
  =>
v0 * trunc((1 << C1))
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2889) && match(I, m_Trunc(m_Shl(m_ZExt(m_Value(x3)), m_Constant(&x1))))) {
if (util::dc(DT, I, x3)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateMul(x3, B->CreateTrunc(B->CreateShl(C0(x1), x1), T(x3)));
if (util::check_width(ret, I)) {
  St.hit(2889, 2);
  return ret;

}
}
}}

/* Opt : 2778
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = sext %v0
%3:i32 = or %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = or %v0, %5
result %6

trunc((C1 | sext(v0)))
  =>
v0 | trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2778) && match(I, m_Trunc(m_c_Or(m_Constant(&x3), m_SExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateOr(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2778, 2);
  return ret;

}
}
}}

/* Opt : 2744
%newvar1:i1 = var ; newvar1
%1:i32 = zext %newvar1
%2:i8 = trunc %1
infer %2
%3:i8 = zext %newvar1
result %3

trunc(zext(newvar1))
  =>
zext(newvar1)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2744) && match(I, m_Trunc(m_ZExt(m_Value(x2))))) {
if (util::check_width(x2,1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateZExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2744, 1);
  return ret;

}
}
}}

/* Opt : 3998
%symconst_1:i8 = var ; symconst_1
%symDF_K1:i8 = var ; symDF_K1
%2:i1 = knownones %symconst_1, %symDF_K1
pc %2 1:i1
%symDF_DB:i32 = var ; symDF_DB
%4:i32 = zext %symDF_K1
%5:i1 = eq %symDF_DB, %4
pc %5 1:i1
%newvar0:i8 = var ; newvar0
%7:i8 = and %symconst_1, %newvar0
%8:i32 = zext %7
%9:i8 = trunc %8
%10:i32 = zext %9
%11:i32 = demandedmask %10, %symDF_DB
infer %11
%12:i32 = sext %newvar0
%13:i32 = demandedmask %12, %symDF_DB
result %13

@db == zext(symconst_1.k1)
  |= 
let var3 = (C1 & newvar0);
let var2 = zext(var3);
let var1 = trunc(var2);
let var0 = zext(var1);
var0
  =>
let var4 = sext(newvar0);
var4
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x2 = nullptr, *x4 = nullptr, *x3 = nullptr, *x1 = nullptr, *x9 = nullptr, *x8 = nullptr, *x7 = nullptr, *x6 = nullptr;
if (util::filter(F, 3998) && match(I, m_ZExt(m_Trunc(m_ZExt(m_c_And(m_Constant(&x5), m_Value(x9))))))) {
if (util::symk1bind(x5, x2, B) && util::symdb(DB, I, x3, B) && util::dc(DT, I, x3) && (eq(util::V(x3), util::V(x2).zext(64)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateSExt(x9, T(I));
if (util::check_width(ret, I)) {
  St.hit(3998, 3);
  return ret;

}
}
}}

/* Opt : 3449
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%newvar24:i1 = var ; newvar24
%3:i32 = zext %newvar24
%4:i32 = or %1, %3
%5:i1 = ne 0:i32, %4
infer %5
%6:i1 = or %newvar0, %newvar24
result %6

(zext(newvar0) | zext(newvar24)) != 0
  =>
newvar24 | newvar0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3449) && match(I, m_c_ICmp(P0, m_Zero(), m_c_Or(m_ZExt(m_Value(x3)), m_ZExt(m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x3,1) && util::check_width(x1,1) && util::dc(DT, I, x3) && util::dc(DT, I, x1)) {
  auto ret = B->CreateOr(x3, x1);
if (util::check_width(ret, I)) {
  St.hit(3449, 3);
  return ret;

}
}
}}

/* Opt : 3385
%symconst_1:i8 = var ; symconst_1
%symconst_2:i8 = var ; symconst_2
%2:i1 = ne %symconst_1, %symconst_2
pc %2 1:i1
%v0:i1 = var ; v0
%4:i8 = select %v0, %symconst_1, %symconst_2
%5:i1 = ne %symconst_1, %4
infer %5
%6:i1 = xor 1:i1, %v0
result %6

C2 != C1
  |= 
C1 != (select v0 C1 C2)
  =>
~v0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3385) && match(I, m_c_ICmp(P0, m_Constant(&x2), m_Select(m_Value(x3), m_Deferred(x2), m_Constant(&x1))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x3,1) && util::dc(DT, I, x3) && (ne(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto C0 = C(1, -1, B);
  auto ret = B->CreateXor(C0(x3), x3);
if (util::check_width(ret, I)) {
  St.hit(3385, 3);
  return ret;

}
}
}}

/* Opt : 2824
%v0:i8 = var ; v0
%1:i32 = zext %v0
%2:i16 = trunc %1
infer %2
%3:i16 = zext %v0
result %3

trunc(zext(v0))
  =>
zext(v0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2824) && match(I, m_Trunc(m_ZExt(m_Value(x2))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateZExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2824, 1);
  return ret;

}
}
}}

/* Opt : 561
%newvar0:i32 = var (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) ; newvar0
%symconst_1:i32 = var (powerOfTwo) ; symconst_1
%2:i32 = sdiv %newvar0, %symconst_1
infer %2
%3:i32 = logb %symconst_1
%4:i32 = ashr %newvar0, %3
result %4

newvar0 (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) /s C1 (powerOfTwo)
  =>
newvar0 >>a logb(C1)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 561) && match(I, m_SDiv(m_Value(x1), m_Constant(&x0)))) {
if (util::pow2(x0) && util::dc(DT, I, x1) && util::k0(x1, "10000000000000000000000000000000", 32)) {
  auto ret = B->CreateAShr(x1, B->CreateLogB(x0));
if (util::check_width(ret, I)) {
  St.hit(561, 4);
  return ret;

}
}
}}

/* Opt : 540
%symconst_1:i32 = var (powerOfTwo) ; symconst_1
%1:i32 = width %symconst_1
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%v0:i8 = var ; v0
%4:i8 = width %v0
%5:i1 = eq 8:i8, %4
pc %5 1:i1
%6:i32 = zext %v0
%7:i32 = width %6
%8:i1 = eq 32:i32, %7
pc %8 1:i1
%9:i32 = sdiv %6, %symconst_1
infer %9
%10:i32 = logb %symconst_1
%11:i32 = ashr %6, %10
result %11

width(C1 (powerOfTwo)) == 32 && 
width(v0) == 8 && 
let var0 = zext(v0);
width(var0) == 32
  |= 
var0 /s C1
  =>
let var1 = logb(C1);
var0 >>a var1
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr;
if (util::filter(F, 540) && match(I, m_SDiv(&x1 <<= m_ZExt(m_Value(x2)), m_Constant(&x3)))) {
if (util::pow2(x3) && util::dc(DT, I, x1) && util::dc(DT, I, x2) && util::check_width(x3,32) && util::check_width(x2,8) && util::check_width(x1,32)) {
  auto ret = B->CreateAShr(x1, B->CreateLogB(x3));
if (util::check_width(ret, I)) {
  St.hit(540, 4);
  return ret;

}
}
}}

/* Opt : 3957
%symconst_1:i32 = var ; symconst_1
%symDF_K1:i32 = var ; symDF_K1
%2:i1 = knownones %symconst_1, %symDF_K1
pc %2 1:i1
%symDF_DB:i64 = var ; symDF_DB
%4:i64 = zext %symDF_K1
%5:i1 = eq %symDF_DB, %4
pc %5 1:i1
%newvar0:i32 = var ; newvar0
%7:i32 = and %symconst_1, %newvar0
%8:i64 = zext %7
%9:i64 = demandedmask %8, %symDF_DB
infer %9
%10:i64 = sext %newvar0
%11:i64 = demandedmask %10, %symDF_DB
result %11

@db == zext(symconst_1.k1)
  |=
let var1 = (C1 & newvar0);
let var0 = zext(var1);
var0
  =>
let var2 = sext(newvar0);
var2
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x2 = nullptr, *x4 = nullptr, *x3 = nullptr, *x1 = nullptr, *x7 = nullptr, *x6 = nullptr;
if (util::filter(F, 3957) && match(I, m_ZExt(m_c_And(m_Constant(&x5), m_Value(x7))))) {
if (util::symk1bind(x5, x2, B) && util::symdb(DB, I, x3, B) && util::dc(DT, I, x3) && (eq(util::V(x3), util::V(x2).zext(64)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateSExt(x7, T(I));
if (util::check_width(ret, I)) {
  St.hit(3957, 1);
  return ret;

}
}
}}

/* Opt : 3697
%v0:i32 = var ; v0
%v1:i32 = var ; v1
%2:i32 = subnsw %v0, %v1
%3:i1 = slt %2, 0:i32
infer %3
%4:i1 = slt %v0, %v1
result %4

(v0 -nsw v1) <s 0
  =>
v0 <s v1
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3697) && match(I, m_ICmp(P0, m_NSWSub(m_Value(x1), m_Value(x0)), m_Zero()))) {
if (P0 == ICmpInst::ICMP_SLT && util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_SLT, x1, x0);
if (util::check_width(ret, I)) {
  St.hit(3697, 1);
  return ret;

}
}
}}

/* Opt : 3275
%newvar2:i1 = var ; newvar2
%1:i32 = zext %newvar2
%newvar1:i1 = var ; newvar1
%3:i1 = xor 1:i1, %newvar1
%4:i32 = zext %3
%5:i32 = or %1, %4
%6:i1 = ne 0:i32, %5
infer %6
%7:i1 = ule %newvar1, %newvar2
result %7

(zext(newvar2) | zext(~newvar1)) != 0
  =>
newvar1 <=u newvar2
*/
{
llvm::Value *x3 = nullptr, *x5 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3275) && match(I, m_c_ICmp(P0, m_Zero(), m_c_Or(m_ZExt(m_Value(x5)), m_ZExt(m_c_Xor(m_AllOnes(), m_Value(x2))))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x5,1) && util::check_width(x2,1) && util::dc(DT, I, x2) && util::dc(DT, I, x5)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULE, x2, x5);
if (util::check_width(ret, I)) {
  St.hit(3275, 4);
  return ret;

}
}
}}

/* Opt : 2801
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = sext %v0
%3:i32 = and %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = and %v0, %5
result %6

trunc((C1 & sext(v0)))
  =>
v0 & trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2801) && match(I, m_Trunc(m_c_And(m_Constant(&x3), m_SExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateAnd(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2801, 2);
  return ret;

}
}
}}

/* Opt : 2721
%v0:i4 = var ; v0
%symconst_1:i4 = var ; symconst_1
%2:i4 = add %v0, %symconst_1
%3:i4 = subnsw %2, %symconst_1
%4:i8 = sext %3
infer %4
%5:i8 = sext %v0
result %5

sext(((v0 + C1) -nsw C1))
  =>
sext(v0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2721) && match(I, m_SExt(m_NSWSub(m_c_Add(m_Value(x2), m_Constant(&x1)), m_Deferred(x1))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateSExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2721, 2);
  return ret;

}
}
}}

/* Opt : 2703
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%2:i32 = sub 0:i32, %1
%3:i64 = sext %2
infer %3
%4:i64 = sext %newvar0
result %4

sext((0 - zext(newvar0)))
  =>
sext(newvar0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2703) && match(I, m_SExt(m_Sub(m_Zero(), m_ZExt(m_Value(x2)))))) {
if (util::check_width(x2,1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateSExt(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2703, 2);
  return ret;

}
}
}}

/* Opt : 250
%v0:i8 = var ; v0
%symconst_2:i8 = var ; symconst_2
%2:i8 = sub %v0, %symconst_2
%3:i8 = sub 0:i8, %2
infer %3
%4:i8 = sub %symconst_2, %v0
result %4

0 - (v0 - C2)
  =>
C2 - v0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 250) && match(I, m_Sub(m_Zero(), m_Sub(m_Value(x1), m_Constant(&x0))))) {
if (util::dc(DT, I, x0) && util::dc(DT, I, x1)) {
  auto ret = B->CreateSub(x0, x1);
if (util::check_width(ret, I)) {
  St.hit(250, 1);
  return ret;

}
}
}}

/* Opt : 1204
%newvar0:i64 = var ; newvar0
%v4:i64 = var ; v4
%2:i1 = ult %newvar0, %v4
%3:i1 = xor 1:i1, %2
infer %3
%4:i1 = ule %v4, %newvar0
result %4

~(newvar0 <u v4)
  =>
v4 <=u newvar0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1204) && match(I, m_c_Xor(m_AllOnes(), m_ICmp(P0, m_Value(x2), m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_ULT && util::dc(DT, I, x1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULE, x1, x2);
if (util::check_width(ret, I)) {
  St.hit(1204, 1);
  return ret;

}
}
}}

/* Opt : 389
%symconst_1:i8 = var ; symconst_1
%newvar1:i8 = var ; newvar1
%2:i8 = sdivexact %newvar1, %symconst_1
%3:i8 = mul %symconst_1, %2
infer %3
%4:i8 = freeze %newvar1
result %4

C1 * (newvar1 sdivexact C1)
  =>
freeze(newvar1)
*/
{
llvm::Value *x0 = nullptr, *x1 = nullptr;
if (util::filter(F, 389) && match(I, m_c_Mul(m_Constant(&x0), m_SDivExact(m_Value(x1), m_Deferred(x0))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateFreeze(x1);
if (util::check_width(ret, I)) {
  St.hit(389, 1);
  return ret;

}
}
}}

/* Opt : 3503
%symconst_1:i32 = var ; symconst_1
%1:i1 = ult 0:i32, %symconst_1
%v0:i8 = var ; v0
%3:i8 = width %v0
%4:i32 = zext %3
%5:i1 = ule %symconst_1, %4
%6:i1 = and %1, %5
pc %6 1:i1
%7:i32 = zext %v0
%8:i1 = ult %7, %symconst_1
infer %8
%9:i8 = trunc %symconst_1
%10:i1 = ult %v0, %9
result %10

(0 <u C1) & (C1 <=u zext(width(v0)))
  |= 
zext(v0) <u C1
  =>
v0 <u trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3503) && match(I, m_ICmp(P0, m_ZExt(m_Value(x3)), m_Constant(&x4)))) {
if (P0 == ICmpInst::ICMP_ULT && util::dc(DT, I, x3) && ((ult(llvm::APInt(32, 0), util::V(x4)) & ule(util::V(x4), util::W(x3).zext(64))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULT, x3, B->CreateTrunc(x4, T(x3)));
if (util::check_width(ret, I)) {
  St.hit(3503, 1);
  return ret;

}
}
}}

/* Opt : 2456
%v0:i1 = var ; v0
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%3:i32 = select %v0, %symconst_1, %symconst_2
%4:i64 = zext %3
infer %4
%5:i64 = zext %symconst_1
%6:i64 = zext %symconst_2
%7:i64 = select %v0, %5, %6
result %7

zext((select v0 C1 C2))
  =>
select v0 zext(C1) zext(C2)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2456) && match(I, m_ZExt(m_Select(m_Value(x3), m_Constant(&x2), m_Constant(&x1))))) {
if (util::check_width(x3,1) && util::dc(DT, I, x3)) {
  auto ret = B->CreateSelect(x3, B->CreateZExt(x2, T(64, B)), B->CreateZExt(x1, T(64, B)));
if (util::check_width(ret, I)) {
  St.hit(2456, 1);
  return ret;

}
}
}}

/* Opt : 1150
%symconst_3:i32 = var ; symconst_3
%newvar1:i1 = var ; newvar1
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%4:i32 = select %newvar1, %symconst_1, %symconst_2
%5:i32 = or %symconst_3, %4
infer %5
%6:i32 = or %symconst_3, %symconst_1
%7:i32 = or %symconst_3, %symconst_2
%8:i32 = select %newvar1, %6, %7
result %8

C3 | (select newvar1 C1 C2)
  =>
select newvar1 (C3 | C1) (C3 | C2)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1150) && match(I, m_c_Or(m_Constant(&x3), m_Select(m_Value(x2), m_Constant(&x1), m_Constant(&x0))))) {
if (util::check_width(x2,1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateSelect(x2, B->CreateOr(x3, x1), B->CreateOr(x3, x0));
if (util::check_width(ret, I)) {
  St.hit(1150, 1);
  return ret;

}
}
}}

/* Opt : 862
%symconst_3:i16 = var ; symconst_3
%newvar0:i1 = var ; newvar0
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%4:i32 = select %newvar0, %symconst_1, %symconst_2
%5:i16 = trunc %4
%6:i16 = and %symconst_3, %5
infer %6
%7:i32 = select 1:i1, %symconst_1, %symconst_2
%8:i16 = trunc %7
%9:i16 = and %symconst_3, %8
%10:i32 = select 0:i1, %symconst_1, %symconst_2
%11:i16 = trunc %10
%12:i16 = and %symconst_3, %11
%13:i16 = select %newvar0, %9, %12
result %13

C3 & trunc((select newvar0 C1 C2))
  =>
select newvar0 (C3 & trunc((select 1 C1 C2))) (C3 & trunc((select 0 C1 C2)))
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 862) && match(I, m_c_And(m_Constant(&x4), m_Trunc(m_Select(m_Value(x3), m_Constant(&x2), m_Constant(&x1)))))) {
if (util::check_width(x3,1) && util::dc(DT, I, x3)) {
  auto C0 = C(1, -1, B);
  auto C1 = C(1, 0, B);
  auto ret = B->CreateSelect(x3, B->CreateAnd(x4, B->CreateTrunc(B->CreateSelect(C0(), x2, x1), T(x4))), B->CreateAnd(x4, B->CreateTrunc(B->CreateSelect(C1(), x2, x1), T(x4))));
if (util::check_width(ret, I)) {
  St.hit(862, 2);
  return ret;

}
}
}}

/* Opt : 57
%newvar0:i32 = var ; newvar0
%v10:i32 = var ; v10
%2:i32 = sub %v10, %newvar0
%3:i32 = add %newvar0, %2
infer %3
result %v10

newvar0 + (v10 - newvar0)
  =>
v10
*/
{
llvm::Value *x0 = nullptr, *x1 = nullptr;
if (util::filter(F, 57) && match(I, m_c_Add(m_Value(x0), m_Sub(m_Value(x1), m_Deferred(x0))))) {
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(57, 2);
  return ret;

}
}
}

/* Opt : 3936
%newvar0:i32 = var ; newvar0
%symDF_K0:i32 = var ; symDF_K0
%2:i1 = knownzeros %newvar0, %symDF_K0
pc %2 1:i1
%symconst_1:i32 = var ; symconst_1
%symDF_K1:i32 = var ; symDF_K1
%5:i1 = knownones %symconst_1, %symDF_K1
pc %5 1:i1
%6:i32 = or %symDF_K0, %symDF_K1
%symDF_DB:i32 = var ; symDF_DB
%8:i32 = xor 4294967295:i32, %symDF_DB
%9:i32 = or %6, %8
%10:i1 = eq 4294967295:i32, %9
pc %10 1:i1
%11:i32 = or %newvar0, %symconst_1
%12:i32 = demandedmask %11, %symDF_DB
infer %12
%13:i32 = demandedmask %symconst_1, %symDF_DB
result %13

((symconst_1.k1 | newvar0.k0) | ~@db) == 0xFFFFFFFF
  |= 
let var0 = C1 | newvar0;
var0
  =>
C1
*/
{
llvm::Value *x0 = nullptr, *x7 = nullptr, *x3 = nullptr, *x6 = nullptr, *x5 = nullptr, *x2 = nullptr, *x4 = nullptr, *x1 = nullptr;
if (util::filter(F, 3936) && match(I, m_c_Or(m_Value(x7), m_Constant(&x5)))) {
if (util::symk1bind(x5, x2, B) && util::symk0bind(x7, x3, B) && util::symdb(DB, I, x1, B) && util::dc(DT, I, x5) && util::dc(DT, I, x1) && (eq(llvm::APInt(32, 4294967295), or_(or_(util::V(x3), util::V(x2)), flip(util::V(x1)))) == llvm::APInt(1, 1))) {
  auto ret = x5;
if (util::check_width(ret, I)) {
  St.hit(3936, 2);
  return ret;

}
}
}}

/* Opt : 3891
%v3:i16 = var ; v3
%1:i32 = zext %v3 (hasExternalUses)
%v6:i16 = var ; v6
%3:i32 = zext %v6
%4:i1 = sle %1, %3
infer %4
%5:i1 = ule %v3, %v6
result %5

zext(v3) <=s zext(v6)
  =>
v3 <=u v6
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3891) && match(I, m_ICmp(P0, m_ZExt(m_Value(x3)), m_ZExt(m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_SLE && util::dc(DT, I, x3) && util::dc(DT, I, x1)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULE, x3, x1);
if (util::check_width(ret, I)) {
  St.hit(3891, 2);
  return ret;

}
}
}}

/* Opt : 3407
%symconst_2:i32 = var ; symconst_2
%symconst_1:i32 = var ; symconst_1
%2:i1 = ult %symconst_2, %symconst_1
pc %2 1:i1
%newvar1:i1 = var ; newvar1
%4:i32 = select %newvar1, %symconst_1, %symconst_2
%newvar4:i1 = var ; newvar4
%6:i32 = select %newvar4, %symconst_1, %symconst_2
%7:i1 = ne %4, %6
infer %7
%8:i1 = xor %newvar1, %newvar4
result %8

C2 <u C1
  |= 
(select newvar1 C1 C2) != (select newvar4 C1 C2)
  =>
newvar4 ^ newvar1
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3407) && match(I, m_c_ICmp(P0, m_Select(m_Value(x4), m_Constant(&x1), m_Constant(&x2)), m_Select(m_Value(x3), m_Deferred(x1), m_Deferred(x2))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x4,1) && util::check_width(x3,1) && util::dc(DT, I, x4) && util::dc(DT, I, x3) && (ult(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateXor(x4, x3);
if (util::check_width(ret, I)) {
  St.hit(3407, 6);
  return ret;

}
}
}}

/* Opt : 3045
%newvar1:i1 = var ; newvar1
%1:i32 = zext %newvar1
%newvar0:i1 = var ; newvar0
%3:i1 = xor 1:i1, %newvar0
%4:i32 = zext %3
%5:i1 = eq %1, %4
infer %5
%6:i1 = xor %newvar1, %newvar0
result %6

zext(newvar1) == zext(~newvar0)
  =>
newvar1 ^ newvar0
*/
{
llvm::Value *x3 = nullptr, *x5 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3045) && match(I, m_c_ICmp(P0, m_ZExt(m_Value(x5)), m_ZExt(m_c_Xor(m_AllOnes(), m_Value(x2)))))) {
if (P0 == ICmpInst::ICMP_EQ && util::check_width(x5,1) && util::check_width(x2,1) && util::dc(DT, I, x5) && util::dc(DT, I, x2)) {
  auto ret = B->CreateXor(x5, x2);
if (util::check_width(ret, I)) {
  St.hit(3045, 3);
  return ret;

}
}
}}

/* Opt : 2846
%symconst_3:i32 = var ; symconst_3
%newvar1:i1 = var ; newvar1
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%4:i32 = select %newvar1, %symconst_1, %symconst_2
%5:i32 = xor %symconst_3, %4
%6:i8 = trunc %5
infer %6
%7:i32 = xor %symconst_3, %symconst_1
%8:i8 = trunc %7
%9:i32 = xor %symconst_3, %symconst_2
%10:i8 = trunc %9
%11:i8 = select %newvar1, %8, %10
result %11

trunc((C3 ^ (select newvar1 C1 C2)))
  =>
select newvar1 trunc((C3 ^ C1)) trunc((C3 ^ C2))
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2846) && match(I, m_Trunc(m_c_Xor(m_Constant(&x4), m_Select(m_Value(x3), m_Constant(&x2), m_Constant(&x1)))))) {
if (util::check_width(x3,1) && util::dc(DT, I, x3)) {
  auto ret = B->CreateSelect(x3, B->CreateTrunc(B->CreateXor(x4, x2), T(8, B)), B->CreateTrunc(B->CreateXor(x4, x1), T(8, B)));
if (util::check_width(ret, I)) {
  St.hit(2846, 2);
  return ret;

}
}
}}

/* Opt : 2593
%newvar6:i32 = var ; newvar6
%1:i32 = and 1:i32, %newvar6
%2:i1 = ne 0:i32, %1
%3:i32 = select %2, 1:i32, 0:i32
%4:i8 = trunc %3
%5:i32 = zext %4
infer %5
result %1

zext(trunc((select ((newvar6 & 1) != 0) 1 0)))
  =>
newvar6 & 1
*/
{
llvm::Value *x4 = nullptr, *x2 = nullptr, *x3 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2593) && match(I, m_ZExt(m_Trunc(m_Select(m_c_ICmp(P0, m_Zero(), &x3 <<= m_c_And(&x4 <<= m_ExtInt("1", 32), m_Value(x2))), &x4 <<= m_ExtInt("1", 32), m_Zero()))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2)) {
  auto C0 = C(32, 1, B);
  auto ret = x3;
if (util::check_width(ret, I)) {
  St.hit(2593, 6);
  return ret;

}
}
}}

/* Opt : 252
%newvar1:i8 = var ; newvar1
%symconst_2:i8 = var ; symconst_2
%2:i8 = add %newvar1, %symconst_2
%3:i8 = sub 0:i8, %2
infer %3
%4:i8 = sub 0:i8, %symconst_2
%5:i8 = sub %4, %newvar1
result %5

0 - (C2 + newvar1)
  =>
(0 - C2) - newvar1
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 252) && match(I, m_Sub(&x2 <<= m_Zero(), m_c_Add(m_Value(x1), m_Constant(&x0))))) {
if (util::dc(DT, I, x1)) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateSub(B->CreateSub(C0(x0), x0), x1);
if (util::check_width(ret, I)) {
  St.hit(252, 1);
  return ret;

}
}
}}

/* Opt : 1818
%newvar0:i1 = var ; newvar0
%1:i8 = zext %newvar0
%2:i1 = ne 0:i8, %1
%newvar5:i8 = var ; newvar5
%4:i8 = select %2, %newvar5, 0:i8
infer %4
%5:i8 = select %newvar0, %newvar5, 0:i8
result %5

select (zext(newvar0) != 0) newvar5 0
  =>
select newvar0 newvar5 0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1818) && match(I, m_Select(m_c_ICmp(P0, &x3 <<= m_Zero(), m_ZExt(m_Value(x2))), m_Value(x0), &x3 <<= m_Zero()))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x2,1) && util::dc(DT, I, x2) && util::dc(DT, I, x0)) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateSelect(x2, x0, C0(x0));
if (util::check_width(ret, I)) {
  St.hit(1818, 2);
  return ret;

}
}
}}

/* Opt : 1304
%symconst_1:i8 = var ; symconst_1
%symconst_3:i8 = var ; symconst_3
%v0:i8 = var ; v0
%symconst_2:i8 = var ; symconst_2
%4:i8 = lshr %v0, %symconst_2
%5:i8 = and %symconst_3, %4
%6:i8 = and %symconst_1, %5
%7:i8 = shl %6, %symconst_2
infer %7
%8:i8 = and %symconst_1, %symconst_3
%9:i8 = shl %8, %symconst_2
%10:i8 = and %v0, %9
result %10

(C1 & (C3 & (v0 >>l C2))) << C2
  =>
v0 & ((C3 & C1) << C2)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1304) && match(I, m_Shl(m_c_And(m_Constant(&x3), m_c_And(m_Constant(&x2), m_LShr(m_Value(x1), m_Constant(&x0)))), m_Deferred(x0)))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateAnd(x1, B->CreateShl(B->CreateAnd(x3, x2), x0));
if (util::check_width(ret, I)) {
  St.hit(1304, 3);
  return ret;

}
}
}}

/* Opt : 1248
%v0:i64 = var ; v0
%1:i64 = sub %v0, 1:i64 (hasExternalUses)
%2:i64 = and 1:i64, %1
%3:i1 = ne 0:i64, %2
%4:i1 = xor 1:i1, %3
infer %4
%5:i1 = trunc %v0
result %5

~(((v0 - 1) & 1) != 0)
  =>
trunc(v0)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1248) && match(I, m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Zero(), m_c_And(m_ExtInt("1", 64), m_Sub(m_Value(x1), m_ExtInt("1", 64))))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x1)) {
  auto ret = B->CreateTrunc(x1, T(I));
if (util::check_width(ret, I)) {
  St.hit(1248, 3);
  return ret;

}
}
}}

/* Opt : 1230
%symconst_1:i8 = var ; symconst_1
%newvar1:i4 = var ; newvar1
%2:i4 = width %newvar1
%3:i8 = zext %2
%4:i8 = shl 1:i8, %3
%5:i8 = sub %4, 1:i8
%6:i1 = ule %symconst_1, %5
pc %6 1:i1
%7:i8 = zext %newvar1
%8:i1 = ne %symconst_1, %7
%9:i1 = xor 1:i1, %8
infer %9
%10:i4 = trunc %symconst_1
%11:i1 = eq %newvar1, %10
result %11

C1 <=u ((1 << zext(width(newvar1))) - 1)
  |= 
~(C1 != zext(newvar1))
  =>
newvar1 == trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr, *x4 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1230) && match(I, m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Constant(&x3), m_ZExt(m_Value(x2)))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && (ule(util::V(x3), sub(shl(llvm::APInt(8, 1), util::W(x2).zext(64)), llvm::APInt(8, 1))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(1230, 2);
  return ret;

}
}
}}

/* Opt : 1160
%v1:i8 = var ; v1
%symconst_3:i8 = var ; symconst_3
%2:i8 = and %v1, %symconst_3
%symconst_2:i8 = var (powerOfTwo) ; symconst_2
%4:i8 = and %v1, %symconst_2
%5:i1 = ne 0:i8, %4
%6:i8 = select %5, %symconst_2, 0:i8
%7:i8 = or %2, %6
infer %7
%8:i8 = or %symconst_3, %symconst_2
%9:i8 = and %v1, %8
result %9

(v1 & C3) | (select ((v1 & C2 (powerOfTwo)) != 0) C2 0)
  =>
v1 & (C3 | C2)
*/
{
llvm::Value *x1 = nullptr, *x2 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1160) && match(I, m_c_Or(m_c_And(m_Value(x1), m_Constant(&x2)), m_Select(m_c_ICmp(P0, m_Zero(), m_c_And(m_Deferred(x1), m_Constant(&x0))), m_Deferred(x0), m_Zero())))) {
if (P0 == ICmpInst::ICMP_NE && util::pow2(x0) && util::dc(DT, I, x1)) {
  auto ret = B->CreateAnd(x1, B->CreateOr(x2, x0));
if (util::check_width(ret, I)) {
  St.hit(1160, 6);
  return ret;

}
}
}}

/* Opt : 3212
%v0:i32 = var ; v0
%1:i32 = urem %v0, 2:i32
%2:i1 = ne 0:i32, %1
infer %2
%3:i1 = trunc %v0
result %3

(v0 %u 2) != 0
  =>
trunc(v0)
*/
{
llvm::Value *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3212) && match(I, m_c_ICmp(P0, m_Zero(), m_URem(m_Value(x0), m_ExtInt("2", 32))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x0)) {
  auto ret = B->CreateTrunc(x0, T(I));
if (util::check_width(ret, I)) {
  St.hit(3212, 5);
  return ret;

}
}
}}

/* Opt : 2414
%newvar2:i1 = var ; newvar2
%1:i32 = zext %newvar2
%newvar7:i1 = var ; newvar7
%3:i32 = zext %newvar7
%4:i32 = or %1, %3
%5:i1 = ne 0:i32, %4
%6:i8 = zext %5
infer %6
%7:i8 = trunc %4
result %7

zext(((zext(newvar2) | zext(newvar7)) != 0))
  =>
trunc((zext(newvar2) | zext(newvar7)))
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2414) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), &x5 <<= m_c_Or(&x3 <<= m_ZExt(m_Value(x4)), &x1 <<= m_ZExt(m_Value(x2))))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x4,1) && util::check_width(x2,1) && util::dc(DT, I, x5) && util::dc(DT, I, x3) && util::dc(DT, I, x4) && util::dc(DT, I, x1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateTrunc(x5, T(I));
if (util::check_width(ret, I)) {
  St.hit(2414, 1);
  return ret;

}
}
}}

/* Opt : 1243
%symconst_1:i16 = var ; symconst_1
%symconst_2:i16 = var ; symconst_2
%2:i1 = ne %symconst_1, %symconst_2
pc %2 1:i1
%newvar0:i1 = var ; newvar0
%4:i16 = select %newvar0, %symconst_1, %symconst_2
%5:i1 = ne %symconst_1, %4
%6:i1 = xor 1:i1, %5
infer %6
result %newvar0

C2 != C1
  |= 
~(C1 != (select newvar0 C1 C2))
  =>
newvar0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1243) && match(I, m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Constant(&x2), m_Select(m_Value(x4), m_Deferred(x2), m_Constant(&x1)))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x4,1) && (ne(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = x4;
if (util::check_width(ret, I)) {
  St.hit(1243, 5);
  return ret;

}
}
}}

/* Opt : 843
%symconst_4:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx111111) ; symconst_4
%1:i32 = width %symconst_4
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%newvar4:i32 = var ; newvar4
%4:i32 = width %newvar4
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%symconst_2:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxx1111) ; symconst_2
%7:i32 = width %symconst_2
%8:i1 = eq 32:i32, %7
pc %8 1:i1
%symconst_1:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx1xx) ; symconst_1
%10:i32 = width %symconst_1
%11:i1 = eq 32:i32, %10
pc %11 1:i1
%v0:i8 = var ; v0
%13:i8 = width %v0
%14:i1 = eq 8:i8, %13
pc %14 1:i1
%15:i32 = zext %v0
%16:i32 = width %15
%17:i1 = eq 32:i32, %16
pc %17 1:i1
%18:i32 = and 48:i32, %newvar4
%19:i32 = ashr %15, %symconst_1
%20:i32 = and %symconst_2, %19
%21:i32 = or %18, %20
%22:i32 = and %symconst_4, %21
infer %22
%23:i32 = add %18, %19
result %23

width(C4 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx111111)) == 32 && 
width(newvar4) == 32 && 
width(C2 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxx1111)) == 32 && 
width(C1 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx1xx)) == 32 && 
width(v0) == 8 && 
let var0 = zext(v0);
width(var0) == 32
  |= 
let var2 = (newvar4 & 48);
let var4 = (var0 >>a C1);
let var3 = (C2 & var4);
let var1 = (var2 | var3);
C4 & var1
  =>
var2 + var4
*/
{
llvm::Value *x0 = nullptr, *x9 = nullptr, *x6 = nullptr, *x5 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x8 = nullptr, *x7 = nullptr;
if (util::filter(F, 843) && match(I, m_c_And(m_Constant(&x6), m_c_Or(&x8 <<= m_c_And(&x9 <<= m_ExtInt("48", 32), m_Value(x5)), m_c_And(m_Constant(&x4), &x7 <<= m_AShr(&x1 <<= m_ZExt(m_Value(x2)), m_Constant(&x3))))))) {
if (util::dc(DT, I, x8) && util::dc(DT, I, x5) && util::dc(DT, I, x7) && util::dc(DT, I, x1) && util::dc(DT, I, x2) && util::dc(DT, I, x3) && util::k1(x6, "111111", 32) && util::k1(x4, "1111", 32) && util::k1(x3, "100", 32) && util::check_width(x6,32) && util::check_width(x5,32) && util::check_width(x4,32) && util::check_width(x3,32) && util::check_width(x2,8) && util::check_width(x1,32)) {
  auto C0 = C(32, 48, B);
  auto ret = B->CreateAdd(x8, x7);
if (util::check_width(ret, I)) {
  St.hit(843, 2);
  return ret;

}
}
}}

/* Opt : 765
%symconst_5:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx000000) ; symconst_5
%1:i32 = width %symconst_5
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%newvar0:i32 = var ; newvar0
%4:i32 = width %newvar0
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%symconst_4:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx11xxxx) ; symconst_4
%7:i32 = width %symconst_4
%8:i1 = eq 32:i32, %7
pc %8 1:i1
%9:i32 = and %newvar0, %symconst_4
%10:i32 = add %symconst_5, %9
%11:i32 = and 48:i32, %10
infer %11
%12:i32 = and 48:i32, %newvar0
result %12

width(C5 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx000000)) == 32 && 
width(newvar0) == 32 && 
width(C4 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx11xxxx)) == 32
  |= 
let var1 = (C4 & newvar0);
let var0 = (C5 + var1);
var0 & 48
  =>
newvar0 & 48
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr;
if (util::filter(F, 765) && match(I, m_c_And(m_c_Add(m_Constant(&x3), m_c_And(m_Value(x2), m_Constant(&x1))), &x4 <<= m_ExtInt("48", 32)))) {
if (util::dc(DT, I, x2) && util::k0(x3, "111111", 32) && util::k1(x1, "110000", 32) && util::check_width(x3,32) && util::check_width(x2,32) && util::check_width(x1,32)) {
  auto C0 = C(32, 48, B);
  auto ret = B->CreateAnd(x2, C0(x2));
if (util::check_width(ret, I)) {
  St.hit(765, 2);
  return ret;

}
}
}}

/* Opt : 724
%symconst_1:i8 = var ; symconst_1
%newvar0:i8 = var ; newvar0
%2:i8 = or %symconst_1, %newvar0
%3:i8 = and %symconst_1, %2
infer %3
result %symconst_1

C1 & (C1 | newvar0)
  =>
C1
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 724) && match(I, m_c_And(m_Constant(&x1), m_c_Or(m_Deferred(x1), m_Value(x0))))) {
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(724, 2);
  return ret;

}
}
}
/* Opt : 629
%symconst_2:i8 = var ; symconst_2
%symconst_1:i8 = var ; symconst_1
%2:i8 = xor 255:i8, %symconst_1
%3:i1 = eq %symconst_2, %2
pc %3 1:i1
%v0:i8 = var ; v0
%5:i8 = and %symconst_1, %v0
%6:i8 = and %symconst_2, %5
infer %6
result 0:i8

C2 == ~C1
  |= 
C2 & (v0 & C1)
  =>
0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
if (util::filter(F, 629) && match(I, m_c_And(m_Constant(&x2), m_c_And(m_Constant(&x1), m_Value(x3))))) {
if ((eq(util::V(x2), flip(util::V(x1))) == llvm::APInt(1, 1))) {
  auto C0 = C(8, 0, B);
  auto ret = C0(I);
if (util::check_width(ret, I)) {
  St.hit(629, 2);
  return ret;

}
}
}}

/* Opt : 594
%v0:i32 = var (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) ; v0
%symconst_1:i32 = var (powerOfTwo) ; symconst_1
%2:i32 = srem %v0, %symconst_1
infer %2
%3:i32 = sub %symconst_1, 1:i32
%4:i32 = and %v0, %3
result %4

v0 (knownBits=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) %s C1 (powerOfTwo)
  =>
v0 & (C1 - 1)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 594) && match(I, m_SRem(m_Value(x1), m_Constant(&x0)))) {
if (util::pow2(x0) && util::dc(DT, I, x1) && util::k0(x1, "10000000000000000000000000000000", 32)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateAnd(x1, B->CreateSub(x0, C0(x0)));
if (util::check_width(ret, I)) {
  St.hit(594, 4);
  return ret;

}
}
}}

/* Opt : 56
%v0:i64 = var (range=[1,2)) ; v0
%symconst_1:i64 = var ; symconst_1
%2:i64 = add %v0, %symconst_1
infer %2
%3:i64 = add 1:i64, %symconst_1
result %3

v0 (range=[1,2)) + C1
  =>
C1 + 1
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 56) && match(I, m_c_Add(m_Value(x1), m_Constant(&x0)))) {
if (util::dc(DT, I, x0) && util::cr(x1, "1", "2")) {
  auto C0 = C(64, 1, B);
  auto ret = B->CreateAdd(C0(x0), x0);
if (util::check_width(ret, I)) {
  St.hit(56, 1);
  return ret;

}
}
}}

/* Opt : 408
%symconst_3:i8 = var ; symconst_3
%newvar0:i8 = var ; newvar0
%2:i8 = and 1:i8, %newvar0
%3:i1 = ne 0:i8, %2
%4:i1 = xor 1:i1, %3
%5:i1 = xor 1:i1, %4
%6:i8 = zext %5
%7:i8 = mul %symconst_3, %6
infer %7
%8:i8 = mul %symconst_3, %2
result %8

C3 * zext(~~((newvar0 & 1) != 0))
  =>
C3 * (newvar0 & 1)
*/
{
llvm::Value *x4 = nullptr, *x7 = nullptr, *x5 = nullptr, *x3 = nullptr, *x6 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 408) && match(I, m_c_Mul(m_Constant(&x5), m_ZExt(m_c_Xor(m_AllOnes(), m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Zero(), &x6 <<= m_c_And(&x7 <<= m_ExtInt("1", 8), m_Value(x3))))))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x5) && util::dc(DT, I, x6) && util::dc(DT, I, x3)) {
  auto C0 = C(8, 1, B);
  auto ret = B->CreateMul(x5, x6);
if (util::check_width(ret, I)) {
  St.hit(408, 4);
  return ret;

}
}
}}

/* Opt : 3747
%v0:i8 = var ; v0
%1:i64 = zext %v0 (hasExternalUses)
%v2:i8 = var ; v2
%3:i64 = zext %v2
%4:i1 = ule %1, %3
infer %4
%5:i1 = ule %v0, %v2
result %5

zext(v0) <=u zext(v2)
  =>
v0 <=u v2
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3747) && match(I, m_ICmp(P0, m_ZExt(m_Value(x3)), m_ZExt(m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_ULE && util::dc(DT, I, x3) && util::dc(DT, I, x1)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULE, x3, x1);
if (util::check_width(ret, I)) {
  St.hit(3747, 2);
  return ret;

}
}
}}

/* Opt : 3206
%symconst_4:i32 = var ; symconst_4
%1:i32 = width %symconst_4
%2:i32 = sub %1, 1:i32
%3:i1 = eq %symconst_4, %2
pc %3 1:i1
%v0:i32 = var ; v0
%5:i32 = width %v0
%6:i1 = eq 32:i32, %5
pc %6 1:i1
%7:i1 = eq 32:i32, %1
pc %7 1:i1
%8:i32 = lshr %v0, %symconst_4
%9:i1 = ne 0:i32, %8
infer %9
%10:i32 = add 2147483616:i32, %symconst_4
%11:i1 = ult %10, %v0
result %11

let var0 = width(C4);
C4 == (var0 - 1) && 
width(v0) == 32 && 
var0 == 32
  |= 
let var1 = (v0 >>l C4);
var1 != 0
  =>
let var2 = (C4 + 0x7FFFFFE0);
var2 <u v0
*/
{
llvm::Value *x0 = nullptr, *x1 = nullptr, *x2 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3206) && match(I, m_c_ICmp(P0, m_Zero(), m_LShr(m_Value(x2), m_Constant(&x1))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && (eq(util::V(x1), sub(util::W(x1), llvm::APInt(32, 1))) == llvm::APInt(1, 1)) && util::check_width(x2,32) && util::check_width(x1,32)) {
  auto C0 = C(32, 2147483616, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_ULT, B->CreateAdd(x1, C0(x1)), x2);
if (util::check_width(ret, I)) {
  St.hit(3206, 1);
  return ret;

}
}
}}

/* Opt : 310
%newvar0:i1 = var ; newvar0
%1:i32 = zext %newvar0
%2:i32 = sub 0:i32, %1
infer %2
%3:i32 = sext %newvar0
result %3

0 - zext(newvar0)
  =>
sext(newvar0)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 310) && match(I, m_Sub(m_Zero(), m_ZExt(m_Value(x1))))) {
if (util::check_width(x1,1) && util::dc(DT, I, x1)) {
  auto ret = B->CreateSExt(x1, T(I));
if (util::check_width(ret, I)) {
  St.hit(310, 1);
  return ret;

}
}
}}

/* Opt : 3040
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%2:i1 = ne %symconst_1, %symconst_2
pc %2 1:i1
%newvar0:i1 = var ; newvar0
%4:i32 = select %newvar0, %symconst_1, %symconst_2
%5:i1 = eq %symconst_1, %4
infer %5
result %newvar0

C2 != C1
  |= 
C1 == (select newvar0 C1 C2)
  =>
newvar0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3040) && match(I, m_c_ICmp(P0, m_Constant(&x2), m_Select(m_Value(x3), m_Deferred(x2), m_Constant(&x1))))) {
if (P0 == ICmpInst::ICMP_EQ && util::check_width(x3,1) && (ne(util::V(x2), util::V(x1)) == llvm::APInt(1, 1))) {
  auto ret = x3;
if (util::check_width(ret, I)) {
  St.hit(3040, 4);
  return ret;

}
}
}}

/* Opt : 2852
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = zext %v0
%3:i32 = sub %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = sub %5, %v0
result %6

trunc((C1 - zext(v0)))
  =>
trunc(C1) - v0
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2852) && match(I, m_Trunc(m_Sub(m_Constant(&x3), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateSub(B->CreateTrunc(x3, T(x2)), x2);
if (util::check_width(ret, I)) {
  St.hit(2852, 2);
  return ret;

}
}
}}

/* Opt : 2851
%symconst_1:i64 = var ; symconst_1
%1:i1 = ult 0:i64, %symconst_1
%v0:i8 = var ; v0
%3:i8 = width %v0
%4:i64 = zext %3
%5:i1 = ult %symconst_1, %4
%6:i1 = and %1, %5
pc %6 1:i1
%7:i64 = zext %v0
%8:i64 = lshr %7, %symconst_1
%9:i8 = trunc %8
infer %9
%10:i8 = trunc %symconst_1
%11:i8 = lshr %v0, %10
result %11

(0 <u C1) & (C1 <u zext(width(v0)))
  |= 
trunc((zext(v0) >>l C1))
  =>
v0 >>l trunc(C1)
*/
{
llvm::Value *x0 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x6 = nullptr, *x5 = nullptr;
if (util::filter(F, 2851) && match(I, m_Trunc(m_LShr(m_ZExt(m_Value(x3)), m_Constant(&x4))))) {
if (util::dc(DT, I, x3) && ((ult(llvm::APInt(64, 0), util::V(x4)) & ult(util::V(x4), util::W(x3).zext(64))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateLShr(x3, B->CreateTrunc(x4, T(x3)));
if (util::check_width(ret, I)) {
  St.hit(2851, 2);
  return ret;

}
}
}}

/* Opt : 2825
%v0:i8 = var ; v0
%1:i32 = sext %v0
%symconst_1:i32 = var ; symconst_1
%3:i32 = sub %1, %symconst_1
%4:i8 = trunc %3
infer %4
%5:i32 = sub 0:i32, %symconst_1
%6:i8 = trunc %5
%7:i8 = add %v0, %6
result %7

trunc((sext(v0) - C1))
  =>
v0 + trunc((0 - C1))
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2825) && match(I, m_Trunc(m_Sub(m_SExt(m_Value(x3)), m_Constant(&x1))))) {
if (util::dc(DT, I, x3)) {
  auto C0 = C(32, 0, B);
  auto ret = B->CreateAdd(x3, B->CreateTrunc(B->CreateSub(C0(x1), x1), T(x3)));
if (util::check_width(ret, I)) {
  St.hit(2825, 2);
  return ret;

}
}
}}

/* Opt : 2806
%newvar2:i1 = var ; newvar2
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%3:i32 = select %newvar2, %symconst_1, %symconst_2
%4:i16 = trunc %3
infer %4
%5:i16 = trunc %symconst_1
%6:i16 = trunc %symconst_2
%7:i16 = select %newvar2, %5, %6
result %7

trunc((select newvar2 C1 C2))
  =>
select newvar2 trunc(C1) trunc(C2)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2806) && match(I, m_Trunc(m_Select(m_Value(x3), m_Constant(&x2), m_Constant(&x1))))) {
if (util::check_width(x3,1) && util::dc(DT, I, x3)) {
  auto ret = B->CreateSelect(x3, B->CreateTrunc(x2, T(16, B)), B->CreateTrunc(x1, T(16, B)));
if (util::check_width(ret, I)) {
  St.hit(2806, 1);
  return ret;

}
}
}}

/* Opt : 278
%v0:i64 = var (range=[1,2)) ; v0
%symconst_1:i64 = var ; symconst_1
%2:i64 = sub %v0, %symconst_1
infer %2
%3:i64 = sub 1:i64, %symconst_1
result %3

v0 (range=[1,2)) - C1
  =>
1 - C1
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 278) && match(I, m_Sub(m_Value(x1), m_Constant(&x0)))) {
if (util::dc(DT, I, x0) && util::cr(x1, "1", "2")) {
  auto C0 = C(64, 1, B);
  auto ret = B->CreateSub(C0(x0), x0);
if (util::check_width(ret, I)) {
  St.hit(278, 1);
  return ret;

}
}
}}

/* Opt : 2784
%v3:i64 = var ; v3
%1:i64 = and 4294967295:i64, %v3
%2:i32 = trunc %1
infer %2
%3:i32 = trunc %v3
result %3

trunc((v3 & 0xFFFFFFFF))
  =>
trunc(v3)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2784) && match(I, m_Trunc(m_c_And(m_ExtInt("4294967295", 64), m_Value(x1))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateTrunc(x1, T(I));
if (util::check_width(ret, I)) {
  St.hit(2784, 1);
  return ret;

}
}
}}

/* Opt : 2763
%v0:i64 = var ; v0
%1:i64 = add 0:i64, %v0
%2:i32 = trunc %1
infer %2
%3:i32 = trunc %v0
result %3

trunc((v0 + 0))
  =>
trunc(v0)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2763) && match(I, m_Trunc(m_c_Add(m_Zero(), m_Value(x1))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateTrunc(x1, T(I));
if (util::check_width(ret, I)) {
  St.hit(2763, 1);
  return ret;

}
}
}}

/* Opt : 2687
%newvar0:i32 = var ; newvar0
%1:i32 = and 1:i32, %newvar0
%2:i1 = ne 0:i32, %1
%3:i1 = xor 1:i1, %2
%4:i1 = xor 1:i1, %3
%5:i32 = zext %4
infer %5
result %1

zext(~~((newvar0 & 1) != 0))
  =>
newvar0 & 1
*/
{
llvm::Value *x4 = nullptr, *x6 = nullptr, *x3 = nullptr, *x5 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2687) && match(I, m_ZExt(m_c_Xor(m_AllOnes(), m_c_Xor(m_AllOnes(), m_c_ICmp(P0, m_Zero(), &x5 <<= m_c_And(&x6 <<= m_ExtInt("1", 32), m_Value(x3)))))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x3)) {
  auto C0 = C(32, 1, B);
  auto ret = x5;
if (util::check_width(ret, I)) {
  St.hit(2687, 4);
  return ret;

}
}
}}

/* Opt : 259
%symconst_2:i8 = var ; symconst_2
%symconst_1:i8 = var ; symconst_1
%2:i8 = sub %symconst_2, %symconst_1
%3:i1 = eq 1:i8, %2
pc %3 1:i1
%v1:i8 = var ; v1
%5:i8 = add %symconst_1, %v1
%6:i8 = sub %5, %symconst_2
infer %6
%7:i8 = add 255:i8, %v1
result %7

(C2 - C1) == 1
  |= 
(v1 + C1) - C2
  =>
v1 + 0xFF
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
if (util::filter(F, 259) && match(I, m_Sub(m_c_Add(m_Constant(&x1), m_Value(x3)), m_Constant(&x2)))) {
if (util::dc(DT, I, x3) && (eq(llvm::APInt(8, 1), sub(util::V(x2), util::V(x1))) == llvm::APInt(1, 1))) {
  auto C0 = C(8, -1, B);
  auto ret = B->CreateAdd(C0(x3), x3);
if (util::check_width(ret, I)) {
  St.hit(259, 1);
  return ret;

}
}
}}

/* Opt : 256
%v1:i64 = var ; v1
%v0:i64 = var ; v0
%2:i64 = sub %v1, %v0
%3:i64 = sub %v1, %2
infer %3
result %v0

v1 - (v1 - v0)
  =>
v0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 256) && match(I, m_Sub(m_Value(x1), m_Sub(m_Deferred(x1), m_Value(x0))))) {
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(256, 2);
  return ret;

}
}
}
/* Opt : 2496
%symconst_2:i8 = var ; symconst_2
%v0:i8 = var ; v0
%2:i8 = width %v0
%3:i1 = ult %symconst_2, %2
pc %3 1:i1
%4:i8 = and %symconst_2, %v0
%5:i1 = eq 0:i8, %4
%6:i8 = zext %5
infer %6
%7:i8 = sub 1:i8, %symconst_2
%8:i8 = add %symconst_2, %7
%9:i8 = ashr %8, %4
result %9

C2 <u width(v0)
  |= 
let var0 = (v0 & C2);
zext((var0 == 0))
  =>
(C2 + (1 - C2)) >>a var0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x4 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2496) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), &x4 <<= m_c_And(m_Constant(&x2), m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x4) && util::dc(DT, I, x2) && util::dc(DT, I, x1) && (ult(util::V(x2), util::W(x1)) == llvm::APInt(1, 1))) {
  auto C0 = C(8, 1, B);
  auto ret = B->CreateAShr(B->CreateAdd(x2, B->CreateSub(C0(x2), x2)), x4);
if (util::check_width(ret, I)) {
  St.hit(2496, 1);
  return ret;

}
}
}}

/* Opt : 2450
%v0:i1 = var ; v0
%1:i32 = zext %v0
%2:i1 = ne 0:i32, %1
%3:i1 = xor 1:i1, %2
%4:i32 = zext %3
infer %4
%5:i32 = zext 1:i1
%6:i32 = sub %5, %1
result %6

zext(~(zext(v0) != 0))
  =>
zext(1) - zext(v0)
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2450) && match(I, m_ZExt(m_c_Xor(&x4 <<= m_AllOnes(), m_c_ICmp(P0, m_Zero(), &x2 <<= m_ZExt(m_Value(x3))))))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x3,1) && util::dc(DT, I, x2) && util::dc(DT, I, x3)) {
  auto C0 = C(1, -1, B);
  auto ret = B->CreateSub(B->CreateZExt(C0(), T(x2)), x2);
if (util::check_width(ret, I)) {
  St.hit(2450, 2);
  return ret;

}
}
}}

/* Opt : 1784
%newvar0:i32 = var ; newvar0
%1:i32 = and 2:i32, %newvar0
%2:i1 = ne 0:i32, %1
%3:i32 = select %2, 2:i32, 0:i32
infer %3
result %1

select ((newvar0 & 2) != 0) 2 0
  =>
newvar0 & 2
*/
{
llvm::Value *x2 = nullptr, *x0 = nullptr, *x1 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1784) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), &x1 <<= m_c_And(&x2 <<= m_ExtInt("2", 32), m_Value(x0))), &x2 <<= m_ExtInt("2", 32), m_Zero()))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x0)) {
  auto C0 = C(32, 2, B);
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(1784, 4);
  return ret;

}
}
}}

/* Opt : 1584
%newvar0:i8 = var ; newvar0
%1:i8 = and 1:i8, %newvar0
%2:i32 = zext %1
%3:i1 = ne 0:i32, %2
%4:i32 = select %3, 1:i32, 0:i32
infer %4
result %2

select (zext((newvar0 & 1)) != 0) 1 0
  =>
zext((newvar0 & 1))
*/
{
llvm::Value *x3 = nullptr, *x1 = nullptr, *x2 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1584) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), &x0 <<= m_ZExt(&x2 <<= m_c_And(&x3 <<= m_ExtInt("1", 8), m_Value(x1)))), m_ExtInt("1", 32), m_Zero()))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x1)) {
  auto C0 = C(8, 1, B);
  auto ret = x0;
if (util::check_width(ret, I)) {
  St.hit(1584, 4);
  return ret;

}
}
}}

/* Opt : 1003
%symconst_2:i8 = var ; symconst_2
%v0:i8 = var ; v0
%2:i8 = and %symconst_2, %v0
%symconst_1:i8 = var ; symconst_1
%4:i8 = and %v0, %symconst_1
%5:i8 = or %2, %4
infer %5
%6:i8 = or %symconst_2, %symconst_1
%7:i8 = and %v0, %6
result %7

(v0 & C2) | (v0 & C1)
  =>
v0 & (C2 | C1)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1003) && match(I, m_c_Or(m_c_And(m_Constant(&x2), m_Value(x1)), m_c_And(m_Deferred(x1), m_Constant(&x0))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateAnd(x1, B->CreateOr(x2, x0));
if (util::check_width(ret, I)) {
  St.hit(1003, 2);
  return ret;

}
}
}}

/* Opt : 386
%newvar5:i64 = var ; newvar5
%newvar2:i64 = var ; newvar2
%2:i64 = shl 1:i64, %newvar2
%3:i64 = mul %newvar5, %2
infer %3
%4:i64 = shl %newvar5, %newvar2
result %4

newvar5 * (1 << newvar2)
  =>
newvar5 << newvar2
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 386) && match(I, m_c_Mul(m_Value(x1), m_Shl(m_ExtInt("1", 64), m_Value(x0))))) {
if (util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto ret = B->CreateShl(x1, x0);
if (util::check_width(ret, I)) {
  St.hit(386, 1);
  return ret;

}
}
}}

/* Opt : 3682
%newvar0:i32 = var ; newvar0
%1:i32 = subnsw %newvar0, 1:i32
%v3:i32 = var ; v3
%3:i1 = slt %1, %v3
infer %3
%4:i1 = sle %newvar0, %v3
result %4

(newvar0 -nsw 1) <s v3
  =>
newvar0 <=s v3
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3682) && match(I, m_ICmp(P0, m_NSWSub(m_Value(x1), m_ExtInt("1", 32)), m_Value(x0)))) {
if (P0 == ICmpInst::ICMP_SLT && util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_SLE, x1, x0);
if (util::check_width(ret, I)) {
  St.hit(3682, 1);
  return ret;

}
}
}}

/* Opt : 30
%v0:i64 = var ; v0
%1:i64 = xor 18446744073709551615:i64, %v0
%2:i64 = add 1:i64, %1
infer %2
%3:i64 = mul 18446744073709551615:i64, %v0
result %3

~v0 + 1
  =>
v0 * 0xFFFFFFFFFFFFFFFF
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 30) && match(I, m_c_Add(m_ExtInt("1", 64), m_c_Xor(&x1 <<= m_AllOnes(), m_Value(x0))))) {
if (util::dc(DT, I, x0)) {
  auto C0 = C(64, -1, B);
  auto ret = B->CreateMul(C0(x0), x0);
if (util::check_width(ret, I)) {
  St.hit(30, 1);
  return ret;

}
}
}}

/* Opt : 3056
%symconst_2:i8 = var ; symconst_2
%symconst_1:i8 = var ; symconst_1
%2:i8 = mul 2:i8, %symconst_1
%3:i1 = eq %symconst_2, %2
pc %3 1:i1
%v1:i8 = var ; v1
%5:i8 = add %symconst_1, %v1
%6:i1 = eq %symconst_2, %5
infer %6
%7:i1 = eq %symconst_1, %v1
result %7

C2 == (C1 * 2)
  |= 
C2 == (v1 + C1)
  =>
v1 == C1
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3056) && match(I, m_c_ICmp(P0, m_Constant(&x2), m_c_Add(m_Constant(&x1), m_Value(x3))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x1) && util::dc(DT, I, x3) && (eq(util::V(x2), mul(llvm::APInt(8, 2), util::V(x1))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x1, x3);
if (util::check_width(ret, I)) {
  St.hit(3056, 1);
  return ret;

}
}
}}

/* Opt : 3055
%v0:i32 = var ; v0
%1:i32 = and 1:i32, %v0
%2:i1 = eq 1:i32, %1
infer %2
%3:i1 = trunc %v0
result %3

(v0 & 1) == 1
  =>
trunc(v0)
*/
{
llvm::Value *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3055) && match(I, m_c_ICmp(P0, m_ExtInt("1", 32), m_c_And(m_ExtInt("1", 32), m_Value(x0))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x0)) {
  auto ret = B->CreateTrunc(x0, T(I));
if (util::check_width(ret, I)) {
  St.hit(3055, 1);
  return ret;

}
}
}}

/* Opt : 2967
%symconst_1:i8 = var ; symconst_1
%v1:i8 = var ; v1
%2:i8 = add %symconst_1, %v1
%3:i1 = eq %symconst_1, %2
infer %3
%4:i1 = eq 0:i8, %v1
result %4

C1 == (v1 + C1)
  =>
v1 == 0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2967) && match(I, m_c_ICmp(P0, m_Constant(&x1), m_c_Add(m_Deferred(x1), m_Value(x0))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x0)) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, C0(x0), x0);
if (util::check_width(ret, I)) {
  St.hit(2967, 1);
  return ret;

}
}
}}

/* Opt : 2905
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = sext %v0
%3:i32 = add %symconst_1, %2
%symconst_2:i32 = var ; symconst_2
%5:i32 = subnsw %3, %symconst_2
%6:i8 = trunc %5
infer %6
%7:i32 = sub %symconst_1, %symconst_2
%8:i8 = trunc %7
%9:i8 = add %v0, %8
result %9

trunc(((C1 + sext(v0)) -nsw C2))
  =>
v0 + trunc((C1 - C2))
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2905) && match(I, m_Trunc(m_NSWSub(m_c_Add(m_Constant(&x4), m_SExt(m_Value(x3))), m_Constant(&x1))))) {
if (util::dc(DT, I, x3)) {
  auto ret = B->CreateAdd(x3, B->CreateTrunc(B->CreateSub(x4, x1), T(x3)));
if (util::check_width(ret, I)) {
  St.hit(2905, 3);
  return ret;

}
}
}}

/* Opt : 2814
%symconst_1:i32 = var ; symconst_1
%symconst_2:i32 = var ; symconst_2
%2:i32 = sext 1:i1
%3:i32 = xor %symconst_2, %2
%4:i1 = eq %symconst_1, %3
pc %4 1:i1
%v0:i8 = var ; v0
%6:i32 = zext %v0
%7:i32 = and %symconst_1, %6
%8:i32 = or %symconst_2, %7
%9:i8 = trunc %8
infer %9
%10:i8 = trunc %symconst_2
%11:i8 = or %v0, %10
result %11

C1 == (C2 ^ sext(1))
  |= 
trunc((C2 | (C1 & zext(v0))))
  =>
v0 | trunc(C2)
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x3 = nullptr, *x1 = nullptr, *x6 = nullptr, *x5 = nullptr, *x4 = nullptr;
if (util::filter(F, 2814) && match(I, m_Trunc(m_c_Or(m_Constant(&x1), m_c_And(m_Constant(&x3), m_ZExt(m_Value(x6))))))) {
if (util::dc(DT, I, x6) && (eq(util::V(x3), xor_(llvm::APInt(1, 1).sext(64), util::V(x1))) == llvm::APInt(1, 1))) {
  auto ret = B->CreateOr(x6, B->CreateTrunc(x1, T(x6)));
if (util::check_width(ret, I)) {
  St.hit(2814, 3);
  return ret;

}
}
}}

/* Opt : 2777
%v0:i8 = var ; v0
%1:i32 = sext %v0
%v2:i8 = var ; v2
%3:i32 = sext %v2
%4:i32 = and %1, %3
%5:i8 = trunc %4
infer %5
%6:i8 = and %v0, %v2
result %6

trunc((sext(v0) & sext(v2)))
  =>
v2 & v0
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2777) && match(I, m_Trunc(m_c_And(m_SExt(m_Value(x4)), m_SExt(m_Value(x2)))))) {
if (util::dc(DT, I, x4) && util::dc(DT, I, x2)) {
  auto ret = B->CreateAnd(x4, x2);
if (util::check_width(ret, I)) {
  St.hit(2777, 3);
  return ret;

}
}
}}

/* Opt : 2770
%v0:i8 = var ; v0
%1:i32 = sext %v0
%v2:i8 = var ; v2
%3:i32 = sext %v2
%4:i32 = xor %1, %3
%5:i8 = trunc %4
infer %5
%6:i8 = xor %v0, %v2
result %6

trunc((sext(v0) ^ sext(v2)))
  =>
v2 ^ v0
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2770) && match(I, m_Trunc(m_c_Xor(m_SExt(m_Value(x4)), m_SExt(m_Value(x2)))))) {
if (util::dc(DT, I, x4) && util::dc(DT, I, x2)) {
  auto ret = B->CreateXor(x4, x2);
if (util::check_width(ret, I)) {
  St.hit(2770, 3);
  return ret;

}
}
}}

/* Opt : 2751
%v4:i8 = var ; v4
%1:i32 = zext %v4
%v1:i8 = var ; v1
%3:i32 = zext %v1 (hasExternalUses)
%4:i32 = sub %1, %3
%5:i8 = trunc %4
infer %5
%6:i8 = sub %v4, %v1
result %6

trunc((zext(v4) - zext(v1)))
  =>
v4 - v1
*/
{
llvm::Value *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2751) && match(I, m_Trunc(m_Sub(m_ZExt(m_Value(x4)), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x4) && util::dc(DT, I, x2)) {
  auto ret = B->CreateSub(x4, x2);
if (util::check_width(ret, I)) {
  St.hit(2751, 3);
  return ret;

}
}
}}

/* Opt : 2599
%v0:i8 = var ; v0
%1:i8 = and 1:i8, %v0
%2:i32 = zext %1
%3:i1 = ne 0:i32, %2
%4:i8 = zext %3
infer %4
result %1

zext((zext((v0 & 1)) != 0))
  =>
v0 & 1
*/
{
llvm::Value *x4 = nullptr, *x2 = nullptr, *x3 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2599) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), m_ZExt(&x3 <<= m_c_And(&x4 <<= m_ExtInt("1", 8), m_Value(x2))))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2)) {
  auto C0 = C(8, 1, B);
  auto ret = x3;
if (util::check_width(ret, I)) {
  St.hit(2599, 3);
  return ret;

}
}
}}

/* Opt : 2443
%newvar0:i32 = var ; newvar0
%1:i32 = and 1:i32, %newvar0
%2:i1 = ne 0:i32, %1
%3:i8 = zext %2
infer %3
%4:i8 = trunc %1
result %4

zext(((newvar0 & 1) != 0))
  =>
trunc((newvar0 & 1))
*/
{
llvm::Value *x3 = nullptr, *x1 = nullptr, *x2 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2443) && match(I, m_ZExt(m_c_ICmp(P0, m_Zero(), &x2 <<= m_c_And(&x3 <<= m_ExtInt("1", 32), m_Value(x1)))))) {
if (P0 == ICmpInst::ICMP_NE && util::dc(DT, I, x2) && util::dc(DT, I, x1)) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateTrunc(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2443, 1);
  return ret;

}
}
}}

/* Opt : 2430
%v0:i32 = var ; v0
%1:i32 = add 0:i32, %v0
%2:i64 = zext %1
infer %2
%3:i64 = zext %v0
result %3

zext((v0 + 0))
  =>
zext(v0)
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2430) && match(I, m_ZExt(m_c_Add(m_Zero(), m_Value(x1))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateZExt(x1, T(I));
if (util::check_width(ret, I)) {
  St.hit(2430, 1);
  return ret;

}
}
}}

/* Opt : 1521
%v0:i32 = var ; v0
%1:i32 = width %v0
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%3:i1 = slt %v0, 0:i32 (hasExternalUses)
%4:i32 = select %3, 1:i32, 0:i32
infer %4
%5:i32 = lshr %v0, 31:i32
result %5

width(v0) == 32
  |= 
select (v0 <s 0) 1 0
  =>
v0 >>l 31
*/
{
llvm::Value *x0 = nullptr, *x1 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1521) && match(I, m_Select(m_ICmp(P0, m_Value(x1), m_Zero()), m_ExtInt("1", 32), m_Zero()))) {
if (P0 == ICmpInst::ICMP_SLT && util::dc(DT, I, x1) && util::check_width(x1,32)) {
  auto C0 = C(32, 31, B);
  auto ret = B->CreateLShr(x1, C0(x1));
if (util::check_width(ret, I)) {
  St.hit(1521, 3);
  return ret;

}
}
}}

/* Opt : 1232
%symconst_3:i8 = var ; symconst_3
%newvar1:i1 = var ; newvar1
%symconst_1:i8 = var ; symconst_1
%symconst_2:i8 = var ; symconst_2
%4:i8 = select %newvar1, %symconst_1, %symconst_2
%5:i8 = xor %symconst_3, %4
infer %5
%6:i8 = xor %symconst_3, %symconst_1
%7:i8 = xor %symconst_3, %symconst_2
%8:i8 = select %newvar1, %6, %7
result %8

C3 ^ (select newvar1 C1 C2)
  =>
select newvar1 (C3 ^ C1) (C3 ^ C2)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 1232) && match(I, m_c_Xor(m_Constant(&x3), m_Select(m_Value(x2), m_Constant(&x1), m_Constant(&x0))))) {
if (util::check_width(x2,1) && util::dc(DT, I, x2)) {
  auto ret = B->CreateSelect(x2, B->CreateXor(x3, x1), B->CreateXor(x3, x0));
if (util::check_width(ret, I)) {
  St.hit(1232, 1);
  return ret;

}
}
}}

/* Opt : 1106
%v0:i8 = var ; v0
%symconst_2:i8 = var ; symconst_2
%2:i8 = and %v0, %symconst_2
%symconst_1:i8 = var ; symconst_1
%symconst_3:i8 = var ; symconst_3
%5:i8 = and %v0, %symconst_3
%6:i8 = and %symconst_1, %5
%7:i8 = or %2, %6
infer %7
%8:i8 = and %symconst_1, %symconst_3
%9:i8 = or %symconst_2, %8
%10:i8 = and %v0, %9
result %10

(v0 & C2) | (C1 & (v0 & C3))
  =>
v0 & (C2 | (C3 & C1))
*/
{
llvm::Value *x1 = nullptr, *x3 = nullptr, *x2 = nullptr, *x0 = nullptr;
if (util::filter(F, 1106) && match(I, m_c_Or(m_c_And(m_Value(x1), m_Constant(&x3)), m_c_And(m_Constant(&x2), m_c_And(m_Deferred(x1), m_Constant(&x0)))))) {
if (util::dc(DT, I, x1)) {
  auto ret = B->CreateAnd(x1, B->CreateOr(x3, B->CreateAnd(x2, x0)));
if (util::check_width(ret, I)) {
  St.hit(1106, 3);
  return ret;

}
}
}}

/* Opt : 814
%v0:i32 = var (range=[1,2)) ; v0
%symconst_1:i32 = var ; symconst_1
%2:i32 = and %v0, %symconst_1
infer %2
%3:i32 = and 1:i32, %symconst_1
result %3

v0 (range=[1,2)) & C1
  =>
C1 & 1
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 814) && match(I, m_c_And(m_Value(x1), m_Constant(&x0)))) {
if (util::dc(DT, I, x0) && util::cr(x1, "1", "2")) {
  auto C0 = C(32, 1, B);
  auto ret = B->CreateAnd(C0(x0), x0);
if (util::check_width(ret, I)) {
  St.hit(814, 1);
  return ret;

}
}
}}

/* Opt : 781
%symconst_2:i32 = var ; symconst_2
%v0:i1 = var ; v0
%2:i32 = select %v0, 0:i32, %symconst_2
%3:i32 = and %symconst_2, %2
infer %3
result %2

C2 & (select v0 0 C2)
  =>
select v0 0 C2
*/
{
llvm::Value *x3 = nullptr, *x0 = nullptr, *x1 = nullptr, *x2 = nullptr;
if (util::filter(F, 781) && match(I, m_c_And(m_Constant(&x0), &x2 <<= m_Select(m_Value(x1), &x3 <<= m_Zero(), m_Deferred(x0))))) {
if (util::check_width(x1,1) && util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto C0 = C(32, 0, B);
  auto ret = x2;
if (util::check_width(ret, I)) {
  St.hit(781, 1);
  return ret;

}
}
}}

/* Opt : 728
%symconst_4:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx111111) ; symconst_4
%1:i32 = width %symconst_4
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%newvar4:i32 = var ; newvar4
%4:i32 = width %newvar4
%5:i1 = eq 32:i32, %4
pc %5 1:i1
%symconst_2:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx11) ; symconst_2
%7:i32 = width %symconst_2
%8:i1 = eq 32:i32, %7
pc %8 1:i1
%symconst_1:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx11x) ; symconst_1
%10:i32 = width %symconst_1
%11:i1 = eq 32:i32, %10
pc %11 1:i1
%v0:i8 = var ; v0
%13:i8 = width %v0
%14:i1 = eq 8:i8, %13
pc %14 1:i1
%15:i32 = zext %v0
%16:i32 = width %15
%17:i1 = eq 32:i32, %16
pc %17 1:i1
%18:i32 = and 60:i32, %newvar4
%19:i32 = ashr %15, %symconst_1
%20:i32 = and %symconst_2, %19
%21:i32 = or %18, %20
%22:i32 = and %symconst_4, %21
infer %22
%23:i32 = add %18, %19
result %23

width(C4 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxx111111)) == 32 && 
width(newvar4) == 32 && 
width(C2 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx11)) == 32 && 
width(C1 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx11x)) == 32 && 
width(v0) == 8 && 
let var0 = zext(v0);
width(var0) == 32
  |= 
let var2 = (newvar4 & 60);
let var4 = (var0 >>a C1);
let var3 = (C2 & var4);
let var1 = (var2 | var3);
C4 & var1
  =>
var2 + var4
*/
{
llvm::Value *x0 = nullptr, *x6 = nullptr, *x5 = nullptr, *x4 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x9 = nullptr, *x8 = nullptr, *x7 = nullptr;
if (util::filter(F, 728) && match(I, m_c_And(m_Constant(&x6), m_c_Or(&x8 <<= m_c_And(m_Value(x5), &x9 <<= m_ExtInt("60", 32)), m_c_And(m_Constant(&x4), &x7 <<= m_AShr(&x1 <<= m_ZExt(m_Value(x2)), m_Constant(&x3))))))) {
if (util::dc(DT, I, x8) && util::dc(DT, I, x5) && util::dc(DT, I, x7) && util::dc(DT, I, x1) && util::dc(DT, I, x2) && util::dc(DT, I, x3) && util::k1(x6, "111111", 32) && util::k1(x4, "11", 32) && util::k1(x3, "110", 32) && util::check_width(x6,32) && util::check_width(x5,32) && util::check_width(x4,32) && util::check_width(x3,32) && util::check_width(x2,8) && util::check_width(x1,32)) {
  auto C0 = C(32, 60, B);
  auto ret = B->CreateAdd(x8, x7);
if (util::check_width(ret, I)) {
  St.hit(728, 2);
  return ret;

}
}
}}

/* Opt : 64
%v0:i8 = var ; v0
%symconst_2:i8 = var ; symconst_2
%2:i8 = sub %v0, %symconst_2
%3:i8 = add 255:i8, %2
infer %3
%4:i8 = xor 255:i8, %symconst_2
%5:i8 = add %v0, %4
result %5

(v0 - C2) + 0xFF
  =>
v0 + ~C2
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 64) && match(I, m_c_Add(&x2 <<= m_AllOnes(), m_Sub(m_Value(x1), m_Constant(&x0))))) {
if (util::dc(DT, I, x1)) {
  auto C0 = C(8, -1, B);
  auto ret = B->CreateAdd(x1, B->CreateXor(C0(x0), x0));
if (util::check_width(ret, I)) {
  St.hit(64, 1);
  return ret;

}
}
}}

/* Opt : 644
%symconst_1:i32 = var (knownBits=xxxxxxxxxxxxxxxxxxxxxxxx11111111) ; symconst_1
%1:i32 = width %symconst_1
%2:i1 = eq 32:i32, %1
pc %2 1:i1
%v0:i8 = var ; v0
%4:i8 = width %v0
%5:i1 = eq 8:i8, %4
pc %5 1:i1
%6:i32 = zext %v0
%7:i32 = width %6
%8:i1 = eq 32:i32, %7
pc %8 1:i1
%9:i32 = and %symconst_1, %6
infer %9
result %6

width(C1 (knownBits=xxxxxxxxxxxxxxxxxxxxxxxx11111111)) == 32 && 
width(v0) == 8 && 
let var0 = zext(v0);
width(var0) == 32
  |= 
C1 & var0
  =>
var0
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr;
if (util::filter(F, 644) && match(I, m_c_And(m_Constant(&x3), &x1 <<= m_ZExt(m_Value(x2))))) {
if (util::dc(DT, I, x2) && util::k1(x3, "11111111", 32) && util::check_width(x3,32) && util::check_width(x2,8) && util::check_width(x1,32)) {
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(644, 1);
  return ret;

}
}
}}

/* Opt : 3962
%symconst_5:i8 = var ; symconst_5
%symconst_4:i8 = var ; symconst_4
%v0:i8 = var ; v0
%3:i8 = and %symconst_4, %v0
%4:i8 = and %symconst_5, %3
%symDF_DB:i8 = var ; symDF_DB
%6:i8 = demandedmask %4, %symDF_DB
infer %6
%7:i8 = and %symconst_5, %symDF_DB
%8:i8 = and %symconst_4, %7
%9:i8 = and %v0, %8
%10:i8 = demandedmask %9, %symDF_DB
result %10

C5 & (v0 & C4)
  =>
v0 & (C4 & (C5 & @db))
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 3962) && match(I, m_c_And(m_Constant(&x3), m_c_And(m_Constant(&x2), m_Value(x1))))) {
if (util::symdb(DB, I, x0, B) && util::dc(DT, I, x0)) {
  auto ret = B->CreateAnd(x1, B->CreateAnd(x2, B->CreateAnd(x3, x0)));
if (util::check_width(ret, I)) {
  St.hit(3962, 1);
  return ret;

}
}
}}

/* Opt : 3947
%symconst_3:i32 = var ; symconst_3
%symDF_DB:i32 = var ; symDF_DB
%2:i32 = xor 4294967295:i32, %symDF_DB
%3:i1 = eq %symconst_3, %2
pc %3 1:i1
%newvar0:i32 = var ; newvar0
%5:i32 = and %symconst_3, %newvar0
%6:i32 = demandedmask %5, %symDF_DB
infer %6
%7:i32 = demandedmask 0:i32, %symDF_DB
result %7

C3 == ~@db
  |= 
C3 & newvar0
  =>
0
*/
{
llvm::Value *x0 = nullptr, *x2 = nullptr, *x1 = nullptr, *x3 = nullptr;
if (util::filter(F, 3947) && match(I, m_c_And(m_Constant(&x2), m_Value(x3)))) {
if (util::symdb(DB, I, x1, B) && util::dc(DT, I, x1) && (eq(util::V(x2), flip(util::V(x1))) == llvm::APInt(1, 1))) {
  auto C0 = C(32, 0, B);
  auto ret = C0(I);
if (util::check_width(ret, I)) {
  St.hit(3947, 2);
  return ret;

}
}
}}

/* Opt : 3945
%symconst_1:i32 = var ; symconst_1
%symDF_K1:i32 = var ; symDF_K1
%2:i1 = knownones %symconst_1, %symDF_K1
pc %2 1:i1
%symDF_DB:i32 = var ; symDF_DB
%4:i1 = knownones %symDF_K1, %symDF_DB
pc %4 1:i1
%newvar0:i32 = var ; newvar0
%6:i32 = or %symconst_1, %newvar0
%7:i32 = demandedmask %6, %symDF_DB
infer %7
%8:i32 = demandedmask %symconst_1, %symDF_DB
result %8

symconst_1.k1 <<=1 @db
  |= 
let var0 = C1 | newvar0;
var0
  =>
C1
*/
{
llvm::Value *x0 = nullptr, *x5 = nullptr, *x3 = nullptr, *x4 = nullptr, *x2 = nullptr, *x1 = nullptr, *x6 = nullptr;
if (util::filter(F, 3945) && match(I, m_c_Or(m_Constant(&x5), m_Value(x6)))) {
if (util::symk1bind(x5, x3, B) && util::symdb(DB, I, x2, B) && util::dc(DT, I, x5) && util::dc(DT, I, x2) && util::symk1test(x3, x2)) {
  auto ret = x5;
if (util::check_width(ret, I)) {
  St.hit(3945, 2);
  return ret;

}
}
}}

/* Opt : 391
%newvar0:i8 = var ; newvar0
%symconst_1:i8 = var ; symconst_1
%2:i8 = sub %newvar0, %symconst_1
%3:i8 = mul 255:i8, %2
infer %3
%4:i8 = sub %symconst_1, %newvar0
result %4

(newvar0 - C1) * 0xFF
  =>
C1 - newvar0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 391) && match(I, m_c_Mul(m_Sub(m_Value(x1), m_Constant(&x0)), m_AllOnes()))) {
if (util::dc(DT, I, x0) && util::dc(DT, I, x1)) {
  auto ret = B->CreateSub(x0, x1);
if (util::check_width(ret, I)) {
  St.hit(391, 1);
  return ret;

}
}
}}

/* Opt : 326
%v0:i8 = var ; v0
%1:i8 = sub 0:i8, %v0
%symconst_2:i8 = var ; symconst_2
%3:i8 = subnsw %1, %symconst_2
infer %3
%4:i8 = sub 0:i8, %symconst_2
%5:i8 = sub %4, %v0
result %5

(0 - v0) -nsw C2
  =>
(0 - C2) - v0
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 326) && match(I, m_NSWSub(m_Sub(&x2 <<= m_Zero(), m_Value(x1)), m_Constant(&x0)))) {
if (util::dc(DT, I, x1)) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateSub(B->CreateSub(C0(x0), x0), x1);
if (util::check_width(ret, I)) {
  St.hit(326, 1);
  return ret;

}
}
}}

/* Opt : 320
%v0:i32 = var ; v0
%newvar0:i32 = var ; newvar0
%2:i32 = add %v0, %newvar0
%3:i32 = subnsw %2, %newvar0
infer %3
result %v0

(v0 + newvar0) -nsw newvar0
  =>
v0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 320) && match(I, m_NSWSub(m_c_Add(m_Value(x1), m_Value(x0)), m_Deferred(x0)))) {
  auto ret = x1;
if (util::check_width(ret, I)) {
  St.hit(320, 2);
  return ret;

}
}
}
/* Opt : 3108
%v0:i8 = var ; v0
%symconst_1:i8 = var ; symconst_1
%2:i8 = add %v0, %symconst_1
%v2:i8 = var ; v2
%4:i8 = add %symconst_1, %v2
%5:i1 = eq %2, %4
infer %5
%6:i1 = eq %v0, %v2
result %6

(v0 + C1) == (v2 + C1)
  =>
v2 == v0
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3108) && match(I, m_c_ICmp(P0, m_c_Add(m_Value(x2), m_Constant(&x1)), m_c_Add(m_Deferred(x1), m_Value(x0))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x2) && util::dc(DT, I, x0)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x2, x0);
if (util::check_width(ret, I)) {
  St.hit(3108, 2);
  return ret;

}
}
}}

/* Opt : 3102
%symconst_1:i8 = var ; symconst_1
%v0:i8 = var ; v0
%2:i8 = sub 0:i8, %v0
%3:i1 = eq %symconst_1, %2
infer %3
%4:i8 = sub 0:i8, %symconst_1
%5:i1 = eq %v0, %4
result %5

C1 == (0 - v0)
  =>
v0 == (0 - C1)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3102) && match(I, m_c_ICmp(P0, m_Constant(&x1), m_Sub(&x2 <<= m_Zero(), m_Value(x0))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x0)) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x0, B->CreateSub(C0(x1), x1));
if (util::check_width(ret, I)) {
  St.hit(3102, 1);
  return ret;

}
}
}}

/* Opt : 3066
%newvar1:i8 = var ; newvar1
%1:i1 = eq %newvar1, %newvar1
infer %1
%2:i1 = eq 0:i8, 0:i8
result %2

newvar1 == newvar1
  =>
0 == 0
*/
{
llvm::Value *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3066) && match(I, m_c_ICmp(P0, m_Value(x0), m_Deferred(x0)))) {
if (P0 == ICmpInst::ICMP_EQ) {
  auto C0 = C(8, 0, B);
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, C0(), C0());
if (util::check_width(ret, I)) {
  St.hit(3066, 1);
  return ret;

}
}
}}

/* Opt : 3058
%v0:i1 = var ; v0
%1:i32 = zext %v0
%2:i1 = eq 0:i32, %1
infer %2
%3:i1 = xor 1:i1, %v0
result %3

zext(v0) == 0
  =>
~v0
*/
{
llvm::Value *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 3058) && match(I, m_c_ICmp(P0, m_Zero(), m_ZExt(m_Value(x1))))) {
if (P0 == ICmpInst::ICMP_EQ && util::check_width(x1,1) && util::dc(DT, I, x1)) {
  auto C0 = C(1, -1, B);
  auto ret = B->CreateXor(C0(x1), x1);
if (util::check_width(ret, I)) {
  St.hit(3058, 1);
  return ret;

}
}
}}

/* Opt : 2980
%symconst_1:i8 = var ; symconst_1
%newvar0:i8 = var ; newvar0
%symconst_2:i8 = var ; symconst_2
%3:i8 = sub %newvar0, %symconst_2
%4:i1 = eq %symconst_1, %3
infer %4
%5:i8 = add %symconst_1, %symconst_2
%6:i1 = eq %newvar0, %5
result %6

C1 == (newvar0 - C2)
  =>
newvar0 == (C2 + C1)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 2980) && match(I, m_c_ICmp(P0, m_Constant(&x2), m_Sub(m_Value(x1), m_Constant(&x0))))) {
if (P0 == ICmpInst::ICMP_EQ && util::dc(DT, I, x1)) {
  auto ret = B->CreateCmp(ICmpInst::ICMP_EQ, x1, B->CreateAdd(x2, x0));
if (util::check_width(ret, I)) {
  St.hit(2980, 1);
  return ret;

}
}
}}

/* Opt : 285
%symconst_1:i16 = var ; symconst_1
%symconst_2:i8 = var ; symconst_2
%2:i16 = zext %symconst_2
%3:i1 = eq %symconst_1, %2
pc %3 1:i1
%newvar4:i16 = var ; newvar4
%5:i16 = add %symconst_1, %newvar4
%6:i8 = trunc %5
%7:i8 = sub %6, %symconst_2
infer %7
%8:i8 = trunc %newvar4
result %8

C1 == zext(C2)
  |= 
trunc((C1 + newvar4)) - C2
  =>
trunc(newvar4)
*/
{
llvm::Value *x0 = nullptr, *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x5 = nullptr, *x4 = nullptr;
if (util::filter(F, 285) && match(I, m_Sub(m_Trunc(m_c_Add(m_Constant(&x3), m_Value(x5))), m_Constant(&x2)))) {
if (util::dc(DT, I, x5) && (eq(util::V(x3), util::V(x2).zext(64)) == llvm::APInt(1, 1))) {
  auto ret = B->CreateTrunc(x5, T(I));
if (util::check_width(ret, I)) {
  St.hit(285, 2);
  return ret;

}
}
}}

/* Opt : 2837
%symconst_1:i32 = var ; symconst_1
%v0:i8 = var ; v0
%2:i32 = zext %v0
%3:i32 = mul %symconst_1, %2
%4:i8 = trunc %3
infer %4
%5:i8 = trunc %symconst_1
%6:i8 = mul %v0, %5
result %6

trunc((C1 * zext(v0)))
  =>
v0 * trunc(C1)
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2837) && match(I, m_Trunc(m_c_Mul(m_Constant(&x3), m_ZExt(m_Value(x2)))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateMul(x2, B->CreateTrunc(x3, T(x2)));
if (util::check_width(ret, I)) {
  St.hit(2837, 2);
  return ret;

}
}
}}

/* Opt : 2816
%newvar1:i16 = var ; newvar1
%1:i32 = zext %newvar1
%2:i8 = trunc %1
infer %2
%3:i8 = trunc %newvar1
result %3

trunc(zext(newvar1))
  =>
trunc(newvar1)
*/
{
llvm::Value *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
if (util::filter(F, 2816) && match(I, m_Trunc(m_ZExt(m_Value(x2))))) {
if (util::dc(DT, I, x2)) {
  auto ret = B->CreateTrunc(x2, T(I));
if (util::check_width(ret, I)) {
  St.hit(2816, 1);
  return ret;

}
}
}}

/* Opt : 1922
%v0:i1 = var ; v0
%1:i32 = zext %v0
%2:i1 = ne 0:i32, %1
%symconst_2:i32 = var ; symconst_2
%v3:i32 = var ; v3
%5:i32 = select %2, %symconst_2, %v3
infer %5
%6:i32 = select %v0, %symconst_2, %v3
result %6

select (zext(v0) != 0) C2 v3
  =>
select v0 C2 v3
*/
{
llvm::Value *x3 = nullptr, *x2 = nullptr, *x1 = nullptr, *x0 = nullptr;
ICmpInst::Predicate P0;
if (util::filter(F, 1922) && match(I, m_Select(m_c_ICmp(P0, m_Zero(), m_ZExt(m_Value(x3))), m_Constant(&x1), m_Value(x0)))) {
if (P0 == ICmpInst::ICMP_NE && util::check_width(x3,1) && util::dc(DT, I, x3) && util::dc(DT, I, x1) && util::dc(DT, I, x0)) {
  auto ret = B->CreateSelect(x3, x1, x0);
if (util::check_width(ret, I)) {
  St.hit(1922, 2);
  return ret;

}
}
}}


 return nullptr;
}
