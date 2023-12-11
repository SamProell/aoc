##
using Revise
using Elves
##
universe = permutedims(reduce(hcat, collect.(eachline("2023/data/11.txt"))))
universe
##
function expand_universe(arr)
    expanded = copy(arr)
    for (y, r) in Iterators.reverse(enumerate(eachrow(expanded)))
        if all(r .== '.')
            expanded = vcat(expanded[1:y, :], expanded[y:end, :])
        end
    end
    for (x, c) in Iterators.reverse(enumerate(eachcol(expanded)))
        if all(c .== '.')
            expanded = hcat(expanded[:, 1:x], expanded[:, x:end])
        end
    end
    return expanded
end

function print_universe(arr)
    for row in eachrow(arr)
        println(String(row))
    end
end

expanded = expand_universe(universe)
size(expanded), size(universe)
print_universe(expanded)
# map(r -> all(r .== '.'), eachcol(universe))
##
function get_pairs(a)
    pairs = []
    for (i, v) in enumerate(a)
        for w in a[i+1:end]
            push!(pairs, (v, w))
        end
    end
    return pairs
end
##
import LinearAlgebra
dist(p1, p2) = Int(LinearAlgebra.norm(p1 .- p2, 1))
galaxies = map(Tuple, findall(expanded .== '#'))
##
# Part 1:
sum(map(pair -> dist(pair[1], pair[2]), get_pairs(galaxies)))
##
num_empty_lines(a, d) = sum(all(s .== '.') for s in eachslice(a, dims=d))
rows_between(g1, g2, u) = view(u, min(g1[1], g2[1]):max(g1[1], g2[1]), :)
cols_between(g1, g2, u) = view(u, :, min(g1[2], g2[2]):max(g1[2], g2[2]))
##
function enourmous_dist(
    g1::Tuple{Int,Int}, g2::Tuple{Int,Int}, u::Matrix{Char}, spacing::Int
)
    row_spaces = num_empty_lines(rows_between(g1, g2, u), 1)
    col_spaces = num_empty_lines(cols_between(g1, g2, u), 2)
    # return dist(g1, g2) + spacing * max(row_spaces - 1, 0) + spacing * max(col_spaces - 1, 0)
    return (spacing - 1) * (row_spaces + col_spaces) + dist(g1, g2)
end
galaxies = map(Tuple, findall(universe .== '#'))
pairs = get_pairs(galaxies)
##
# Part 2
sum(map(p -> enourmous_dist(p[1], p[2], universe, 1000000), pairs))
##
