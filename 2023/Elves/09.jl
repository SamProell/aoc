##
using Revise
using Elves
##
parse_line(line) = [parse(Int, n) for n in split(line)]
histories = map(parse_line, eachline("2023/data/09.txt"))
##
struct Prediction
    forward::Int
    backward::Int
    leftmost::Vector{Int}
    rightmost::Vector{Int}
end

function extrapolate_backward(values)
    n = 0
    for val in reverse(values)
        n = val - n
    end
    return n
end
function predict(hist::Vector{Int})::Prediction
    diffs = hist
    rightmost = []
    leftmost = []
    while !(all(diffs .== 0))
        append!(leftmost, diffs[1])
        append!(rightmost, diffs[end])
        diffs = diff(diffs)
    end
    return Prediction(sum(rightmost), extrapolate_backward(leftmost), leftmost, rightmost)
end
# Part 1
sum(map(h -> predict(h).forward, histories))
##
# Part 2
sum(map(h -> predict(h).backward, histories))


