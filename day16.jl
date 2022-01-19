lines = readlines("data/day16.txt")

constraints = [
    "cats: 7", "trees: 3",           # MORE THAN this number, in part 2
    "pomeranians: 3", "goldfish: 5", # LESS THAN this number, in part 2
    "children: 3", "samoyeds: 2", "akitas: 0", "vizslas: 0", "cars: 2", "perfumes: 1"]

for line in lines
    m = match(r"Sue (\d+): (\D+: \d+), (\D+: \d+), (\D+: \d+)", line)

    if all(x -> x in constraints, m.captures[2:4])
        println("Part 1: Sue # ", m.captures[1])
    end

    success = true
    for component in m.captures[2:4]
        m2 = match(r"(cats|trees|pomeranians|goldfish): (\d+)", component)
        if isnothing(m2)
            # println(component, component in constraints)
            if !(component in constraints) success = false end
        else
            type = m2.captures[1]
            num = parse(Int, m2.captures[2])
            type == "cats" && num <= 7 && (success = false) # need more than 7 cats
            type == "trees" && num <= 3 && (success = false) # need more than 3 trees
            type == "pomeranians" && num >= 3 && (success = false) # need less than 3
            type == "goldfish" && num >= 5 && (success = false) # need less than 5
        end
    end
    if success
        println("Part 2: Sue # ", m.captures[1])
    end
end

# Part 1: 103
# Part 2: 405
