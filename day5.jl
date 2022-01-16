lines = readlines("data/day5.txt")

function nice(word)
    # does NOT contain the strings ab, cd, pq, or xy
    # contains at least three vowels (aeiou only)
    # contains at least one letter that appears twice in a row
    return (match(r"ab|cd|pq|xy", word) == nothing) &&
    (match(r"[aeiou].*[aeiou].*[aeiou]", word) != nothing) &&
    (match(r"(.)\1", word) != nothing)
end


function nice2(word)
    # It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
    # It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
    return (match(r"(..).*\1", word) != nothing) && (match(r"(.).\1", word) != nothing)
end

sum(nice.(lines)) # Part 1: 236
sum(nice2.(lines)) # Part 2: 51
