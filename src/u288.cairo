use core::circuit::{u384, u96};
use corelib_imports::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, bounded_int, downcast, upcast,
};
use corelib_imports::integer::{U128sFromFelt252Result, u128s_from_felt252};

const POW128: felt252 = 0x100000000000000000000000000000000;
const POW192: felt252 = 6277101735386680763835789423207666416102355444464034512896;

const POW96: felt252 = 0x1000000000000000000000000;
const POW96_TYPED: UnitInt<POW96> = 0x1000000000000000000000000;
const NZ_POW96_TYPED: NonZero<UnitInt<POW96>> = 0x1000000000000000000000000;
const POW64: felt252 = 0x10000000000000000;
const POW64_TYPED: UnitInt<POW64> = 0x10000000000000000;
const NZ_POW64_TYPED: NonZero<UnitInt<POW64>> = 0x10000000000000000;
const POW32: felt252 = 0x100000000;
const POW32_TYPED: UnitInt<POW32> = 0x100000000;
const NZ_POW32_TYPED: NonZero<UnitInt<POW32>> = 0x100000000;

impl DivRemU192By96 of DivRemHelper<BoundedInt<0, { POW192 - 1 }>, UnitInt<POW96>> {
    type DivT = BoundedInt<0, { POW96 - 1 }>;
    type RemT = BoundedInt<0, { POW96 - 1 }>;
}


impl DivRemU128By96 of DivRemHelper<u128, UnitInt<POW96>> {
    type DivT = BoundedInt<0, { POW32 - 1 }>;
    type RemT = BoundedInt<0, { POW96 - 1 }>;
}

impl DivRemU128By64 of DivRemHelper<u128, UnitInt<POW64>> {
    type DivT = BoundedInt<0, { POW64 - 1 }>;
    type RemT = BoundedInt<0, { POW64 - 1 }>;
}

impl DivRemU96By32 of DivRemHelper<u96, UnitInt<POW32>> {
    type DivT = BoundedInt<0, { POW64 - 1 }>;
    type RemT = BoundedInt<0, { POW32 - 1 }>;
}

impl DivRemU96By64 of DivRemHelper<u96, UnitInt<POW64>> {
    type DivT = BoundedInt<0, { POW32 - 1 }>;
    type RemT = BoundedInt<0, { POW64 - 1 }>;
}

impl MulHelper64By32Impl of MulHelper<BoundedInt<0, { POW64 - 1 }>, UnitInt<POW32>> {
    type Result = BoundedInt<0, { POW96 - POW32 }>;
}

impl MulHelper32By96Impl of MulHelper<BoundedInt<0, { POW32 - 1 }>, UnitInt<POW96>> {
    type Result = BoundedInt<0, { POW128 - POW96 }>;
}

impl MulHelper64By64Impl of MulHelper<BoundedInt<0, { POW64 - 1 }>, UnitInt<POW64>> {
    type Result = BoundedInt<0, { POW128 - POW64 }>;
}

impl AddHelperTo96By32Impl of AddHelper<
    BoundedInt<0, { POW96 - POW32 }>, BoundedInt<0, { POW32 - 1 }>,
> {
    type Result = u96;
}

impl AddHelperTo128By64Impl of AddHelper<
    BoundedInt<0, { POW128 - POW64 }>, BoundedInt<0, { POW64 - 1 }>,
> {
    type Result = BoundedInt<0, { POW128 - 1 }>;
}

impl AddHelperTo128By96Impl of AddHelper<BoundedInt<0, { POW128 - POW96 }>, u96> {
    type Result = BoundedInt<0, { POW128 - 1 }>;
}

#[derive(Copy, Clone, Drop)]
struct u288 {
    limb0: u96,
    limb1: u96,
    limb2: u96,
}

#[inline(always)]
pub fn felt252_to_two_u96(value: felt252) -> (u96, u96) {
    match u128s_from_felt252(value) {
        U128sFromFelt252Result::Narrow(low) => {
            let (limb1_low32, limb0) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            let limb1: u96 = upcast(limb1_low32);
            (limb0, limb1)
        },
        U128sFromFelt252Result::Wide((
            high, low,
        )) => {
            let (limb1_low32, limb0) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            let limb1_high64: BoundedInt<0, { POW64 - 1 }> = downcast(high).unwrap();
            let limb1 = bounded_int::add(bounded_int::mul(limb1_high64, POW32_TYPED), limb1_low32);
            (limb0, limb1)
        },
    }
}

// 3  felts for 2 u288 = 1.5 felts / u288 instead of 3 felts / u288.

#[inline(always)]
pub fn downcast_double_u288(v1: felt252, v2: felt252, v3: felt252) -> (u288, u288) {
    let (v1_low_96, v1_mid_96) = felt252_to_two_u96(v1);
    let (v1_high_96, v2_low_96) = felt252_to_two_u96(v2);
    let (v2_mid_96, v2_high_96) = felt252_to_two_u96(v3);

    return (
        u288 { limb0: v1_low_96, limb1: v1_mid_96, limb2: v1_high_96 },
        u288 { limb0: v2_low_96, limb1: v2_mid_96, limb2: v2_high_96 },
    );
}

#[inline(always)]
fn downcast_u288(l0: felt252, l1: felt252, l2: felt252) -> u288 {
    u288 {
        limb0: downcast(l0).unwrap(), limb1: downcast(l1).unwrap(), limb2: downcast(l2).unwrap(),
    }
}

#[inline(always)]
fn downcast_u384(l0: felt252, l1: felt252, l2: felt252, l3: felt252) -> u384 {
    u384 {
        limb0: downcast(l0).unwrap(),
        limb1: downcast(l1).unwrap(),
        limb2: downcast(l2).unwrap(),
        limb3: downcast(l3).unwrap(),
    }
}

#[inline(always)]
fn downcast_u384_2(l01: felt252, l23: felt252) -> u384 {
    let (l0, l1) = felt252_to_two_u96(l01);
    let (l2, l3) = felt252_to_two_u96(l23);
    u384 { limb0: l0, limb1: l1, limb2: l2, limb3: l3 }
}


#[test]
fn test_double_downcast_u288() {
    let value = 0x1000000000456_felt252;
    let _ = downcast_u288(value, value, value);
    let _ = downcast_u288(value, value, value);
}
#[test]
fn test_double_downcast_u288_2() {
    let value = 0x10000000000000000000000000456_felt252;
    let (_, _) = downcast_double_u288(value, value, value);
}

#[test]
fn test_downcast_u384() {
    let value = 0x10000000000000456_felt252;
    let _ = downcast_u384(value, value, value, value);
}

#[test]
fn test_downcast_u384_2() {
    let value = 0x10000000000000000000000000456_felt252;
    let _ = downcast_u384_2(value, value);
}

