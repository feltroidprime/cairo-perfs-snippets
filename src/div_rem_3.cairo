use corelib_imports::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, UnitInt, bounded_int, upcast,
};

#[inline(never)]
pub fn scalar_to_epns(mut scalar: u128) -> (felt252, felt252) {
    let mut sum_p = 0;
    let mut sum_n = 0;

    let mut base_power = 1; // Init to (-3)^0

    while scalar != 0 {
        let (q0, r0) = core::traits::DivRem::div_rem(scalar, 3);
        let r0: felt252 = r0.into();
        if r0 == 0 {
            scalar = q0;
        } else if r0 == 2 {
            scalar = q0 + 1;
            sum_n += base_power;
        } else {
            scalar = q0;
            sum_p += base_power;
        }
        if scalar == 0 {
            break;
        }
        base_power = base_power * (-3);
        let (q1, r1) = core::traits::DivRem::div_rem(scalar, 3);
        let r1: felt252 = r1.into();

        if r1 == 0 {
            scalar = q1;
        } else if r1 == 2 {
            scalar = q1 + 1;
            sum_p += base_power;
        } else {
            scalar = q1;
            sum_n += base_power;
        }

        base_power = base_power * (-3);
    }
    return (sum_p, sum_n);
}


const THREE: felt252 = 3;
const THREE_NZ_TYPED: NonZero<UnitInt<THREE>> = 3;
const POW128_DIV_3: felt252 = 113427455640312821154458202477256070485; // ((2^128-1) // 3)
const POW128: felt252 = 0x100000000000000000000000000000000;

impl DivRemU128By3 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<THREE>> {
    type DivT = BoundedInt<0, { POW128_DIV_3 }>;
    type RemT = BoundedInt<0, { THREE - 1 }>;
}

impl AddOneHelper of AddHelper<BoundedInt<0, { POW128_DIV_3 }>, BoundedInt<0, 1>> {
    type Result = BoundedInt<0, { POW128_DIV_3 + 1 }>;
}

pub fn scalar_to_epns_2(_scalar: u128) -> (felt252, felt252) {
    let mut sum_p: felt252 = 0;
    let mut sum_n: felt252 = 0;

    let mut base_power: felt252 = 1; // Init to (-3)^0

    let mut scalar: BoundedInt<0, { POW128 - 1 }> = upcast(_scalar);
    while scalar != 0 {
        let (q0, r0) = bounded_int::div_rem(scalar, THREE_NZ_TYPED);
        let r0: felt252 = r0.into();

        if r0 == 0 {
            scalar = upcast(q0);
        } else if r0 == 2 {
            scalar = upcast(bounded_int::add(q0, 1));
            sum_n += base_power;
        } else {
            scalar = upcast(q0);
            sum_p += base_power;
        }
        base_power = base_power * (-3);

        let (q1, r1) = bounded_int::div_rem(scalar, THREE_NZ_TYPED);
        let r1: felt252 = r1.into();

        if r1 == 0 {
            scalar = upcast(q1);
        } else if r1 == 2 {
            scalar = upcast(bounded_int::add(q1, 1));
            sum_p += base_power;
        } else {
            scalar = upcast(q1);
            sum_n += base_power;
        }

        base_power = base_power * (-3);
    }
    return (sum_p, sum_n);
}


#[inline(never)]
pub fn div_and_add(scalar: u128) -> u128 {
    let mut scalar_bi: BoundedInt<0, { POW128 - 1 }> = upcast(scalar);
    let (_, _) = bounded_int::div_rem(scalar_bi, THREE_NZ_TYPED);
    return 1;
    // let r_252: felt252 = r.into();

    // // println!("scalar_bi: {:?}", scalar_bi);

    // let add_bi = bounded_int::add(q, 1);
// let add_bi_u128 = upcast(add_bi);
// return add_bi_u128;
}


#[test]
#[inline(never)]
fn test_div_and_add() {
    let x = 340282366920938463463374607431768211443_u128;
    let q = div_and_add(x);
    assert(q != 0, 'no');
}

#[test]
#[inline(never)]
fn test_scalar_to_epns_2() {
    let x = 340282366920938463463374607431768211443_u128;
    let (p, _) = scalar_to_epns_2(x);
    assert(p != 0, 'no');
}


// #[test]
// #[inline(never)]
// fn test_div_rem_u128_by_3() {
//     let x = 340282366920938463463374607431768211443_u128;
//     let (q, r) = core::traits::DivRem::div_rem(x, 3);
//     assert(q != 0, 'no');
//     assert(r == 0, 'no');
// }

#[test]
#[inline(never)]
fn test_scalar_to_epns() {
    let x = 340282366920938463463374607431768211443_u128;
    let (p, _) = scalar_to_epns(x);
    assert(p != 0, 'no');
}

