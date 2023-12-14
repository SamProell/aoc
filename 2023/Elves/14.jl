##
using Revise
using Elves
##
platform = read_char_array("2023/data/14ex.txt")
##
@enum Direction North East South West
## 
struct Position
    x::Int
    y::Int
end

BORDER = ' '

function get_neighbor(pos::Position, grid, dir::Direction)
    if (dir == North) && (pos.y - 1 > 0)
        return grid[pos.y-1, pos.x]
    elseif (dir == East) && (pos.x + 1 <= size(grid)[2])
        return grid[pos.y, pos.x+1]
    elseif (dir == South) && (pos.y + 1 <= size(grid)[1])
        return grid[pos.y+1, pos.x]
    elseif (dir == West) && (pos.x - 1 > 0)
        return grid[pos.y, pos.x-1]
    end
    return BORDER
end

function can_move(pos::Position, grid, dir::Direction)
    (grid[pos.y, pos.x] == 'O') && (get_neighbor(pos, grid, dir) == ".")
end

function move(pos::Position, grid, dir::Direction)
    if can_move(pos, grid, dir)
        ...
    end
end
##