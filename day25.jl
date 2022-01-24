# Input: "To continue, please consult the code grid in the manual.  Enter the code at row 3010, column 3019."

function day25(;row = 3010, col = 3019)
    next_code(x) = 252533x % 33554393
    code = 20151125
    diag = 1 # generate codes along diagonals, from lower left (col = 1, row = max) to upper right (col = max, row = 1)
    while true
        diag += 1
        for r in diag:-1:1
            c = diag - r + 1
            code = next_code(code)
            if r == row && c == col
                return code
            end
        end
    end
end

day25() # part 1: 8997277
