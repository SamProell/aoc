##
using Revise
using Elves
##
# 7: ┐ F: ┌ J: ┘
pipe_grid = vcat(collect.(eachline("2023/data/10ex3.txt")))
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
##
maze = Array{Tile}(undef, size(pipe_array)...)
for x in 1:size(pipe_array)[1]
    for y in 1:size(pipe_array)[2]
        maze[x, y] = Tile(x, y, pipe_array[x, y])
    end
end
start_pos = maze[findfirst(t -> t.tiletype == 'S', maze)]
##
@enum Direction East South West North
##
function get_direction(t1::Tile, t2::Tile)::Direction
    if t1.x < t2.x
        return East
    elseif t1.x > t2.x
        return West
    elseif t1.y > t2.y
        return North
    elseif t1.y < t2.y
        return South
    end
    error("Cannot determine direction with ", t1, " and ", t2)
end

function can_connect(t1::Tile, t2::Tile)::Bool
    direction = get_direction(t1, t2)
    return (
        ((direction == North) && (t1.tiletype in "S|JL") && (t2.tiletype in "7|F"))
        ||
        ((direction == East) && (t1.tiletype in "S-FL") && (t2.tiletype in "J7-"))
        ||
        ((direction == South) && (t1.tiletype in "S7|F") && (t2.tiletype in "J|L"))
        ||
        ((direction == West) && (t1.tiletype in "S7-J") && (t2.tiletype in "F-L"))
    )
end

function get_neighbors(t::Tile, grid::Matrix{Tile})
    neighbors = Vector{Union{Tile,Nothing}}
    if t.x > 1
        push!(neighbors, grid[t.x-1, t.y])
    else
        push!(neighbors, nothing)
    end
    if t.x < size(grid)[1]
        push!(neighbors, grid[t.x+1, t.y])
    else
        push!(neighbors, nothing)
    end
    if t.y > 1
        push!(neighbors, grid[t.x, t.y-1])
    else
        push!(neighbors, nothing)
    end
    if t.y < size(grid)[2]
        push!(neighbors, grid[t.x, t.y+1])
    else
        push!(neighbors, nothing)
    end
    return neighbors
end
get_neighbors(start_pos, maze)
##
function incoming_pipes(t::Tile, grid::Matrix{Tile})
    return filter(n -> can_connect(t, n), filter(n -> n != nothing, get_neighbors(t, grid)))
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
# %%
function grow!(seed::Tile, grid::Matrix{Tile}, area::Matrix{Int}, region::Int)
    neighbors = get_neighbors(seed, grid)
    same_region = filter(n -> area[n.x, n.y] == -1, neighbors)
    for n in same_region
        area[n.x, n.y] = region
        grow!(n, grid, area, region)
    end
end

area = copy(dists)
grow!(start_pos, maze, area, findmin(area)[1] - 1)
permutedims(area)
