using MD5

key = readline("data/day4.txt")

n = 0
while true
    n += 1
    # if bytes2hex(md5(key * string(n)))[1:5] == "00000" # Part 1: 346386
    if bytes2hex(md5(key * string(n)))[1:6] == "000000" # Part 2: 9958218
        break
    end
end
println(n)
