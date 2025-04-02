// Those two are strictly equivalent in cost and the best way to iterate over an array.
fn for_loop(array: Array<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    for i in array {
        sum += i + 1;
    }
    return sum;
}

fn while_let(mut array: Array<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    while let Option::Some(i) = array.pop_front() {
        sum += i + 1;
    }
    return sum;
}


#[inline(never)]
fn sum_product_1(p: Span<felt252>, q: Span<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    let mut q = q;
    for i in p {
        sum = sum + (*i) * (*q.pop_front().unwrap());
    }
    return sum;
}
#[inline(never)]
fn sum_product_2(p: Span<felt252>, q: Span<felt252>) -> felt252 {
    let mut sum: felt252 = 0;
    for i in 0..p.len() {
        sum = sum + (*p[i]) * (*q[i]);
    }
    return sum;
}
#[test]
fn test_sum_product_1() {
    let z = sum_product_1(array![1, 2, 3, 4].span(), array![1, 2, 3, 4].span());
    assert(z != 0, 'z')
}
#[test]
fn test_sum_product_2() {
    let z = sum_product_2(array![1, 2, 3, 4].span(), array![1, 2, 3, 4].span());
    assert(z != 0, 'z')
}


#[test]
fn test_for_loop() {
    let z = for_loop(array![1, 2, 3, 4]);
    assert(z != 0, 'z')
}
#[test]
fn test_while_let() {
    let z = while_let(array![1, 2, 3, 4]);
    assert(z != 0, 'z')
}


#[test]
fn test_modulo() {
    let mut index = 0_u32;
    while index != 2390_u32 {
        let _ = index & 1;
        index += 1;
    }
}
#[test]
fn test_bitwise() {
    let mut index = 0_u32;
    while index < 2390_u32 {
        let _ = index & 1;
        index += 1;
    }
}
