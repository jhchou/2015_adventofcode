
# If you cannot afford to cast any spell, you lose
# Effects apply at the start of both the player's turns and the boss' turns
# Cannot start an effect which is already active; can be started on the same turn they end
# What is the least amount of mana you can spend and still win the fight?

# Player turn
# - ongoing effects; decrement timer; if 0, ends
# - player cast
#     - instant effects
#     - start timer, new ongoing effect NOT applied

# Boss turn
# - ongong effects; decrement timer; if 0, ends
# - boss attack

# "Magic Missile", 53, # instantly does 4 damage
# "Drain", 73, # instantly does 2 damage and heals for 2 hit points
# "Shield", 113 # effect for 6 turns; while active, armor is increased by 7
# "Poison", 173 mana # effect for 6 turns; at the start of each turn while active, does 3 damage; starts turn after cast
# "Recharge", 229 # effect for 5 turns; at the start of each turn while active, gives 101 new mana

const SPELLS = ["Magic Missile", "Drain", "Shield", "Poison", "Recharge"]
const SPELL_COSTS = [53, 73, 113, 173, 229]

mana = 500 # starting amount
hp = 50 # starting amount
boss_hp = 58
boss_damage = 9


""" Describes a gamestate / history completely, JUST after spell choice mid-player turn """
struct Gamestate
    name::String # last character (digit) will identify spell just chosen
    mana::Int
    hp::Int
    boss_hp::Int
    shield_timer::Int
    poison_timer::Int
    recharge_timer::Int
end

""" Takes string with substring of spell numbers and returns total spell cost. Requires SPELL_COSTS array. """
function manacost(name)
    m = match(r"(\d+)", name)
    if isnothing(m) return 0 end
    return sum(SPELL_COSTS[parse.(Int, split(m.captures[1], ""))])
end

""" Play a turn, starting from just after player spell choice, adding to queue of new states """
function turn(s::Gamestate)
    name = s.name
    mana = s.mana
    hp = s.hp
    boss_hp = s.boss_hp
    shield_timer = s.shield_timer
    poison_timer = s.poison_timer
    recharge_timer = s.recharge_timer

    ### Player turn, starting after spell choice ###
    m = match(r".$", name) # last character
    spell = parse(Int, m.match) # 0 at start turn, otherwise spell 1 - 5

    # println("Name: $name Spell: $spell Mana: $mana HP: $hp Boss HP: $boss_hp Shield: $shield_timer Poison: $poison_timer Recharge: $recharge_timer")

    if spell == 1 # "Magic Missile", 53, # instantly does 4 damage
        boss_hp -= 4
    elseif spell == 2 # "Drain", 73, # instantly does 2 damage and heals for 2 hit points
        boss_hp -= 2
        hp += 2
    elseif spell == 3 # "Shield", 113 # effect for 6 turns; while active, armor is increased by 7
        shield_timer = 6
    elseif spell == 4 # "Poison", 173 mana # effect for 6 turns; at the start of each turn while active, does 3 damage; starts turn after cast
        poison_timer = 6
    elseif spell == 5 # "Recharge", 229 # effect for 5 turns; at the start of each turn while active, gives 101 new mana
        recharge_timer = 5
    end

    ### Boss turn ###

    # Ongoing effects
    shield_timer == 0 ? armor = 0 : armor = 7
    if poison_timer != 0 boss_hp -= 3 end
    if recharge_timer != 0 mana += 101 end

    # Decrement timers
    if shield_timer != 0 shield_timer -= 1 end
    if poison_timer != 0 poison_timer -= 1 end
    if recharge_timer != 0 recharge_timer -= 1 end

    if boss_hp <= 0
        total_mana = manacost(name[2:end])
        println("WIN: $name $total_mana")
        return true
    end

    # Boss attack
    hp -= (8 - armor)
    if hp <= 0
        # println("LOSE: $name $(manacost(name[2:end]))")
        return false
    end

    ### Player turn, after boss attack ###
    # Ongoing effects
    shield_timer == 0 ? armor = 0 : armor = 7
    if poison_timer != 0 boss_hp -= 3 end
    if recharge_timer != 0 mana += 101 end

    # Decrement timers
    if shield_timer != 0 shield_timer -= 1 end
    if poison_timer != 0 poison_timer -= 1 end
    if recharge_timer != 0 recharge_timer -= 1 end
    
    # Spell options for next turn
    for i in 1:length(SPELLS)
        if i == 3 && shield_timer != 0 continue end
        if i == 4 && poison_timer != 0 continue end
        if i == 5 && recharge_timer != 0 continue end
        if mana >= SPELL_COSTS[i]
            next_state = name * string(i)
            states[next_state] = Gamestate(next_state, mana - SPELL_COSTS[i], hp, boss_hp, shield_timer, poison_timer, recharge_timer)
            push!(queue, next_state)
        end
    end

    return false
end

states = Dict{String, Gamestate}()
states["0"] = Gamestate("0", mana, hp, boss_hp, 0, 0, 0)
queue = String["0"]
lowest_cost = 999999

while true
    if length(queue) == 0 break end
    name = pop!(queue)
    cost = manacost(name[2:end])
    if cost < lowest_cost
        if turn(states[name]) && cost < lowest_cost
            lowest_cost = cost
        end
    end
end

lowest_cost
