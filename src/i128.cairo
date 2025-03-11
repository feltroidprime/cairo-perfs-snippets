pub const MULTIPLIER: i128 = 100_000000_i128;
pub const ONE: i128 = MULTIPLIER;

#[inline(always)]
pub fn mul_128(a: i128, b: i128) -> i128 {
    (a * b) / MULTIPLIER
}

#[inline(always)]
pub fn mul_i128(a: i128, b: i128) -> i128 {
    (a * b)
}

#[inline(always)]
pub fn div_128(a: i128, b: NonZero<i128>) -> i128 {
    (a * MULTIPLIER) / b.into()
}


#[cfg(test)]
mod tests {
    use super::{mul_128, mul_i128};
    #[test]
    fn test_mul_128() {
        let _ = mul_128(100_000000_i128, -100_000000_i128);
    }
    #[test]
    fn test_mul_i128() {
        let _ = mul_i128(100_000000_i128, -100_000000_i128);
    }
}
