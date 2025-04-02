#[cfg(test)]
mod tests {
    #[derive(Copy, Drop)]
    struct BigStruct {
        a: u64,
        b: u64,
        c: u64,
        d: u64,
        e: u64,
        f: u64,
        g: u64,
        h: u64,
        i: u64,
        j: u64,
    }

    struct BigStruct2 {
        a: BigStruct,
        b: Array<felt252>,
        d: BigStruct,
        e: u256,
    }

    #[inline(never)]
    fn f0() -> Box<BigStruct> {
        let x = BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 };
        let boxed_x = BoxTrait::new(x);
        return boxed_x;
    }
    #[inline(never)]
    fn f0_nobox() -> BigStruct {
        return BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 };
    }
    #[inline(never)]
    fn f1(x: Box<BigStruct>) -> felt252 {
        let a: felt252 = x.unbox().a.into();
        let b: felt252 = x.unbox().b.into();
        return a + b;
    }
    #[inline(never)]
    fn f1_nobox() -> felt252 {
        let x = f0_nobox();
        let a: felt252 = x.a.into();
        let b: felt252 = x.b.into();
        return a + b;
    }

    #[test]
    fn test_box_unbox_f1() {
        let x = f0();
        let z = f1(x);
        assert(z != 0, 'ok')
    }
    #[test]
    fn test_box_unbox_f1_nobox() {
        let z = f1_nobox();
        assert(z != 0, 'ok')
    }
    #[inline(never)]
    fn f2(x: Box<BigStruct>) -> felt252 {
        let unboxed_x = x.unbox();
        let a: felt252 = unboxed_x.a.into();
        let b: felt252 = unboxed_x.b.into();
        return a + b;
    }
    #[test]
    fn test_box_unbox_f2() {
        let x = f0();
        let z = f2(x);
        assert(z != 0, 'ok')
    }
    #[inline(never)]
    fn f3(x: Box<BigStruct>) -> felt252 {
        let unboxed_x = x.unbox();
        let a: felt252 = unboxed_x.a.into();
        let b: felt252 = unboxed_x.b.into();
        let c: felt252 = unboxed_x.c.into();
        let d: felt252 = unboxed_x.d.into();
        return a + b + c + d;
    }
    #[inline(never)]
    fn f4(x: Box<BigStruct>) -> felt252 {
        let unboxed_x = x.unbox();
        let a: felt252 = unboxed_x.a.into();
        let b: felt252 = unboxed_x.b.into();
        let c: felt252 = unboxed_x.c.into();
        let d: felt252 = unboxed_x.d.into();
        let e: felt252 = unboxed_x.e.into();
        return a + b + c + d + e;
    }

    #[inline(never)]
    fn g0() -> Box<BigStruct2> {
        let boxed_x = BoxTrait::new(
            BigStruct2 {
                a: BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 },
                b: array![1, 2, 3],
                d: BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 },
                e: 11,
            },
        );
        return boxed_x;
    }

    #[inline(never)]
    fn g1(x: Box<BigStruct2>) -> felt252 {
        let unboxed_x = x.unbox();
        let a: felt252 = unboxed_x.a.a.into();
        return a;
    }
    #[inline(never)]
    fn g2(x: Box<BigStruct2>) -> felt252 {
        let unboxed_x = x.unbox();
        let a: felt252 = unboxed_x.e.low.into();
        return a;
    }
    #[inline(never)]
    fn g3(x: Box<BigStruct2>) -> felt252 {
        let unboxed_x = x.unbox();
        let a_a: felt252 = unboxed_x.a.a.into();
        let a_b: felt252 = unboxed_x.a.b.into();
        let d_a: felt252 = unboxed_x.d.a.into();
        let d_b: felt252 = unboxed_x.d.b.into();
        return a_a + a_b + d_a + d_b;
    }
    #[inline(always)]
    fn g4(x: Box<BigStruct2>) -> felt252 {
        let unboxed_x = x.unbox();
        let a_a: felt252 = unboxed_x.a.a.into();
        let a_b: felt252 = unboxed_x.a.b.into();
        let a_c: felt252 = unboxed_x.a.c.into();
        let a_d: felt252 = unboxed_x.a.d.into();
        return a_a + a_b + a_c + a_d;
    }
    #[test]
    fn test_box_g() {
        let x = g0();
        assert(x.unbox().a.a != 0, 'ok');
    }
    #[test]
    fn test_box_f() {
        let x = f0();
        assert(x.unbox().a != 0, 'ok');
    }
    #[test]
    fn test_box_unbox_g1() {
        let x = g0();
        let z = g1(x);
        assert(z != 0, 'ok')
    }
    #[test]
    fn test_box_unbox_g2() {
        let x = g0();
        let z = g2(x);
        assert(z != 0, 'ok')
    }
    #[test]
    fn test_box_unbox_g3() {
        let x = g0();
        let z = g3(x);
        assert(z != 0, 'ok')
    }

    #[test]
    fn test_box_unbox_g4() {
        let x = g0();
        let z = g4(x);
        assert(z != 0, 'ok')
    }


    #[test]
    fn test_box_unbox_f3() {
        let x = f0();
        let z = f3(x);
        assert(z != 0, 'ok')
    }

    #[test]
    fn test_box_unbox_f4() {
        let x = f0();
        let z = f4(x);
        assert(z != 0, 'ok')
    }
}
