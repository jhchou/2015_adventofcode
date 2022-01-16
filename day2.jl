using Combinatorics

lines = readlines("data/day2.txt")

total_paper = 0
total_ribbon = 0
for line in lines
    m = match(r"(\d+)x(\d+)x(\d+)", line)
    dims = parse.(Int, m.captures) # 3 dimensions
    prods = combinations(dims,2) |> collect .|> prod # all pairwise products
    perims = combinations(dims,2) |> collect .|> sum .|> x -> 2x # perimeters of each face
    total_paper += 2 * sum(prods) + minimum(prods) # total area + minimum product
    total_ribbon += minimum(perims) + prod(dims)   # smallest perimeter + cubic volume
end

total_paper  # Part 1: 1586300
total_ribbon # Part 2: 3737498
