use corelib_imports::bounded_int::bounded_int::{add, mul};
use corelib_imports::bounded_int::{AddHelper, BoundedInt, MulHelper, UnitInt, upcast};

const POW_32: felt252 = 0x100000000;
const POW_64: felt252 = 0x10000000000000000;
const POW_96: felt252 = 0x1000000000000000000000000;

const POW_32_UI: UnitInt<POW_32> = 0x100000000;
const POW_64_UI: UnitInt<POW_64> = 0x10000000000000000;
const POW_96_UI: UnitInt<POW_96> = 0x1000000000000000000000000;

const POW_128: felt252 = 0x100000000000000000000000000000000;


pub type u32_bi = BoundedInt<0, { POW_32 - 1 }>;
pub type u64_bi = BoundedInt<0, { POW_64 - 1 }>;
pub type u96_bi = BoundedInt<0, { POW_96 - 1 }>;
pub type u128_bi = BoundedInt<0, { POW_128 - 1 }>;

pub type w1_shift_32 = BoundedInt<0, { 0xffffffff00000000 }>; // (2**32)-1 * 2**32
pub type w2_shift_64 = BoundedInt<0, { 0xffffffff0000000000000000 }>; // (2**32)-1 * 2**64
pub type w3_shift_96 = BoundedInt<0, { 0xffffffff000000000000000000000000 }>; // (2**32)-1 * 2**96


impl MulHelperU32ByPow32Impl of MulHelper<u32_bi, UnitInt<POW_32>> {
    type Result = w1_shift_32;
}

impl MulHelperU32ByPow64Impl of MulHelper<u32_bi, UnitInt<POW_64>> {
    type Result = w2_shift_64;
}

impl MulHelperU32ByPow96Impl of MulHelper<u32_bi, UnitInt<POW_96>> {
    type Result = w3_shift_96;
}

impl AddHelperU32ByW1Impl of AddHelper<u32_bi, w1_shift_32> {
    type Result = u64_bi;
}

impl AddHelperU64ByW2Impl of AddHelper<u64_bi, w2_shift_64> {
    type Result = u96_bi;
}

impl AddHelperU96ByW3Impl of AddHelper<u96_bi, w3_shift_96> {
    type Result = u128_bi;
}


const POW_2_32: u128 = 0x100000000;
const POW_2_64: u128 = 0x10000000000000000;
const POW_2_96: u128 = 0x100000000000000000000;

// Direct cast.
fn u32s_to_u128_direct_cast(d0: u32, d1: u32, d2: u32, d3: u32) -> u128 {
    let result: u128 = d0.into()
        + d1.into() * POW_2_32
        + d2.into() * POW_2_64
        + d3.into() * POW_2_96;
    return result;
}

// Using felt252 as intermediate type.
fn u32s_to_u128_felt252_intermediate(d0: u32, d1: u32, d2: u32, d3: u32) -> u128 {
    let intermediate_as_felt252: felt252 = d0.into()
        + d1.into() * POW_2_32.into()
        + d2.into() * POW_2_64.into()
        + d3.into() * POW_2_96.into();
    return intermediate_as_felt252.try_into().unwrap();
}

// Using bounded_int.
fn u32s_to_u128_bounded_int(d0: u32, d1: u32, d2: u32, d3: u32) -> u128 {
    let d0_bi: u32_bi = upcast(d0);
    let d1_bi: u32_bi = upcast(d1);
    let d2_bi: u32_bi = upcast(d2);
    let d3_bi: u32_bi = upcast(d3);

    let result_u128_bi: u128_bi = add(
        add(add(d0_bi, mul(d1_bi, POW_32_UI)), mul(d2_bi, POW_64_UI)), mul(d3_bi, POW_96_UI),
    );
    return upcast(result_u128_bi);
}

#[test]
fn test_u32s_to_u128_direct_cast() {
    let result = u32s_to_u128_direct_cast(1, 0, 0, 0);
    assert_eq!(result, 1);
}
#[test]
fn test_u32s_to_u128_felt252_intermediate() {
    let result = u32s_to_u128_felt252_intermediate(1, 0, 0, 0);
    assert_eq!(result, 1);
}
#[test]
fn test_u32s_to_u128_bounded_int() {
    let result = u32s_to_u128_bounded_int(1, 0, 0, 0);
    assert_eq!(result, 1);
}

