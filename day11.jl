const INVALID = [8, 14, 11] #  s2i("iol")

function s2i(s) map(c -> Int(c) - Int('a'), collect(s)) end # convert lowercase characters to 0:25
function i2s(input) Char.(input .+ Int('a')) |> join end

function valid(input)
    # input as integer vector; assume input does NOT have any invalid inputs
    # forbidden_input = any(x -> x in INVALID, input)

    # straight of 3 will include [1,1] in diff
    diffs = diff(input)
    has_straight = any(==([1,1]), [diffs[i:i+1] for i in 1:length(diffs)-1])

    # convert integer vector to chars --> match ALL repeated chars --> require more than 1 unique chars
    has_pairs = length(unique([m.captures[1] for m in eachmatch(r"(.)\1+", i2s(input))])) > 1

    return has_straight && has_pairs # && !forbidden(input)
end

function increment_digit!(input, idx)
    # input as integer vector
    while true
        input[idx] += 1
        input[idx] in INVALID || break
    end
    if input[idx] <= 25
        return input
    else
        input[idx] = input[idx] % 26
        return increment_digit!(input, idx - 1)
    end
end

function next_password(input_string)
    input_int = s2i(input_string)
    while true
        increment_digit!(input_int, length(input_int))
        valid(input_int) && break
    end
    return i2s(input_int)
end

# Test cases
# valid(s2i("hijklmmn")) == false
# valid(s2i("abcdefgh")) == false
# valid(s2i("abcdffaa")) == true
# valid(s2i("ghijklmn")) == false
# valid(s2i("ghjaabcc")) == true
# next_password("abcdefgh") == "abcdffaa"
# next_password("ghijklmn") == "ghjaabcc"

input = readline("data/day11.txt")
part1 = next_password(input) # Part 1: hepxxyzz
part2 = next_password(part1) # Part 2: heqaabcc
