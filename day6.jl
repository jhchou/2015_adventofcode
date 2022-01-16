using OffsetArrays

lines = readlines("data/day6.txt")

grid = OffsetArray(zeros(Bool, 1000, 1000), 0:999, 0:999)
for line in lines
    m = match(r"(.*) (\d+),(\d+) through (\d+),(\d+)", line)
    cmd = m.captures[1] # turn on/off or toggle
    (x1, y1, x2, y2) = parse.(Int, m.captures[2:5])
    if cmd == "toggle"
        grid[x1:x2, y1:y2] .= .!grid[x1:x2, y1:y2]
    else
        grid[x1:x2, y1:y2] .= (match(r"on", cmd) != nothing)
    end
end
sum(grid) # Part 1: 377891


grid2 = OffsetArray(zeros(Int64, 1000, 1000), 0:999, 0:999)
for line in lines
    m = match(r"(.*) (\d+),(\d+) through (\d+),(\d+)", line)
    cmd = m.captures[1] # turn on/off or toggle
    (x1, y1, x2, y2) = parse.(Int, m.captures[2:5])
    if cmd == "toggle"
        grid2[x1:x2, y1:y2] .+= 2
    else
        if (match(r"on", cmd) != nothing) # turn on
            grid2[x1:x2, y1:y2] .+= 1
        else # turn off
            grid2[x1:x2, y1:y2] .-= 1
            grid2[grid2 .< 0] .= 0 # Boolean indexing of which elements < 0 --> set to 0
        end
    end
end
sum(grid2) # Part 2: 14110788
