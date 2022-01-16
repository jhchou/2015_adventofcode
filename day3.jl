using DataStructures

line = readline("data/day3.txt")
directions = Dict('^' => [0, 1], 'v' => [0, -1], '>' => [1, 0], '<' => [-1, 0])

# Part 1
visited = DefaultDict{Vector{Int64}, Int64}(0)
pos = [0,0]
visited[pos] = 1
for c in line
    pos += directions[c]
    visited[pos] += 1
end
length(visited) # Part 1: 2572


# Part 2
visited = DefaultDict{Vector{Int64}, Int64}(0)
robosanta = false
pos = [0,0]
robopos = [0,0]
visited[pos] = 2
for c in line
    if robosanta
        robopos += directions[c]
        visited[robopos] += 1
    else
        pos += directions[c]
        visited[pos] += 1
    end
    robosanta = !robosanta
end
length(visited) # Part 2: 2631

