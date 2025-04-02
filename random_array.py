import random

def generate_random_array(size=20, min_val=-1000, max_val=1000):
    """
    Generate an array of random integers between min_val and max_val.
    
    Args:
        size (int): Number of elements in the array. Default is 20.
        min_val (int): Minimum value (inclusive). Default is -1000.
        max_val (int): Maximum value (inclusive). Default is 1000.
        
    Returns:
        list: Array of random integers
    """
    return [random.randint(min_val, max_val) for _ in range(size)]

# Example usage
if __name__ == "__main__":
    random_array = generate_random_array()
    print(f"Random array of 20 values between -1000 and 1000:")
    print(random_array)
    
    # Statistics about the generated array
    positive_count = sum(1 for x in random_array if x > 0)
    negative_count = sum(1 for x in random_array if x < 0)
    zero_count = sum(1 for x in random_array if x == 0)
    
    print(f"Positive values: {positive_count}")
    print(f"Negative values: {negative_count}")
    print(f"Zero values: {zero_count}") 