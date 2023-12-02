##
using Revise
using Elves
##
const ChannelLookup = Dict("red" => 1, "green" => 2, "blue" => 3)

function parse_draw(draw::AbstractString)
    d = [0, 0, 0]
    for pair in split(draw, ",")
        number, color = split(pair)
        d[ChannelLookup[color]] = parse(Int, number)
    end
    return d
end
##
read_all_draws(draws::AbstractString) = map(parse_draw, split(draws, ";"))
##
function parse_line(line::AbstractString)
    game, draws = split(line, ":")
    gamenum = parse(Int, split(game)[2])
    return (gamenum, read_all_draws(draws))
end
data = map(parse_line, eachline("2023/data/02.txt"))
##
max_counts = [12, 13, 14]

is_valid_game(draws) = all(map(d -> all(d .<= max_counts), draws))

function count_game(pair)
    id, draws = pair
    if is_valid_game(draws)
        return id
    end
    return 0
end
# Part 1
sum(map(count_game, data))
##
games = map(d -> d[2], data)

function get_power(game)
    # https://discourse.julialang.org/t/how-to-stack-vectors-to-make-a-matrix/16010/2
    arr = vcat(transpose.(game)...)
    limits, _ = findmax(arr, dims=1)
    return prod(limits)
end
# Part 2
sum(map(get_power, games))
