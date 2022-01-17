using Combinatorics

# lines = split("""London to Dublin = 464
# London to Belfast = 518
# Dublin to Belfast = 141""", "\n")

lines = readlines("data/day9.txt")

graph = Dict{Tuple{String, String}, Int}()
names = Set{String}()
for line in lines
    m = match(r"(.*) to (.*) = (.*)", line)
    name1 = m.captures[1]
    name2 = m.captures[2]
    push!(names, name1)
    push!(names, name2)
    dist = parse(Int, m.captures[3])
    graph[name1, name2] = dist
    graph[name2, name1] = dist
end

shortest_dist = 999999999
shortest_path = Vector{String}()
longest_dist = 0
longest_path = Vector{String}()

for path in permutations(collect(names))
    dist = 0
    for i in 1:length(path) - 1
        dist += graph[path[i], path[i+1]]
    end
    if dist < shortest_dist
        shortest_path = path
        shortest_dist = dist
    end
    if dist > longest_dist
        longest_path = path
        longest_dist = dist
    end
end

shortest_path
println("Part 1: ", shortest_dist) # Part 1: 251

longest_path
println("Part 2: ", longest_dist) # Part 2: 898






##### Using TSP solver wrapper, only for Part 1 shortest path
# - requires separate installation of Concorde
using Concorde

# Need dummy city with distance 0 to all cities, because TSP is a cycle returning to start
n = collect(names)
push!(n, "Dummy")
num = length(n)

i2n = Dict(collect(enumerate(n))) # Dict of index --> name
n2i = Dict([(n, i) for (i, n) in enumerate(n)]) # Dict of name --> index

distance = zeros(Int64, num, num)
# graph must be complete with all pairwise distances existing, or will fail. Otherwise:
# 1) initialize all distance to Inf
# 2) add edge distances, in both directions
# 3) set diagonals to 0
# 4) set dummy city distances to 0
for ((n1, n2), d) in graph
    distance[n2i[n1], n2i[n2]] = d
    distance[n2i[n2], n2i[n1]] = d
end

opt_tour, opt_len = solve_tsp(distance)

# opt_tour -- indices of path
[i2n[i] for i in opt_tour] # need to start at Dummy (and cycle back to dummy)
opt_len
