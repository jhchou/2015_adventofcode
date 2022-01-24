function day23(; part2 = false)
    lines = readlines("data/day23.txt")
    reg = Dict("a" => 0, "b" => 0) # registers, integers >= 0
    if part2
        reg["a"] = 1
    end
    pc = 1 # program counter
    while pc >= 1 && pc <= length(lines)
        m = match(r"(...) (.*)", lines[pc])
        ins = m.captures[1]
        arg = m.captures[2]
    
        if ins == "hlf"
            reg[arg] ÷= 2
            pc += 1
        elseif ins == "tpl"
            reg[arg] *= 3
            pc += 1
        elseif ins == "inc"
            reg[arg] += 1
            pc += 1
        elseif ins == "jmp"
            pc += parse(Int, arg)
        else
            m = match(r"(...) (.*), (.*)", lines[pc])
            ins = m.captures[1]
            arg = m.captures[2]
            rel = parse(Int, m.captures[3])
            if ins == "jie"
                if iseven(reg[arg])
                    pc += rel
                else
                    pc += 1
                end
            elseif ins == "jio"
                if reg[arg] == 1
                    pc += rel
                else
                    pc += 1
                end
            else
                println("Error")
            end
        end
    end
    return reg["b"]
end

day23() # Part 1: 184
day23(part2 = true) # Part 2: 231
