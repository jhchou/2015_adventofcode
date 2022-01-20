# Combinatorics
# - combinations (combinations with only a set number of elements)
# - powerset (combinations specifying minimum, including 0, and maximum number of elements)
# Iterators.product -- iterate over multiple iterators

using Combinatorics

lines = split("""Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3""", "\n")

# Create equipment dictionary, with item as key and (cost, damage, armor) attributes as value tuple
equipment = Dict{String, Vector{Int}}() # cost, damage, armor attributes
for line in lines
    m = match(r"(.*?)\s+(\d+)\s+(\d+)\s+(\d+)", line)
    if !isnothing(m)
        equipment[m.captures[1]] = parse.(Int, m.captures[2:4])
    end
end

# Create all possible valid kits, using combinations and power sets
weapon_set = combinations(["Dagger", "Shortsword", "Warhammer", "Longsword", "Greataxe"], 1)  # choose exactly 1
armor_set = powerset(["Leather", "Chainmail", "Splintmail", "Bandedmail", "Platemail"], 0, 1) # choose 0 or 1
ring_set = powerset(["Damage +1", "Damage +2", "Damage +3", "Defense +1", "Defense +2", "Defense +3"], 0, 2) # choose 0 to 2

# Collecting here instead of keeping as iterator, to handle collapse of ([], [], []) kit here instead of later
# vcat will collapse tuple of ([], [], []) into single vector; works with empty vectors
kits = [vcat(weapon, armor, rings) for (weapon, armor, rings) in Iterators.product(weapon_set, armor_set, ring_set)]


function win_battle(kit; bosshp = 100, bossdamage = 8, bossarmor = 2)
    # Personalized input for boss stats: Hit Points: 100, Damage: 8, Armor: 2
    hp = 100 # player HP
    cost, damage, armor = sum([equipment[item] for item in kit]) # iterate over items in kit and sum cost, damage, and armor attributes

    playerturn = true
    while true
        if playerturn
            bosshp -= maximum([1, damage - bossarmor])
            if bosshp <= 0 return (true, cost) end
            playerturn = !playerturn
        else
            hp -= maximum([1, bossdamage - armor])
            if hp <= 0 return (false, cost) end
            playerturn = !playerturn
        end
    end
end


lowest_cost = 999999
highest_cost = 0
for kit in kits
    (win, cost) = win_battle(kit)
    if win
        if cost < lowest_cost
            lowest_cost = cost
        end
    else
        if cost > highest_cost
            highest_cost = cost
        end
    end
end

println("Part 1: $lowest_cost") # Part 1: 91
println("Part 2: $highest_cost") # Part 2: 158
