##
using Revise
using Elves
import Base.length
##
struct Point
    x::Int
    y::Int
end

struct EngineSymbol
    pos::Point
    value::Char
end
mutable struct EngineNumber
    value_str::String
    start::Point
end

function length(num::EngineNumber)::Int
    return length(num.value_str)
end

function value(num::EngineNumber)::Int
    return parse(Int, num.value_str)
end

function parse_schematic(lines)
    numbers::Vector{EngineNumber} = []
    symbols::Vector{Vector{EngineSymbol}} = []
    for (y, line) in enumerate(lines)
        thisline = []
        current_num = EngineNumber("", Point(-1, -1))
        for (x, c) in enumerate(line)
            if isdigit(c)
                if length(current_num) == 0
                    current_num.start = Point(x, y)
                end
                current_num.value_str = current_num.value_str * c
            else
                if length(current_num) > 0
                    push!(numbers, current_num)
                    current_num = EngineNumber("", Point(-1, -1))
                end
                if c != '.'
                    push!(thisline, EngineSymbol(Point(x, y), c))
                end
            end
        end
        if length(current_num) > 0
            push!(numbers, current_num)
        end
        push!(symbols, thisline)
    end
    return (numbers, symbols)
end

schematic = readlines("2023/data/03.txt")

numbers, symbols = parse_schematic(schematic)
##
function is_adjacent(num, pos)
    return (
        (pos.x >= num.start.x - 1) && (pos.x <= num.start.x + length(num))
        &&
        (pos.y >= num.start.y - 1) && (pos.y <= num.start.y + 1)
    )
end

function check_number(num::EngineNumber, syms::Vector{Vector{EngineSymbol}})
    for y in range(maximum((1, num.start.y - 1)), minimum((num.start.y + 1, length(syms))))
        for sym in syms[y]
            # if (sym.pos.x >= num.start.x - 1) && (sym.pos.x <= num.start.x + length(num))
            if is_adjacent(num, sym.pos)
                return true
            end
        end
    end
    return false
end

check_number(numbers[2], symbols)
##
# 560670
sum(map(value, filter(n -> check_number(n, symbols), numbers)))

##
for num in filter(n -> (check_number(n, symbols)), numbers)
    for y in range(maximum((1, num.start.y - 1)), minimum((num.start.y + 1, length(schematic))))
        print(schematic[y][maximum((1, num.start.x - 1)):minimum((num.start.x + length(num), length(schematic[y])))] * "\n")
    end
    print("          " * num.value_str * "\n")
end
##
function find_gear_ratio(pos::Point, numbers::Vector{EngineNumber})
    adjacent_numbers = filter(n -> is_adjacent(n, pos), numbers)
    if length(adjacent_numbers) == 2
        return value(adjacent_numbers[1]) * value(adjacent_numbers[2])
    end
    return 0
end

find_gear_ratio(symbols[end-1][end].pos, numbers)
##
gear_ratios = map(vcat(symbols...)) do s
    find_gear_ratio(s.pos, numbers)
end
sum(gear_ratios)
##
