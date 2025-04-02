#[cfg(test)]
mod tests {
    use core::hash::HashStateTrait;
    use core::poseidon::{PoseidonTrait, hades_permutation};


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
