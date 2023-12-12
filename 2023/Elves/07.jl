##
using Revise
using Elves
import Base: isless
##
CamelCardOrder = Dict(zip("23456789TJQKA", collect(range(2, stop=14))))
@enum CamelCardHandType highcard = 1 onepair = 2 twopairs = 3 threeofakind = 4 fullhouse = 5 fourofakind = 6 fiveofakind = 7

map_card_value(c::Char, order::Dict) = Int(order[c])
map_hand_values(h::AbstractString, order::Dict) = Tuple([map_card_value(c, order) for c in h])

struct CamelCardHand
    hand_string::AbstractString
    labels::NTuple{5,Int}
    function CamelCardHand(hand::AbstractString, order=CamelCardOrder)
        if length(hand) != 5
            error("Need exactly 5 cards in hand.")
        end
        labels = map_hand_values(hand, order)
        return new(hand, Tuple(labels))
    end
    function CamelCardHand(hand::AbstractString, labels::NTuple{5,Int})
        return new(hand, labels)
    end
end
CamelCardHand("22555")
##
# https://discourse.julialang.org/t/number-of-each-unique-value-in-an-array/58627/3
count_values(a) = [(count(==(element), a), element) for element in unique(a)]
##
function get_camelcardhand_type(hand::CamelCardHand)::CamelCardHandType
    uniques = sort(count_values(hand.hand_string))
    if length(uniques) == 5
        return highcard
    elseif length(uniques) == 4
        return onepair
    elseif length(uniques) == 3
        if uniques[end][1] == 3
            return threeofakind
        else
            return twopairs
        end
    elseif length(uniques) == 2
        if uniques[end][1] == 4
            return fourofakind
        end
        return fullhouse
    end
    return fiveofakind
end
get_camelcardhand_type(CamelCardHand("AKK33"))
##
function isless(a::CamelCardHand, b::CamelCardHand)
    atype, btype = get_camelcardhand_type(a), get_camelcardhand_type(b)
    if atype == btype
        for (ca, cb) in zip(a.labels, b.labels)
            if ca != cb
                return ca < cb
            end
        end
        return false
    end
    return atype < btype
end
##
import DelimitedFiles
data = DelimitedFiles.readdlm("2023/data/07.txt", ' ', String)
hands = [CamelCardHand(h) for h in data[:, 1]]
bids = parse.(Int, data[:, 2])
perm = sortperm(hands)
ranks = [findall(x -> x == i, perm)[1] for i in 1:length(hands)]
##
# Part 1: 248217452
sum(bids .* ranks)
##
CamelCardOrderJoker = copy(CamelCardOrder)
CamelCardOrderJoker['J'] = -1

function apply_joker(hand::CamelCardHand)::CamelCardHand
    others = sort(count_values(replace(hand.hand_string, "J" => "")))
    if length(others) > 0
        newstring = replace(hand.hand_string, "J" => others[end][2])
    else
        newstring = hand.hand_string
    end
    return CamelCardHand(newstring, map_hand_values(hand.hand_string, CamelCardOrderJoker))
end

hands_joker = map(apply_joker, hands)
perm_joker = sortperm(hands_joker)
ranks_joker = [findall(x -> x == i, perm_joker)[1] for i in 1:length(hands)]
## Part 2: 245576185
sum(bids .* ranks_joker)
##