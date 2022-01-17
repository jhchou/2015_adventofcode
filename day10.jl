line = readline("data/day10.txt")

const REG = r"(.)\1*"

function look_and_say_num(input, num)
    for i in 1:num
        # reduce with string concatenation
        # map:
        # - eachmatch returns iterable of all matches over input
        # - each of the matches m is converted to look-and-say
        input = reduce(*, map(m -> string(length(m.match)) * m.captures[1], eachmatch(REG, input, overlap = false)))
    end
    return length(input)
end


look_and_say_num(line, 40) # Part 1: 329356
look_and_say_num(line, 50) # Part 2: 4666278


# Following should theoretically work, but ends up with a stack overflow error at depth ~31
# 
# - however, MUCH better to just use eachmatch to get ALL the matches at once, rather than iteratively
#
# function look_and_say_recursive(s)
#     # build result by recursively removing repetitions of first character
#     if length(s) == 0
#         return ""
#     end
#     m = match(r"^(.)\1*", s)
#     # start of line, single character (1st capture group), 1st capture group additionally 0+ times
#     # m.match is the entire match of repeated first characters
#     # m.captures[1] is the first character
#     return string(length(m.match)) * m.captures[1] * look_and_say_recursive(s[length(m.match)+1:end])
# end