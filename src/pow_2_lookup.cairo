// Better. Constant cost 1 RC + 11 steps.
fn pow_2_match(i: u32) -> u128 {
    match i {
        0 => 1,
        1 => 2,
        2 => 4,
        3 => 8,
        4 => 16,
        5 => 32,
        6 => 64,
        7 => 128,
        8 => 256,
        9 => 512,
        10 => 1024,
        11 => 2048,
        12 => 4096,
        13 => 8192,
        14 => 16384,
        15 => 32768,
        16 => 65536,
        _ => 0, // If you put a panic!() here instead of a value, it will have a bigger fixed cost.
    }
}
// Worse. Cost depends on the value of i.
fn pow_2_if(i: u32) -> u128 {
    if i == 0 {
        return 1;
    }
    if i == 1 {
        return 2;
    }
    if i == 2 {
        return 4;
    }
    if i == 3 {
        return 8;
    }
    if i == 4 {
        return 16;
    }
    if i == 5 {
        return 32;
    }
    if i == 6 {
        return 64;
    }
    if i == 7 {
        return 128;
    }
    if i == 8 {
        return 256;
    }
    if i == 9 {
        return 512;
    }
    if i == 10 {
        return 1024;
    }
    if i == 11 {
        return 2048;
    }
    if i == 12 {
        return 4096;
    }
    if i == 13 {
        return 8192;
    }
    if i == 14 {
        return 16384;
    }
    if i == 15 {
        return 32768;
    }
    if i == 16 {
        return 65536;
    }
    return 0;
}

const POW_2_LOOKUP: [
    u128
    ; 17] = [
    1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536,
];

// Best only when passing the span array and accessing index more than 2 times.
fn pow_2_array(i: u32) -> u128 {
    return *POW_2_LOOKUP.span()[i];
}


#[cfg(test)]
mod tests {
    use super::{pow_2_match, pow_2_if, pow_2_array, POW_2_LOOKUP};
    #[test]
    fn test_pow_2_match_16() {
        let _ = pow_2_match(16);
    }
    #[test]
    fn test_pow_2_if_16() {
        let _ = pow_2_if(16);
    }

    #[test]
    fn test_pow_2_match_1() {
        let _ = pow_2_match(1);
    }
    #[test]
    fn test_pow_2_if_1() {
        let _ = pow_2_if(1);
    }
    #[test]
    fn test_pow_2_match_2() {
        let _ = pow_2_match(2);
    }
    #[test]
    fn test_pow_2_if_2() {
        let _ = pow_2_if(2);
    }
    #[test]
    fn test_pow_2_array_16() {
        let _ = pow_2_array(16);
    }
    #[test]
    fn test_pow_2_array_1() {
        let _ = pow_2_array(1);
    }
    #[test]
    fn test_pow_2_array_2() {
        let _ = pow_2_array(2);
    }

    #[test]
    fn test_pow_2_match_1_2_3_4() {
        let _ = pow_2_match(1);
        let _ = pow_2_match(2);
        let _ = pow_2_match(3);
        let _ = pow_2_match(4);
    }
    #[test]
    fn test_pow_2_if_1_2_3_4() {
        let _ = pow_2_if(1);
        let _ = pow_2_if(2);
        let _ = pow_2_if(3);
        let _ = pow_2_if(4);
    }
    #[test]
    fn test_pow_2_array_1_2_3_4() {
        let pow_2_lookup = POW_2_LOOKUP.span();
        let _ = *pow_2_lookup.at(1);
        let _ = *pow_2_lookup.at(2);
        let _ = *pow_2_lookup.at(3);
        let _ = *pow_2_lookup.at(4);
        // Additional access costs 1 RC + 7 steps, cheaper than 11 steps + 1 RC in pow_2_match.
    }
}
