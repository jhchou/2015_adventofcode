lines = readlines("data/day8.txt")

code_length = 0
char_length = 0
reencode_length = 0

function hexchar(s)
    return Char(parse(Int, s[3:end], base=16))
end

for line in lines
    code_length += length(line)
    x = replace(line,
        r"^\"" => "", # leading quote
        r"\"$" => "", # trailing quote
        r"(\\x[0-9a-f]{2})" => hexchar, # \x##
        "\\\"" => "\"", # \"
        "\\\\" => "\\"  # \\
    )
    char_length += length(x)

    y = replace(line,
        "\"" => "\\\"",
        "\\" => "\\\\"
    )
    y = "\"" * y * "\""
    reencode_length += length(y)

    # println("$line ($(length(line))) --- $x ($(length(x))) --- $y ($(length(y)))")
end

println("Part 1: ", code_length - char_length) # Part 1: 1342
println("Part 2: ", reencode_length - code_length) # Part 2: 2074
