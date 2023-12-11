##
using Revise
using Elves
##
# 7: ┐ F: ┌ J: ┘
pipe_grid = vcat(collect.(eachline("2023/data/10.txt")))
pipe_array = reduce(hcat, pipe_grid)
##
struct Tile
    x::Int
    y::Int
    tiletype::Char
end
function Tile(x::Int, y::Int)::Tile
    return Tile(x, y, '.')
end
maze = Array{Tile}(undef, size(pipe_array)...)
## 
for x in 1:size(pipe_array)[1]
    for y in 1:size(pipe_array)[2]
        maze[x, y] = Tile(x, y, pipe_array[x, y])
    end
end
start_pos = maze[findfirst(t -> t.tiletype == 'S', maze)]
##

function can_connect(t1::Char, t2::Char, direction)::Bool
    return (
        ((direction == "^") && (t1 in "S|JL") && (t2 in "7|F"))
        ||
        ((direction == ">") && (t1 in "S-FL") && (t2 in "J7-"))
        ||
        ((direction == "v") && (t1 in "S7|F") && (t2 in "J|L"))
        ||
        ((direction == "<") && (t1 in "S7-J") && (t2 in "F-L"))
    )
end

function incoming_pipes(t::Tile, grid::Matrix{Tile})
    incoming::Vector{Tile} = []
    if (t.x > 1) && can_connect(t.tiletype, grid[t.x-1, t.y].tiletype, "<")
        push!(incoming, grid[t.x-1, t.y])
    end
    if (t.y > 1) && can_connect(t.tiletype, grid[t.x, t.y-1].tiletype, "^")
        push!(incoming, grid[t.x, t.y-1])
    end
    if (t.y < size(grid)[2]) && can_connect(t.tiletype, grid[t.x, t.y+1].tiletype, "v")
        push!(incoming, grid[t.x, t.y+1])
    end
    if (t.x < size(grid)[1]) && can_connect(t.tiletype, grid[t.x+1, t.y].tiletype, ">")
        push!(incoming, grid[t.x+1, t.y])
    end
    return incoming
end
incoming_pipes(start_pos, maze)
##

function move!(current::Vector{Tile}, grid::Matrix{Tile}, len::Matrix{Int})
    if length(current) < 1
        return
    end
    pos = popfirst!(current)
    # println(pos, " ", current, " ", len[pos.x, pos.y])
    l = len[pos.x, pos.y]
    incoming = incoming_pipes(pos, grid)
    for t in incoming
        if len[t.x, t.y] != -1
            continue
        end
        len[t.x, t.y] = l + 1
        push!(current, t)
    end
    move!(current, grid, len)
end
## 
dists = fill(-1, size(maze))
dists[start_pos.x, start_pos.y] = 0
move!([start_pos], maze, dists)
permutedims(dists)
##
# Part 1:
findmax(dists)
