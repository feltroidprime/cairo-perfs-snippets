fn main_0(array: Array<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    for i in array {
        sum += i + 1;
    };
    return sum;
}

fn main_1(mut array: Array<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    while let Option::Some(i) = array.pop_front() {
        sum += i + 1;
    };
    return sum;
}


#[cfg(test)]
mod tests {
    use super::{main_0, main_1};
    #[test]
    fn test_main_0() {
        let _ = main_0(array![1, 2, 3, 4]);
    }
    #[test]
    fn test_main_1() {
        let _ = main_1(array![1, 2, 3, 4]);
    }
}
