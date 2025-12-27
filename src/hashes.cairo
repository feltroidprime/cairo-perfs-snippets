// use core::poseidon::hades_permutation;

// #[test]
// fn test_hashes() {
//     let (s0, s1, s2) = hades_permutation(10, 20, 2);
//     assert(s0 != 0, 's0');
//     assert(s1 != 0, 's1');
//     assert(s2 != 0, 's2');
// }

// // Blake2s hash example
// use core::blake::{Blake2sInput, Blake2sState, blake2s_finalize};
// #[test]
// fn test_blake2s_with_abc() {
//     // hashing `abc` as it is done in RFC 7693 Appendix B.
//     // Initial state is the IV, with keylen 0 and output length 32.
//     let state = BoxTrait::new(
//         [
//             0x6b08e647, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB,
//             0x5BE0CD19,
//         ],
//     );
//     // Message `abc` padded with zeros.
//     let msg = BoxTrait::new(['cba', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
//     assert_eq!(
//         blake2s_finalize(state, 3, msg).unbox(),
//         [
//             0x8c5e8c50, 0xe2147c32, 0xa32ba7e1, 0x2f45eb4e, 0x208b4537, 0x293ad69e, 0x4c9b994d,
//             0x82596786,
//         ],
//     );
// }
