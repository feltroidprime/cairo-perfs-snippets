#[cfg(test)]
mod tests {
    use core::circuit::conversions::{
        AddHelperTo128By64Impl, AddHelperTo128By96Impl, AddHelperTo96By32Impl, DivRemU96By32,
        DivRemU96By64, MulHelper32By96Impl, MulHelper64By32Impl, MulHelper64By64Impl,
        NZ_POW32_TYPED, NZ_POW64_TYPED, POW64_TYPED, POW96_TYPED, upcast,
    };
    use core::circuit::u384;
    use core::internal::bounded_int;


    #[inline(never)]
    pub fn do_with_u384(value: u384) -> felt252 {
        return value.limb0.into() + value.limb1.into() + value.limb2.into() + value.limb3.into();
    }

    #[test]
    fn test_do_with_u384() {
        let v: u256 = 0x12781278217821781278126871;
        let v = v * 2;
        let v_felt252 = do_with_u384(v.into());
        assert(v_felt252 != 0, 'no');
    }
    pub fn into_u256(value: u384) -> u256 {
        let (_, limb2_low) = bounded_int::div_rem(value.limb2, NZ_POW64_TYPED);
        let (limb1_high, limb1_low) = bounded_int::div_rem(value.limb1, NZ_POW32_TYPED);
        u256 {
            high: upcast(bounded_int::add(bounded_int::mul(limb2_low, POW64_TYPED), limb1_high)),
            low: upcast(bounded_int::add(bounded_int::mul(limb1_low, POW96_TYPED), value.limb0)),
        }
    }

    pub fn try_into_u256(value: u384) -> Option<u256> {
        if value.limb3 != 0 {
            return Option::None;
        }
        let (limb2_high, limb2_low) = bounded_int::div_rem(value.limb2, NZ_POW64_TYPED);
        if limb2_high != 0 {
            return Option::None;
        }
        let (limb1_high, limb1_low) = bounded_int::div_rem(value.limb1, NZ_POW32_TYPED);
        Option::Some(
            u256 {
                high: upcast(
                    bounded_int::add(bounded_int::mul(limb2_low, POW64_TYPED), limb1_high),
                ),
                low: upcast(
                    bounded_int::add(bounded_int::mul(limb1_low, POW96_TYPED), value.limb0),
                ),
            },
        )
    }
    #[test]
    fn test_u384_to_u256() {
        let v_u384 = u384 { limb0: 0x1234567890abcdef, limb1: 0, limb2: 0, limb3: 0 };
        let v_u256 = try_into_u256(v_u384).unwrap();
        assert(v_u256 != 0, 'no');
    }

    #[test]
    fn test_into_u256() {
        let v_u384 = u384 { limb0: 0x1234567890abcdef, limb1: 0, limb2: 0, limb3: 0 };
        let v_u256 = into_u256(v_u384);
        assert(v_u256 != 0, 'no');
    }
    #[test]
    fn test_u384_circuit_output_to_u256() {
        let x = u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0x1, high: 0x0 }));
        let x = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0x0, high: 0x0 }));
        let x = u384 { limb0: 0xc77661, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0xc77661, high: 0x0 }));
        let x = u384 { limb0: 0xa1f1ae97, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0xa1f1ae97, high: 0x0 }));

        let x = u384 { limb0: 0x6dbd0f5925f2ea8792be851d, limb1: 0x60, limb2: 0x0, limb3: 0x0 };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0x606dbd0f5925f2ea8792be851d, high: 0x0 }));

        let x = u384 { limb0: 0x288ad273930c8e07bee0b040, limb1: 0x9a80, limb2: 0x0, limb3: 0x0 };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0x9a80288ad273930c8e07bee0b040, high: 0x0 }));

        let x = u384 {
            limb0: 0x79f59cab560d347406f8f978, limb1: 0x32355e68, limb2: 0x0, limb3: 0x0,
        };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0x32355e6879f59cab560d347406f8f978, high: 0x0 }));

        let x = u384 {
            limb0: 0xf7c12fd7cd43a2091356f287, limb1: 0x5670d3784d, limb2: 0x0, limb3: 0x0,
        };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0x70d3784df7c12fd7cd43a2091356f287, high: 0x56 }));

        let x = u384 {
            limb0: 0x4def54e61b4eee26c407edc8, limb1: 0x6a3d1d0cac6d, limb2: 0x0, limb3: 0x0,
        };
        let y = try_into_u256(x);
        assert_eq!(y, Option::Some(u256 { low: 0x1d0cac6d4def54e61b4eee26c407edc8, high: 0x6a3d }));

        let x = u384 {
            limb0: 0xa666c4bd0b0f6ac7bfc6697,
            limb1: 0x55354b07685a19836f45e3,
            limb2: 0x0,
            limb3: 0x0,
        };
        let y = try_into_u256(x);
        assert_eq!(
            y,
            Option::Some(u256 { low: 0x836f45e30a666c4bd0b0f6ac7bfc6697, high: 0x55354b07685a19 }),
        );

        let x = u384 {
            limb0: 0xf99e6e4a89d4c4bf4eeb5764,
            limb1: 0xba69422bccfb0bf07a497f6b,
            limb2: 0x0,
            limb3: 0x0,
        };
        let y = try_into_u256(x);
        assert_eq!(
            y,
            Option::Some(
                u256 { low: 0x7a497f6bf99e6e4a89d4c4bf4eeb5764, high: 0xba69422bccfb0bf0 },
            ),
        );

        let x = u384 {
            limb0: 0xa18fd325c835625f53342a9f,
            limb1: 0x3f862f6ff3d3c356f4262ef4,
            limb2: 0xda,
            limb3: 0x0,
        };
        let y = try_into_u256(x);
        assert_eq!(
            y,
            Option::Some(
                u256 { low: 0xf4262ef4a18fd325c835625f53342a9f, high: 0xda3f862f6ff3d3c356 },
            ),
        );

        let x = u384 {
            limb0: 0x4332f4d7188cef59cbdef8db,
            limb1: 0xbb3e59509bf71bec4abd71f1,
            limb2: 0x4bb761b32d048,
            limb3: 0x0,
        };
        let y = try_into_u256(x);
        assert_eq!(
            y,
            Option::Some(
                u256 {
                    low: 0x4abd71f14332f4d7188cef59cbdef8db, high: 0x4bb761b32d048bb3e59509bf71bec,
                },
            ),
        );
    }
}
