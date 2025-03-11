#[cfg(test)]
mod tests {
    #[derive(Copy, Drop)]
    struct BigStruct {
        a: felt252,
        b: felt252,
        c: felt252,
        d: felt252,
        e: felt252,
        f: felt252,
        g: felt252,
        h: felt252,
        i: felt252,
        j: felt252,
    }
    #[derive(Drop)]
    struct BigStruct2 {
        a: BigStruct,
        b: Array<felt252>,
        d: BigStruct,
        e: felt252,
    }

    #[inline(never)]
    fn get_big_struct() -> BigStruct2 {
        BigStruct2 {
            a: BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 },
            b: array![1, 2, 3],
            d: BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 },
            e: 11,
        }
    }
    #[inline(never)]
    fn sum_all_big_structs(a: BigStruct2) -> felt252 {
        a.a.a + a.a.b
    }

    #[inline(always)]
    fn get_big_struct_inlined() -> BigStruct2 {
        BigStruct2 {
            a: BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 },
            b: array![1, 2, 3],
            d: BigStruct { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 },
            e: 11,
        }
    }
    #[inline(always)]
    fn sum_all_big_structs_inlined(a: BigStruct2) -> felt252 {
        a.a.a + a.a.b
    }

    #[test]
    fn test_mut_init_1() {
        let mut _a = get_big_struct();
        let sum = sum_all_big_structs(_a);
        assert(sum != 0, '_a is not initialized');
    }

    #[test]
    fn test_mut_init_2() {
        let mut _a = get_big_struct();
        _a.a.a = 10;
        let sum = sum_all_big_structs(_a);
        assert(sum != 0, '_a is not initialized');
    }

    #[test]
    fn test_mut_init_1_inlined() {
        let mut _a = get_big_struct_inlined();
        let sum = sum_all_big_structs_inlined(_a);
        assert(sum != 0, '_a is not initialized');
    }
    #[test]
    fn test_mut_init_2_inlined() {
        let mut _a = get_big_struct_inlined();
        _a.a.a = 10;
        let sum = sum_all_big_structs_inlined(_a);
        assert(sum != 0, '_a is not initialized');
    }
}
