using JSON

line = readline("data/day12.txt")

# Part 1
reduce(+, map(x -> parse.(Int, x.match), eachmatch(r"(-*\d+)", line))) # Part 1: 111754

# Part 2
function sum_json(j)
    if j isa Number
        return j
    elseif j isa Vector
        return reduce(+, map(sum_json, j))
    elseif j isa Dict
        if "red" in values(j)
            return 0
        else
            return reduce(+, map(sum_json, values(j)))
        end
    else # String
        return 0
    end
end

sum_json(JSON.parse(line)) # Part 2: 65402
