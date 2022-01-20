# lines = split(""".#.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####..""", "\n")

lines = readlines("data/day18.txt")

lights = Vector{Bool}[]
for line in lines
    push!(lights, split(line, "") .== ("#"))
end
input_m = permutedims(reduce(hcat, lights))

function print_grid(arr)
    for y in 1:size(arr)[1]
        println( replace(join(arr[y,:]), "true"=>'#', "false"=>' ') )
    end
end

function day18(input_m, steps; part2=false, display=false)
    offsets = CartesianIndex.((i, j) for i = -1:1 for j in -1:1 if (i,j) != (0,0))
    m = copy(input_m)
    (max_x, max_y) = size(m)
    if part2
        m[1, 1] = m[1, max_y] = m[max_x, 1] = m[max_x, max_y] = true
    end
    for step in 1:steps
        m_next = similar(m)
        for ci in CartesianIndices(m)
            neighbors = [ci+o for o in offsets if checkbounds(Bool, m, ci+o)]
            if m[ci]
                m_next[ci] = sum(m[neighbors]) in [2,3]
            else
                m_next[ci] = sum(m[neighbors]) == 3
            end
        end
        m = m_next
        if part2
            m[1, 1] = m[1, max_y] = m[max_x, 1] = m[max_x, max_y] = true
        end
        if display run(`clear`); print_grid(m) end
    end
    
    return sum(m)
end

print_grid(input_m)
println("Part 1: ", day18(input_m, 100, display = false)) # Part 1: 1061
println("Part 2: ", day18(input_m, 100, part2 = true, display = false)) # Part 2: 1006

print_grid(m)