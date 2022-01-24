using Combinatorics

# Not bothering to check that remainder is also splittable to thirds, but should.

function day24(; part2 = false)
    lines = parse.(Int, readlines("data/day24.txt"))
    goal = part2 ? sum(lines) ÷ 4 : sum(lines) ÷ 3
    poss = Vector{Vector{Int64}}()
    fewest = 0
    shortest_not_found = true
    while shortest_not_found
        fewest += 1
        for x in combinations(lines, fewest)
            if sum(x) != goal continue end
            shortest_not_found = false
            push!(poss, x)
        end
    end
    return minimum(reduce.(*, poss))
end

day24() # part 1: 10723906903
day24(part2 = true) # part 2: 74850409
