function day7(; part2 = false)
    ops = Dict("AND" => &, "OR" => |, "LSHIFT" => <<, "RSHIFT" => >>)
    lines = readlines("data/day7.txt")
    wires = Dict{String, Int}() # wire --> signal

    function w(key)
        # Requires access to wires dictionary
        # - return value if input is all digits
        # - return value from wires if key exists, otherwise return nothing
        if !isnothing(match(r"^\d+$", key)) # all digits
            return parse(Int, key)
        elseif haskey(wires, key)
            return wires[key]
        else
            return nothing
        end
    end
    
    while true # iterate over lines until no wire signals are missing
        complete = true
        for line in lines
            m = match(r"(.*) -> (.*)", line)
    
            output = m.captures[2]
            if !isnothing(w(output)) # have already determined output
                continue
            end
    
            if part2 && output == "b"
                wires["b"] = day7() # for part 2, signal "b" is set to part 1 signal "a"
                continue
            end
    
            inputs = split(m.captures[1])
            vals = w.(inputs)
            if length(inputs) == 1 # either numeric or single key
                if isnothing(vals[1])
                    complete = false
                else
                    wires[output] = vals[1]
                end
            elseif inputs[1] == "NOT" # NOT is the only unary operator
                if isnothing(vals[2])
                    complete = false
                else
                    wires[output] = ~vals[2]
                end
            else # <vals1> <binaryoperator> <vals3>
                if isnothing(vals[1]) || isnothing(vals[3])
                    complete = false
                else
                    wires[output] = (ops[inputs[2]])(vals[1], vals[3])
                end
            end
        end
        if complete break end
    end
    
    return wires["a"]
end

day7() # Part 1: 956
day7(part2 = true) # Part 2: 40149
