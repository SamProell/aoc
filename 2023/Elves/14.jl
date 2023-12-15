##
using Revise
using Elves
##
platform = read_char_array("2023/data/14.txt")
##
@enum Direction North East South West
## 
struct Position
    x::Int
    y::Int
end

BORDER = ' '

function get_neighbor_position(pos::Position, grid, dir::Direction)
    if (dir == North) && (pos.y - 1 > 0)
        return Position(pos.x, pos.y - 1)
    elseif (dir == East) && (pos.x + 1 <= size(grid)[2])
        return Position(pos.x + 1, pos.y)
    elseif (dir == South) && (pos.y + 1 <= size(grid)[1])
        return Position(pos.x, pos.y + 1)
    elseif (dir == West) && (pos.x - 1 > 0)
        return Position(pos.x - 1, pos.y)
    end
    return nothing
end

function get_neighbor(pos::Position, grid, dir::Direction)
    neighbor = get_neighbor_position(pos, grid, dir)
    if neighbor === nothing
        return BORDER
    end
    return grid[neighbor.y, neighbor.x]
end

function can_move(pos::Position, grid, dir::Direction)
    (grid[pos.y, pos.x] == 'O') && (get_neighbor(pos, grid, dir) == '.')
end
##
get_neighbor(Position(1, 4), platform, North)

##

function move_pos(pos::Position, grid, dir::Direction)
    # println(pos, " ", can_move(pos, grid, dir))
    if can_move(pos, grid, dir)
        neighbor = get_neighbor_position(pos, grid, dir)
        grid[pos.y, pos.x] = '.'
        grid[neighbor.y, neighbor.x] = 'O'
        return true
    end
    return false
end

function tilt!(grid, dir::Direction)
    while true
        moved = false
        for y = 1:size(grid)[1], x = 1:size(grid)[2]
            moved = moved || move_pos(Position(x, y), grid, dir)
        end
        if !(moved)
            break
        end
    end
end
##
newgrid = copy(platform)
tilt!(newgrid, North)
newgrid
## 
counts = map(count, eachrow(newgrid .== 'O'))
##
function total_weight(grid)
    counts = map(count, eachrow(newgrid .== 'O'))
    sum(i * n for (i, n) in enumerate(reverse(counts)))
end
##
# Part 1
total_weight(newgrid)
##