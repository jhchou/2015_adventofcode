input = readline("data/day1.txt")
# Part 1: 232
count(c -> (c=='('), input) - count(c -> (c==')'), input)

# Part 2: 1783
findfirst(==(-1), cumsum([c == '(' ? 1 : -1 for c in input]))

