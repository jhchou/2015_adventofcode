# ingredient, capacity, durability, flavor, texture, calories
# lines = split("""Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
# Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3""", "\n")

lines = readlines("data/day15.txt")

coefs = Vector{Int}[]
for line in lines
    m = match(r"(.*): capacity (-*\d+), durability (-*\d+), flavor (-*\d+), texture (-*\d+), calories (-*\d+)", line)
    ingredient = m.captures[1]
    push!(coefs, parse.(Int, m.captures[2:end]))
    # coef = parse.(Int, m.captures[2:end])
    println(ingredient, ": ", coef)
end
m = reduce(hcat, coefs)

function day15(m; part2 = false)
    best_score = 0
    best_mix = [0,0,0,0]
    # Ugly... Brute force ALL possible combinations of ingredients summing to 100 tsp...
    for b1 in 0:100
        for b2 in 0:100-b1
            for b3 in 0:100-b1-b2
                b4 = 100 - b1 - b2 - b3
                b = [b1, b2, b3, b4]
                y = (m * b) # total of each capacity, durability, flavor, texture, calories
                part2 && (y[5] != 500) && continue # part 2 requires 500 calories
                score = any(<=(0), y[1:4]) ? 0 : reduce(*, y[1:4]) # any score <= 0 results in score of 0, otherwise product
                if score > best_score
                    best_score = score
                    best_mix = b
                end
            end
        end
    end
    return best_score
end

day15(m) # Part 1: 222870
day15(m, part2 = true) # Part 2: 117936
