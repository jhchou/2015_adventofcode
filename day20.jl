# Runs quite slowly, not very efficient
# - should not bother with the factorizations and just brute force it by adding one elf at a time and calculating house presents

using Primes
using Combinatorics

input = parse(Int, readline("data/day20.txt"))

function all_divisors(n)
    p = collect(factor(n)) # collection of prime number => number of times it is present (exponent)
    primefactors = Int[1] # will hold array of 1 and prime numbers whose product is n
    for (num, power) in p
        append!(primefactors, fill(num, power))
    end

    # following is inefficient, as the powerset contains duplicates that will multiply to same number
    return sort(unique(reduce.(*, collect(powerset(primefactors, 1)))))
end

function num_presents(housenum)
    elves = all_divisors(housenum)
    total = sum([10*n for n in elves])
    return total
end

housenum = 1
while num_presents(housenum) < input
    housenum += 1
end
println(housenum) # Part 1: 776160


function num_presents2(housenum)
    elves = all_divisors(housenum)
    elves2 = [elf for elf in elves if housenum <= 50*elf] # filter out elf if housenum > 50 * elf
    total = sum([11*n for n in elves2])
    return total
end

housenum = 1
while num_presents2(housenum) < input
    housenum += 1
end
println(housenum) # Part 2: 786240
