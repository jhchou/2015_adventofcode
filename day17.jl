using Combinatorics

containers = parse.(Int, readlines("data/day17.txt"))

# All different combinations of containers that sum to 150
options = [c for c in combinations(containers) if sum(c) == 150]

# Part 1: the number of different options
part1 = length(options)

# Part 2: of the different options, the number of ways that use the fewest number of containers
num_used = length.(options) # number of containers used in each option
part2 = sum(num_used .== minimum(num_used)) # number of options that use the minimum number

println("Part 1: $part1") # Part 1: 4372
println("Part 2: $part2") # Part 2: 4