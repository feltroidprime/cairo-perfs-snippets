// Those two are strictly equivalent in cost and the best way to iterate over an array.
fn for_loop(array: Array<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    for i in array {
        sum += i + 1;
    };
    return sum;
}

fn while_let(mut array: Array<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    while let Option::Some(i) = array.pop_front() {
        sum += i + 1;
    };
    return sum;
}


#[cfg(test)]
mod tests {
    use super::{for_loop, while_let};
    #[test]
    fn test_for_loop() {
        let _ = for_loop(array![1, 2, 3, 4]);
    }
    #[test]
    fn test_while_let() {
        let _ = while_let(array![1, 2, 3, 4]);
    }
}
