##
using Revise
using Elves
##
# note: A/X -> Rock, B/Y -> Paper, C/Z -> Scissors (A -> C -> B)
struct Move
    other::Char
    outcome::Char
end

result_lookup = Dict(
    "AA" => 3, "AB" => 0, "AC" => 6,
    "BA" => 6, "BB" => 3, "BC" => 0,
    "CA" => 0, "CB" => 6, "CC" => 3,
)
move_lookup = Dict(
    "AX" => 'C', "AY" => 'A', "AZ" => 'B',
    "BX" => 'A', "BY" => 'B', "BZ" => 'C',
    "CX" => 'B', "CY" => 'C', "CZ" => 'A',
)
value_lookup = Dict('A' => 1, 'B' => 2, 'C' => 3)

function score_move_old(move::Move)::Int
    mymove = move.outcome - 23
    return result_lookup[mymove*move.other] + value_lookup[mymove]
end

function score_move_new(move::Move)::Int
    mymove = move_lookup[move.other*move.outcome]
    return (move.outcome - 'X') * 3 + value_lookup[mymove]
end

function read_strategy(filename::String)::Vector{Move}
    strat::Vector{Move} = []
    for line in eachline(filename)
        push!(strat, Move(line[1], line[3]))
    end
    return strat
end

strategy = read_strategy("2022/data/02.txt")
##
sum(map(score_move_old, strategy))
##
sum(map(score_move_new, strategy))
##
