##
using Revise
using Elves
##
# 7: ┐ F: ┌ J: ┘
pipe_grid = vcat(collect.(eachline("2023/data/10ex.txt")))
pipe_array = permutedims(reduce(hcat, pipe_grid))
length_array = fill(-1, size(pipe_array))
##
struct Position
    x::Int
    y::Int
end

start_pos = Position(Tuple(findall(x -> x == 'S', pipe_array)[1])...)
##

function move!(current::Vector{Pos}, grid::Matrix{Char, 2}, len::Matrix{Int, 2})
    for pos in current
        l = length_grid[pos.y][pos.x]

end
