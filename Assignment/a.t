Input: List of items (each with a weight w_i), Integer capacity C per bin
Output: Minimum number of bins used, and the assignment of items to bins.
 
// Optional: Sorting items by weight in descending order can potentially improve pruning efficiency
// by reaching solutions with fewer bins (or proving paths are non-optimal) faster in some cases.
// items_sorted = sort items by weight in descending order
 
function BruteForceBinPack(items, capacity):
    // Initialize global variables to track the best solution found
    n = length(items)
    min_bins_found = infinity
    best_bin_arrangement = null
    initial_empty_bins = []
 
    // Recursive helper function
    // item_index: index of the item currently being placed
    // current_bins: the state of bins in this path of recursion
    function solve_recursive(item_index, current_bins):
        nonlocal min_bins_found, best_bin_arrangement
 
        // Pruning 1: If current number of bins >= best_found, stop
        current_num_bins_in_use = count_non_empty_bins(current_bins)
        if current_num_bins_in_use >= min_bins_found:
            return
 
        // Base Case: All items have been placed
        if item_index == n:
            if current_num_bins_in_use < min_bins_found:
                min_bins_found = current_num_bins_in_use
                best_bin_arrangement = deep_copy(current_bins)
            return
 
        current_item = items[item_index] // Or items_sorted[item_index] if pre-sorted
 
        // Recursive Step:
        // Option 1: Try placing current_item in an existing bin
        for i from 0 to length(current_bins) - 1:
            bin = current_bins[i]
            if bin.can_add(current_item.weight, capacity):
                bin.add_item(current_item)
                solve_recursive(item_index + 1, current_bins)
                bin.remove_item(current_item) // Backtrack
 
        // Option 2: Try placing current_item in a new bin
        // Pruning 2: Only open a new bin if doing so could lead to a better solution
        // and the total number of bins does not exceed n.
        if length(current_bins) < n: // Cannot use more than n bins
            // A more aggressive prune would be: (current_num_bins_in_use + 1 < min_bins_found)
            new_bin = create_new_bin_object()
            new_bin.add_item(current_item)
            current_bins.append(new_bin)
            solve_recursive(item_index + 1, current_bins)
            current_bins.pop() // Backtrack
     
    solve_recursive(0, initial_empty_bins)
    return min_bins_found, best_bin_arrangement
 
// Helper functions assumed:
// count_non_empty_bins(bins_list): returns number of bins with items
// deep_copy(bins_list): creates a completely independent (deep) copy
// bin.can_add(item_weight, capacity): checks if item fits (remaining capacity >= item_weight)
// bin.add_item(item): adds item, updates bin's remaining capacity
// bin.remove_item(item): removes item, restores bin's remaining capacity
// create_new_bin_object(): returns a new empty bin object




function BruteForceBinPack(items, capacity):
    // Initialize global variables to track the best solution found
    min_bins_found = infinity
    best_bin_arrangement = null
    n = length(items)
 
    // Recursive helper function
    // current_item_index: index of the item currently being placed
    // current_bins: the state of bins in this path of recursion
    function solve_recursive(current_item_index, current_bins):
        nonlocal min_bins_found, best_bin_arrangement
         // Base Case: All items have been placed
        if current_item_index == n:
            num_used_bins = count_non_empty_bins(current_bins)
            if num_used_bins < min_bins_found:
                min_bins_found = num_used_bins
                best_bin_arrangement = deep_copy(current_bins) // Save the best arrangement
            return // End this recursive path
        // Pruning: If the current number of bins already exceeds the best found, stop exploring this path
        if count_non_empty_bins(current_bins) >= min_bins_found:
            return
        current_item_weight = items[current_item_index].weight
        // Recursive Step 1: Try placing the current item in existing bins
        for bin in current_bins:
            if bin.can_add(current_item_weight, capacity): // Check if item fits
                bin.add_item(current_item_weight) // Place item
                solve_recursive(current_item_index + 1, current_bins) // Recurse for the next item
                bin.remove_item(current_item_weight) // Backtrack: remove item to try other options
        // Recursive Step 2: Try placing the current item in a new bin
        // Optimization: Only open a new bin if it's potentially better than the current best
        // (A simpler version might always try a new bin if fewer than n bins are open)
        if count_non_empty_bins(current_bins) < min_bins_found: // Or simply < n
             new_bin = create_new_bin()
             new_bin.add_item(current_item_weight)
             add_bin(current_bins, new_bin)
             solve_recursive(current_item_index + 1, current_bins)
             remove_bin(current_bins, new_bin) // Backtrack
    // Initial call to start the recursion
    initial_empty_bins = []
    solve_recursive(0, initial_empty_bins)
    return min_bins_found, best_bin_arrangement

// Helper functions assumed:
// count_non_empty_bins(bins_list): returns number of bins with items
// remove_bin(bins_list, bin): removes bin from bins_list
// add_bin(bins_list, bin): adds bin to bins_list
// deep_copy(bins_list): creates a completely independent copy
// bin.can_add(item_weight, capacity): checks if item fits
// bin.add_item(item_weight): adds item, updates remaining capacity
// bin.remove_item(item_weight): removes item, restores capacity
// create_new_bin(): returns a new empty bin object



Input: List of items_with_weights (e.g., list of (item_id, weight) tuples), Integer capacity C per bin
Output: Number of bins used, (Optional) assignment of items to bins.
 
function FirstFitDecreasing(items_with_weights, capacity):
    // Step 1: Sort items by weight in descending order
    sorted_items = sort items_with_weights by weight descending
 
    bins_remaining_capacity = [] // Stores remaining capacity of each used bin
    bin_assignments = []         // Optional: Stores list of item IDs for each bin
    num_bins_used = 0
 
    // Step 2: Apply First Fit logic to sorted items
    for each (item_id, item_weight) in sorted_items:
        placed_in_existing_bin = false
         
        // Find the first bin the item fits into.
        // This inner loop can be optimized (see Section 2.4 Data Structure).
        for bin_index from 0 to num_bins_used - 1:
            if item_weight <= bins_remaining_capacity[bin_index]:
                bins_remaining_capacity[bin_index] -= item_weight
                if tracking_assignments:
                    bin_assignments[bin_index].append(item_id)
                placed_in_existing_bin = true
                break // Move to the next item once placed
         
        if not placed_in_existing_bin:
            num_bins_used += 1
            bins_remaining_capacity.append(capacity - item_weight)
            if tracking_assignments:
                bin_assignments.append([item_id])
     
    return num_bins_used, bin_assignments




function FirstFitDecreasing(items_with_weights, capacity):
    // Input: List of (item_id, weight) tuples
    // Output: Number of bins used, (Optional) assignment of items to bins
    // Step 1: Sort items by weight in descending order
    sorted_items = sort items_with_weights by weight descending
    bins_remaining_capacity = // Stores remaining capacity of each used bin
    bin_assignments =         // Optional: Stores list of item IDs for each bin
    num_bins_used = 0
    // Step 2: Apply First Fit logic to sorted items
    for each (item_id, item_weight) in sorted_items:
        placed = false
        // Find the first bin the item fits into
        for bin_index from 0 to num_bins_used - 1:
            if item_weight <= bins_remaining_capacity[bin_index]:
                // Place item in this bin
                bins_remaining_capacity[bin_index] -= item_weight
                if tracking assignments:
                    bin_assignments[bin_index].append(item_id)
                placed = true
                break // Move to the next item once placed
        // If item didn't fit in any existing bin, open a new one
        if not placed:
            num_bins_used += 1
            bins_remaining_capacity.append(capacity - item_weight)
            if tracking assignments:
                // Start assignment list for the new bin
                bin_assignments.append([item_id])
    // Return total bins and the packing details
    return num_bins_used, bin_assignments
