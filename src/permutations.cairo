#[cfg(test)]
mod tests {
    use core::poseidon::hades_permutation;
    use core::poseidon::PoseidonTrait;
    use core::hash::HashStateTrait;


    #[test]
    fn test_permutation() {
        let (_, _, _) = hades_permutation(10, 20, 2);
    }
    #[test]
    fn test_hash_trait() {
        let mut hash_state = PoseidonTrait::new();
        let _ = hash_state.update(10).update(20).finalize();
    }
}
