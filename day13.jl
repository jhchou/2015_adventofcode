using DataStructures # for DefaultDict
using Combinatorics  # for permuations()

function day13(inputfile = "data/day13.txt"; part2 = false)
    graph = DefaultDict{Tuple{String, String}, Int}(0)
    names_set = Set{String}()

    lines = readlines(inputfile)
    for line in lines
        line = replace(line, "gain " => "", "lose " => "-")
        m = match(r"(.+) would (-*\d+) happiness units by sitting next to (.+)\.", line)
        # add cost in both directions, with DefaultDict setting initially to 0
        graph[m.captures[1], m.captures[3]] += parse(Int, m.captures[2])
        graph[m.captures[3], m.captures[1]] += parse(Int, m.captures[2])
        push!(names_set, m.captures[1]) # must be a better way to get an array of unique names
        push!(names_set, m.captures[3])
    end

    names = sort(unique(names_set))
    part2 && push!(names, "Dummy")
    
    best_cost = -999999
    best_path = Vector{String}()
    for seating in permutations(names[2:end])
        # start from name[1] and brute force all subsequent orders, which then loops back to name[1]
        cycle = [names[1]; seating; names[1]]
        cost = 0
        for i in 1:length(cycle) - 1
            cost += graph[cycle[i], cycle[i+1]]
            # cost += graph[cycle[i+1], cycle[i]]
        end
        if cost > best_cost
            best_cost = cost
            best_path = cycle
        end
    end
    
    return (best_cost, best_path)
end


day13() # Part 1: 709
day13(part2 = true) # Part 2: 668



##### Failing once again to use Concorde, which is really only meant for symmetric TSP
# https://rdrr.io/cran/TSP/man/reformulate_ATSP_as_TSP.html
# To reformulate the ATSP as a TSP, add a dummy city for each city
# - distance between each city and its dummy city is set very low (-Inf)
# - each city is responsible for the distance going to the city
# - the dummy city is responsible for the distance coming from the city
# - distances between all cities and between all dummy cities are set very high (+Inf)

# using Concorde
# matrix = zeros(Int, length(names)*2, length(names)*2)
# matrix .= +99999
# names = [names; names .* "*"]
# i2n = Dict(collect(enumerate(names)))
# n2i = Dict([(v, k) for (k, v) in i2n])
# for i in 1:length(names)
#     matrix[i, i+length(names)] = -10000
#     matrix[i+length(names), i] = -10000
#     matrix[i, i] = -10000
# end
# for ((source, dest), dist) in graph
#     i_source = n2i[source] + length(names)
#     i_dest = n2i[dest]
#     matrix[i_source, i_dest] = dist
#     matrix[i_dest, i_source] = dist
# end
# matrix
# opt_tour, opt_len = solve_tsp(matrix)
# t = [x <= 8 ? x : x-8 for x in opt_tour]
# [i2n[i] for i in t]
