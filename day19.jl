using DataStructures

lines = readlines("data/day19.txt")

rxns = DefaultDict{String, Vector{String}}([])
med = ""

for line in lines
    m = match(r"(.*) => (.*)", line)
    if !isnothing(m)
        push!(rxns[m.captures[1]], m.captures[2])
    elseif length(line) != 0
        med = line
    end
end

function all_prods(start, rxns)
    prods = Vector{String}()
    for (source, replacements) in rxns
        matches = findall(source, start)
        for replacement in replacements
            for rng in matches
                idx1 = rng[1]
                idx2 = idx1 + length(source) - 1
                push!(prods, start[1:idx1-1] * replacement * start[idx2+1:end])
            end
        end
    end
    return unique(prods)
end

length(all_prods(med, rxns)) # Part 1: 576
