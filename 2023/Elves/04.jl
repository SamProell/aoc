##
using Revise
using Elves
##

Card = Tuple{Vector{Int},Vector{Int}}

function parse_card(line::AbstractString)::Card
    _, rest = split(line, ":")
    winning_part, given_part = split(rest, "|")
    winning = parse.(Int, split(winning_part))
    given = parse.(Int, split(given_part))
    return (winning, given)
end

cards = map(parse_card, eachline("2023/data/04.txt"))
##

get_scoring_numbers(card) = intersect(map(Set, card)...)

function score_card(card::Card)
    scoring_numbers = get_scoring_numbers(card)
    if length(scoring_numbers) == 0
        return 0
    end
    return 2^(length(scoring_numbers) - 1)
end
score_card(cards[1])
##
# Part 1
sum(map(score_card, cards))
##

matching_numbers = map(c -> length(get_scoring_numbers(c)), cards)
maxlen = length(matching_numbers)
totals = ones(Int, maxlen)

for (i, num) in enumerate(matching_numbers)
    if num > 0
        start, stop = minimum((maxlen, i + 1)), minimum((maxlen, i + num))
        for (ii, n) in enumerate(start:stop)
            totals[i+ii] += totals[i]
        end
    end
end
sum(totals)
