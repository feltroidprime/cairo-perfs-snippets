use core::circuit::u96;
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

#[inline(never)]
pub fn felt252_try_into_two_u96_circuit(value: felt252) -> Option<(u96, u96)> {
    let v: u256 = value.into();
    let (limb1_low32, limb0) = bounded_int::div_rem(v.low, NZ_POW96_TYPED);
    let limb1_high64: BoundedInt<0, { POW64 - 1 }> = downcast(v.high)?;
    let limb1 = bounded_int::add(bounded_int::mul(limb1_high64, POW32_TYPED), limb1_low32);
    Some((limb0, limb1))
}

#[inline(never)]
pub fn felt252_try_into_two_u96_circuit_2(value: felt252) -> Option<(u96, u96)> {
    match u128s_from_felt252(value) {
        U128sFromFelt252Result::Narrow(low) => {
            let (limb1_low32, limb0) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            let limb1: u96 = upcast(limb1_low32);
            Some((limb0, limb1))
        },
        U128sFromFelt252Result::Wide((
            high, low,
        )) => {
            let (limb1_low32, limb0) = bounded_int::div_rem(low, NZ_POW96_TYPED);

            // // 1.
            // let limb1_f: felt252 = limb1_low32.into() + high.into() * 4294967296;
            // let limb1: u96 = downcast(limb1_f).unwrap();

            // 2.
            let limb1_high64: BoundedInt<0, { POW64 - 1 }> = downcast(high)?;
            let limb1 = bounded_int::add(bounded_int::mul(limb1_high64, POW32_TYPED), limb1_low32);
            Some((limb0, limb1))
        },
    }
}

#[inline(never)]
pub fn felt252_try_into_two_u96_circuit_3(value: felt252) -> Option<(u96, u96)> {
    match u128s_from_felt252(value) {
        U128sFromFelt252Result::Narrow(low) => {
            let (limb1_low32, limb0) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            let limb1: u96 = upcast(limb1_low32);
            Some((limb0, limb1))
        },
        U128sFromFelt252Result::Wide((
            high, low,
        )) => {
            let (_, limb0) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            let (_, limb1) = bounded_int::div_rem(high, NZ_POW96_TYPED);
            Some((limb0, limb1))
        },
    }
}

#[inline(never)]
pub fn felt252_try_into_two_u96_circuit_4(value: felt252) -> Option<(u96, u96)> {
    match u128s_from_felt252(value) {
        U128sFromFelt252Result::Narrow(low) => {
            let (limb1_low32, limb0) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            let limb1: u96 = upcast(limb1_low32);
            Some((limb0, limb1))
        },
        U128sFromFelt252Result::Wide((
            high, low,
        )) => {
            let limb0: u96 = downcast(low).unwrap();
            let limb1: u96 = downcast(high).unwrap();
            Some((limb0, limb1))
        },
    }
}

#[inline(never)]
pub fn felt252_try_into_two_u96_double_downcast(
    limb0: felt252, limb1: felt252,
) -> Option<(u96, u96)> {
    let l0: u96 = downcast(limb0)?;
    let l1: u96 = downcast(limb1)?;
    Some((l0, l1))
}
#[test]
fn test_felt252_try_into_two_u96_circuit_double_downcast() {
    let limb0 = 0x100000000000000456;
    let limb1 = 0x000000000000000456;
    let (l0, l1) = felt252_try_into_two_u96_double_downcast(limb0, limb1).unwrap();
    assert(l0 != 0, 'no');
    assert(l1 != 0, 'no');
}

#[test]
fn test_felt252_try_into_two_u96_circuit() {
    let value = 0x10000000000000000000000000000000000456_felt252;
    let (limb0, limb1) = felt252_try_into_two_u96_circuit(value).unwrap();
    assert(limb0 != 0, 'no');
    assert(limb1 != 0, 'no');
}

#[test]
fn test_felt252_try_into_two_u96_circuit_2() {
    let value = 0x10000000000000000000000000000000000456_felt252;
    let (limb0, limb1) = felt252_try_into_two_u96_circuit_2(value).unwrap();
    assert(limb0 != 0, 'no');
    assert(limb1 != 0, 'no');
}

#[test]
fn test_felt252_try_into_two_u96_circuit_3() {
    let value = 0x10000000000000000000000000000000000456_felt252;
    let (limb0, limb1) = felt252_try_into_two_u96_circuit_3(value).unwrap();
    assert(limb0 != 0, 'no');
    assert(limb1 != 0, 'no');
}
#[test]
fn test_felt252_try_into_two_u96_circuit_4() {
    let value = 0x10000000000000000000000000000000000456_felt252;
    let (limb0, limb1) = felt252_try_into_two_u96_circuit_3(value).unwrap();
    assert(limb0 != 0, 'no');
    assert(limb1 != 0, 'no');
}
#[inline(never)]
pub fn felt252_try_into_two_u96_2(value: felt252) -> Option<(u96, u96)> {
    let v: u256 = value.into();
    let (limb1_low32, limb0) = bounded_int::div_rem(v.low, NZ_POW96_TYPED);
    // let limb1_high64: BoundedInt<0, { POW64 - 1 }> = downcast(v.high)?;
    // let limb1 = bounded_int::add(bounded_int::mul(limb1_high64, POW32_TYPED), limb1_low32);
    let limb1_f: felt252 = limb1_low32.into() + (v.high.into() * POW32);
    let limb1: u96 = downcast(limb1_f)?;
    Some((limb0, limb1))
}

#[test]
fn test_felt252_try_into_two_u96_2() {
    let value = 0x1000000000000000000000000000000456;
    let (limb0, limb1) = felt252_try_into_two_u96_2(value).unwrap();
    assert(limb0 != 0, 'no');
    assert(limb1 != 0, 'no');
}


#[inline(never)]
fn deserialize_36(ref serialized: Span<felt252>) -> [u96; 36] {
    let [
        w0l0,
        w0l1,
        w0l2,
        w1l0,
        w1l1,
        w1l2,
        w2l0,
        w2l1,
        w2l2,
        w3l0,
        w3l1,
        w3l2,
        w4l0,
        w4l1,
        w4l2,
        w5l0,
        w5l1,
        w5l2,
        w6l0,
        w6l1,
        w6l2,
        w7l0,
        w7l1,
        w7l2,
        w8l0,
        w8l1,
        w8l2,
        w9l0,
        w9l1,
        w9l2,
        w10l0,
        w10l1,
        w10l2,
        w11l0,
        w11l1,
        w11l2,
    ] =
        (*serialized
        .multi_pop_front::<36>()
        .unwrap())
        .unbox();

    [
        w0l0.try_into().unwrap(), w0l1.try_into().unwrap(), w0l2.try_into().unwrap(),
        w1l0.try_into().unwrap(), w1l1.try_into().unwrap(), w1l2.try_into().unwrap(),
        w2l0.try_into().unwrap(), w2l1.try_into().unwrap(), w2l2.try_into().unwrap(),
        w3l0.try_into().unwrap(), w3l1.try_into().unwrap(), w3l2.try_into().unwrap(),
        w4l0.try_into().unwrap(), w4l1.try_into().unwrap(), w4l2.try_into().unwrap(),
        w5l0.try_into().unwrap(), w5l1.try_into().unwrap(), w5l2.try_into().unwrap(),
        w6l0.try_into().unwrap(), w6l1.try_into().unwrap(), w6l2.try_into().unwrap(),
        w7l0.try_into().unwrap(), w7l1.try_into().unwrap(), w7l2.try_into().unwrap(),
        w8l0.try_into().unwrap(), w8l1.try_into().unwrap(), w8l2.try_into().unwrap(),
        w9l0.try_into().unwrap(), w9l1.try_into().unwrap(), w9l2.try_into().unwrap(),
        w10l0.try_into().unwrap(), w10l1.try_into().unwrap(), w10l2.try_into().unwrap(),
        w11l0.try_into().unwrap(), w11l1.try_into().unwrap(), w11l2.try_into().unwrap(),
    ]
}


#[test]
fn test_deserialize_36() {
    let mut serialized: Span<felt252> = array![
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
        26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
    ]
        .span();
    let _ = deserialize_36(ref serialized);
    // assert(r1 != 0, 'no');
// assert(r2 != 0, 'no');
// assert(r3 != 0, 'no');
// assert(r4 != 0, 'no');
// assert(r5 != 0, 'no');
// assert(r6 != 0, 'no');
// assert(r7 != 0, 'no');
// assert(r8 != 0, 'no');
// assert(r9 != 0, 'no');
// assert(r10 != 0, 'no');
// assert(r11 != 0, 'no');
// assert(r12 != 0, 'no');
// assert(r13 != 0, 'no');
// assert(r14 != 0, 'no');
// assert(r15 != 0, 'no');
// assert(r16 != 0, 'no');
// assert(r17 != 0, 'no');
// assert(r18 != 0, 'no');
// assert(r19 != 0, 'no');
// assert(r20 != 0, 'no');
// assert(r21 != 0, 'no');
// assert(r22 != 0, 'no');
// assert(r23 != 0, 'no');
// assert(r24 != 0, 'no');
// assert(r25 != 0, 'no');
// assert(r26 != 0, 'no');
// assert(r27 != 0, 'no');
// assert(r28 != 0, 'no');
// assert(r29 != 0, 'no');
// assert(r30 != 0, 'no');
// assert(r31 != 0, 'no');
// assert(r32 != 0, 'no');
// assert(r33 != 0, 'no');
// assert(r34 != 0, 'no');
// assert(r35 != 0, 'no');
// assert(r36 != 0, 'no');

}


#[inline(always)]
pub fn felt192_to_two_u96(value: felt252) -> (u96, u96) {
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
            let limb1_f: felt252 = limb1_low32.into() + high.into() * 4294967296;
            let limb1: u96 = downcast(limb1_f).unwrap();

            // let limb1_high64: BoundedInt<0, { POW64 - 1 }> = downcast(high).unwrap();
            // let limb1 = bounded_int::add(bounded_int::mul(limb1_high64, POW32_TYPED),
            // limb1_low32);
            (limb0, limb1)
        },
    }
}

#[inline(never)]
fn deserialize_36_2(ref serialized: Span<felt252>) -> [u96; 36] {
    let [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18] =
        (*serialized
        .multi_pop_front::<18>()
        .unwrap())
        .unbox();

    let (l1, l2) = felt192_to_two_u96(w1);
    let (l3, l4) = felt192_to_two_u96(w2);
    let (l5, l6) = felt192_to_two_u96(w3);
    let (l7, l8) = felt192_to_two_u96(w4);
    let (l9, l10) = felt192_to_two_u96(w5);
    let (l11, l12) = felt192_to_two_u96(w6);
    let (l13, l14) = felt192_to_two_u96(w7);
    let (l15, l16) = felt192_to_two_u96(w8);
    let (l17, l18) = felt192_to_two_u96(w9);
    let (l19, l20) = felt192_to_two_u96(w10);
    let (l21, l22) = felt192_to_two_u96(w11);
    let (l23, l24) = felt192_to_two_u96(w12);
    let (l25, l26) = felt192_to_two_u96(w13);
    let (l27, l28) = felt192_to_two_u96(w14);
    let (l29, l30) = felt192_to_two_u96(w15);
    let (l31, l32) = felt192_to_two_u96(w16);
    let (l33, l34) = felt192_to_two_u96(w17);
    let (l35, l36) = felt192_to_two_u96(w18);

    [
        l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20,
        l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36,
    ]
}


#[test]
fn test_deserialize_36_2() {
    let mut serialized: Span<felt252> = array![
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
    ]
        .span();
    let _ = deserialize_36_2(ref serialized);
    // assert(r1 != , 'no');
// assert(r2 != 0, 'no');
// assert(r3 != 0, 'no');
// assert(r4 != 0, 'no');
// assert(r5 != 0, 'no');
// assert(r6 != 0, 'no');
// assert(r7 != 0, 'no');
// assert(r8 != 0, 'no');
// assert(r9 != 0, 'no');
// assert(r10 != 0, 'no');
// assert(r11 != 0, 'no');
// assert(r12 != 0, 'no');
// assert(r13 != 0, 'no');
// assert(r14 != 0, 'no');
// assert(r15 != 0, 'no');
// assert(r16 != 0, 'no');
// assert(r17 != 0, 'no');
// assert(r18 != 0, 'no');
// assert(r19 != 0, 'no');
// assert(r20 != 0, 'no');
// assert(r21 != 0, 'no');
// assert(r22 != 0, 'no');
// assert(r23 != 0, 'no');
// assert(r24 != 0, 'no');
// assert(r25 != 0, 'no');
// assert(r26 != 0, 'no');
// assert(r27 != 0, 'no');
// assert(r28 != 0, 'no');
// assert(r29 != 0, 'no');
// assert(r30 != 0, 'no');
// assert(r31 != 0, 'no');
// assert(r32 != 0, 'no');
// assert(r33 != 0, 'no');
// assert(r34 != 0, 'no');
// assert(r35 != 0, 'no');
// assert(r36 != 0, 'no');

}
