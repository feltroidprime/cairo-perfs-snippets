const POW_2_32: u128 = 0x100000000;
const POW_2_64: u128 = 0x10000000000000000;
const POW_2_96: u128 = 0x100000000000000000000;

// Convert 4 u32 to u128
fn main_1(d0: u32, d1: u32, d2: u32, d3: u32) -> u128 {
    let z: u128 = d0.into() + d1.into() * POW_2_32 + d2.into() * POW_2_64 + d3.into() * POW_2_96;
    return z;
}

// Convert 4 u32 to u128
fn main_2(d0: u32, d1: u32, d2: u32, d3: u32) -> u128 {
    let z_252: felt252 = d0.into()
        + d1.into() * POW_2_32.into()
        + d2.into() * POW_2_64.into()
        + d3.into() * POW_2_96.into();
    return z_252.try_into().unwrap();
}

#[cfg(test)]
mod tests {
    use super::{main_1, main_2};
    #[test]
    fn test_main_1() {
        let _ = main_1(1, 2, 3, 4);
    }
    #[test]
    fn test_main_2() {
        let _ = main_2(1, 2, 3, 4);
    }
}
