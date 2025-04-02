use core::internal::bounded_int::upcast;
use core::result::ResultTrait;
pub const MULTIPLIER: i128 = 100_000000_i128;
pub const MULTIPLIER_FELT: NonZero<felt252> = 100_000000;
pub const ONE: i128 = MULTIPLIER;
pub const TEN: i128 = 10 * MULTIPLIER;

#[inline(never)]
pub fn mul_128(a: i128, b: i128) -> i128 {
    (a * b) / MULTIPLIER
}

#[inline(never)]
pub fn mul_128_2(a: i128, b: i128) -> i128 {
    let res: felt252 = (a.into() * b.into());
    let res_i: i128 = res.try_into().unwrap();
    res_i / MULTIPLIER
}


#[inline(always)]
pub fn div_128(a: i128, b: NonZero<i128>) -> i128 {
    (a * MULTIPLIER) / b.into()
}

#[test]
fn test_mul_i128() {
    let a = mul_128(TEN, -4);
    assert_eq!(a, -40);
}
#[test]
fn test_mul_i128_2() {
    let a = mul_128_2(TEN, -4);
    assert_eq!(a, -40);
}

#[inline(never)]
pub fn abs_128(a: i128) -> u128 {
    if a < 0 {
        (-a).try_into().unwrap()
    } else {
        a.try_into().unwrap()
    }
}

#[inline(never)]
fn abs_and_sign(self: i128) -> (u128, bool) {
    match core::internal::bounded_int::constrain::<i128, 0>(self) {
        Result::Ok(lt0) => (upcast(core::internal::bounded_int::NegateHelper::negate(lt0)), true),
        Result::Err(ge0) => (upcast(ge0), false),
    }
}
#[inline(never)]
fn sign(self: i128) -> bool {
    match core::internal::bounded_int::constrain::<i128, 0>(self) {
        Result::Ok(_) => true,
        Result::Err(_) => false,
    }
}
#[test]
fn test_abs_1_neg() {
    let a = abs_128(-100_000000_i128);
    assert(a != 0, 'a is not 0');
}
#[test]
fn test_abs_1_pos() {
    let a = abs_128(100_000000_i128);
    assert(a != 0, 'a is not 0');
}
#[test]
fn test_abs_2_neg() {
    let (a, _) = abs_and_sign(-100_000000_i128);
    assert(a != 0, 'a is not 0');
}
#[test]
fn test_abs_2_pos() {
    let (a, _) = abs_and_sign(100_000000_i128);
    assert(a != 0, 'a is not 0');
}

#[inline(always)]
fn get_i128_random() -> Array<i128> {
    array![
        165,
        623,
        -960,
        -215,
        -932,
        -641,
        644,
        -738,
        -636,
        -832,
        -311,
        612,
        904,
        464,
        -242,
        -524,
        -992,
        249,
        -177,
        -274,
    ]
}
#[test]
fn test_i128_add() {
    let a: i128 = 100_i128;
    let b: i128 = 100_i128;
    let c: i128 = a + b + a + b;
    assert(c != 0, 'c is not 0');
}
#[test]
fn test_f252_add() {
    let a: felt252 = 100;
    let b: felt252 = 100;
    let c: felt252 = a + b + a + b;
    assert(c != 0, 'c is not 0');
}

#[test]
fn test_sum_naive() {
    let vals = get_i128_random();
    let mut sum: i128 = 0;
    for val in vals {
        sum = sum + val;
    }
    // println!("sum1: {}", sum);
    assert(sum == -3813, 'sum is not 0');
}

#[test]
fn test_sum_optimized() {
    let vals = get_i128_random();
    let mut sum: felt252 = 0;
    for val in vals {
        let (a, sign) = abs_and_sign(val);
        if sign {
            sum = sum - a.into();
        } else {
            sum = sum + a.into();
        }
    }
    let sum: i128 = sum.try_into().unwrap();
    // println!("sum2: {}", sum);
    assert(sum == -3813, 'sum_optimized is not 0');
}

#[test]
fn test_sum_optimized_2() {
    let vals = get_i128_random();
    let mut sum: felt252 = 0;
    for val in vals {
        sum = sum + val.into();
    }
    let sum: i128 = sum.try_into().unwrap();
    // println!("sum2: {}", sum);
    assert(sum == -3813, 'sum_optimized_2 is not 0');
}
