reindeer = Dict{String, Tuple{Int, Int, Int}}() # velocity, duration, rest

function distance(stats::Tuple{Int, Int, Int}, time::Int)
    (velocity, duration, rest) = stats
    cycle_time = duration + rest
    cycle_distance = velocity * duration
    cycles = time ÷ cycle_time
    remaining_time = time % cycle_time
    return cycles * cycle_distance + (remaining_time >= duration ? cycle_distance : remaining_time * velocity)
end

for line in readlines("data/day14.txt")
    m = match(r"(.*) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.", line)
    reindeer[m.captures[1]] = Tuple(parse.(Int, m.captures[2:4]))
end
statarray = collect(values(reindeer))

scores = zeros(Int, length(statarray))
for t in 1:2503
    d = statarray .|> s -> distance(s, t)
    lead = maximum(d)
    scores += (d .== lead)
end

maximum([distance(stats, 2503) for stats in statarray]) # Part 1: 2696
maximum(scores) # Part 2: 1084
