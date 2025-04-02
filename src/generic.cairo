#[derive(Drop)]
struct Felt<T> {
    value: T,
}

fn hash_felt_u32_span(span: Span<Felt<u32>>, s0: felt252) -> felt252 {
    return (s0 + (*span[0].value).into());
}
fn hash_felt_u64_span(span: Span<Felt<u64>>, s0: felt252) -> felt252 {
    return (s0 + (*span[0].value).into());
}


trait HashSpan<T> {
    fn hash_span(span: Span<Felt<T>>, s0: felt252) -> felt252;
}

impl HashSpanU32 of HashSpan<u32> {
    fn hash_span(span: Span<Felt<u32>>, s0: felt252) -> felt252 {
        return hash_felt_u32_span(span, s0);
    }
}

impl HashSpanU64 of HashSpan<u64> {
    fn hash_span(span: Span<Felt<u64>>, s0: felt252) -> felt252 {
        return hash_felt_u64_span(span, s0);
    }
}

#[derive(Drop)]
struct FF<T>{
    num: Span<Felt<T>>,
    den: Span<Felt<T>>,
}

fn do_stuff<T, +HashSpan<T>>(ff: FF<T>, s0:felt252)->felt252{
    let n0 = ff.update_hash_state(s0);
    return n0;
}

#[generate_trait]
impl FFImpl<T, +HashSpan<T>> of FFTrait<T> {
    fn validate_degrees(self: @FF<T>) {
        assert((*self.num).len() <= 10, 'num wrong degree');
        assert((*self.den).len() <= 10, 'den wrong degree');
    }

    fn update_hash_state(
        self: @FF<T>, s0: felt252,
    ) -> felt252 {
        let n0 = HashSpan::hash_span(*self.num, s0);
        let d0 = HashSpan::hash_span(*self.den, s0);
        return n0 + d0;
    }
}

#[test]
fn test_do_stuff() {
    let span = array![Felt { value: 1_u32 }, Felt { value: 2_u32 }, Felt { value: 3_u32 }].span();
    let ff = FF { num: span, den: span };
    let s0 = 0;
    let n0 = do_stuff(ff, s0);
    println!("n0: {}", n0);
}