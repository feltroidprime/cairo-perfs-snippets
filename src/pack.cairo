use starknet::storage_access::StorePacking;
const TWO_POW_32: felt252 = 0x100000000; // 2^32
const TWO_POW_64: felt252 = 0x10000000000000000; // 2^64
const TWO_POW_64_NZ_128: NonZero<u128> = 0x10000000000000000;

const TWO_POW_32_NZ_128: NonZero<u128> = 0x100000000;
const TWO_POW_32_NZ_64: NonZero<u64> = 0x100000000;

const TWO_POW_96: felt252 = 0x1000000000000000000000000;
const TWO_POW_128: felt252 = 0x100000000000000000000000000000000;
const TWO_POW_131: felt252 = 0x800000000000000000000000000000000; // 2^131


#[derive(Copy, Drop, Debug, PartialEq)]
pub struct FeeRatesV2 {
    pub futures_set: bool,
    pub futures_maker: i32,
    pub futures_taker: i32,
    pub options_set: bool,
    pub options_maker: i32,
    pub options_taker: i32,
}

// Returns a tuple of the sign and absolute value of the i32
// i32 is guaranteed is in [-2^31, 2^31[
// Absolute value is returned as a felt252, guaranteed to be in [0, 2^31]
fn sign_and_abs_i32(value: i32) -> (felt252, felt252) {
    let positive_option: Option<u32> = value.try_into();
    match positive_option {
        // If the value is positive, return a tuple of (1, value)
        Option::Some(_) => { (1, value.into()) },
        // If the value is negative, return a tuple of (0, -value)
        Option::None => { (0, -value.into()) },
    }
}
impl FeeRatesStorePacking of StorePacking<FeeRatesV2, felt252> {
    fn pack(value: FeeRatesV2) -> felt252 {
        let (future_maker_sign, future_maker_abs) = sign_and_abs_i32(value.futures_maker);
        let (future_taker_sign, future_taker_abs) = sign_and_abs_i32(value.futures_taker);
        let (option_maker_sign, option_maker_abs) = sign_and_abs_i32(value.options_maker);
        let (option_taker_sign, option_taker_abs) = sign_and_abs_i32(value.options_taker);

        // 11 => Maker & Taker are positive
        // 10 => Only Maker is positive
        // 01 => Only Taker is positive
        // 00 => Neither are positive
        let info_signs_futures: felt252 = 2 * future_maker_sign + future_taker_sign;
        let info_signs_options: felt252 = 2 * option_maker_sign + option_taker_sign;

        // set_bit (1b) || maker_sign (1b) || taker_sign (1b)
        let info_bits_futures: felt252 = match value.futures_set {
            true => 4 + info_signs_futures,
            false => info_signs_futures,
        };

        // set_bit (1b) || maker_sign (1b) || taker_sign (1b)
        let info_bits_options: felt252 = match value.options_set {
            true => 4 + info_signs_options,
            false => info_signs_options,
        };

        // info_bits_options (3b) || info_bits_futures (3b)
        let high_128_part: felt252 = info_bits_options * TWO_POW_131
            + info_bits_futures * TWO_POW_128;

        // option_maker_abs (32b) || option_taker_abs (32b) || future_maker_abs (32b) ||
        // future_taker_abs (32b)
        let low_128_part: felt252 = option_maker_abs * TWO_POW_96
            + option_taker_abs * TWO_POW_64
            + future_maker_abs * TWO_POW_32
            + future_taker_abs;

        // high: info_bits_options (3b) || info_bits_futures (3b)
        // low:  option_taker_abs (32b) || option_maker_abs (32b) || future_taker_abs (32b) ||
        // future_maker_abs (32b)
        let packed_felt: felt252 = high_128_part + low_128_part;

        packed_felt
    }
    fn unpack(value: felt252) -> FeeRatesV2 {
        let value_u: u256 = value.into();
        let high_128: u128 = value_u.high;
        let low_128: u128 = value_u.low;

        let (info_bits_options, info_bits_futures) = DivRem::div_rem(high_128, 8); // / 2^3
        let (options_set, options_signs) = DivRem::div_rem(info_bits_options, 4); // / 2^2
        let (futures_set, futures_signs) = DivRem::div_rem(info_bits_futures, 4); // / 2^2

        let (options_abs, futures_abs) = DivRem::div_rem(low_128, TWO_POW_64_NZ_128);

        let (futures_set, futures_maker, futures_taker): (bool, i32, i32) = match futures_set {
            0 => (false, 0, 0),
            _ => {
                let futures_abs: u64 = futures_abs.try_into().unwrap();
                let (futures_maker_abs, futures_taker_abs) = DivRem::div_rem(
                    futures_abs, TWO_POW_32_NZ_64,
                );
                let (futures_maker_sign, futures_taker_sign) = DivRem::div_rem(futures_signs, 2);

                let futures_maker_f252: felt252 = match futures_maker_sign {
                    0 => -futures_maker_abs.into(),
                    _ => futures_maker_abs.into(),
                };
                let futures_taker_f252: felt252 = match futures_taker_sign {
                    0 => -futures_taker_abs.into(),
                    _ => futures_taker_abs.into(),
                };
                (
                    true,
                    futures_maker_f252.try_into().unwrap(),
                    futures_taker_f252.try_into().unwrap(),
                )
            },
        };

        let (options_set, options_maker, options_taker): (bool, i32, i32) = match options_set {
            0 => (false, 0, 0),
            _ => {
                let (options_maker_abs, options_taker_abs) = DivRem::div_rem(
                    options_abs, TWO_POW_32_NZ_128,
                );
                let (options_maker_sign, options_taker_sign) = DivRem::div_rem(options_signs, 2);

                let options_maker_f252: felt252 = match options_maker_sign {
                    0 => -options_maker_abs.into(),
                    _ => options_maker_abs.into(),
                };
                let options_taker_f252: felt252 = match options_taker_sign {
                    0 => -options_taker_abs.into(),
                    _ => options_taker_abs.into(),
                };

                (
                    true,
                    options_maker_f252.try_into().unwrap(),
                    options_taker_f252.try_into().unwrap(),
                )
            },
        };

        FeeRatesV2 {
            futures_set: futures_set,
            futures_maker: futures_maker,
            futures_taker: futures_taker,
            options_set: options_set,
            options_maker: options_maker,
            options_taker: options_taker,
        }
    }
}

fn pack() -> felt252 {
    let fee_rates = FeeRatesV2 {
        futures_set: true,
        futures_maker: 100,
        futures_taker: -200,
        options_set: true,
        options_maker: 300,
        options_taker: -400,
    };
    FeeRatesStorePacking::pack(fee_rates)
}

#[test]
fn test_pack_unpack() {
    // let fee_rates = FeeRatesV2 {
    //     futures_set: true,
    //     futures_maker: 100,
    //     futures_taker: -200,
    //     options_set: true,
    //     options_maker: 300,
    //     options_taker: -400,
    // };
    let packed = 18375247837499125788680227709291985895624;
    let _ = FeeRatesStorePacking::unpack(packed);
    // assert(unpacked.futures_set == true, 'e');
}

