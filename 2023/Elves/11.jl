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
dist(p) = Int(LinearAlgebra.norm(Tuple(p[1] - p[2]), 1))
# Part 1: 
sum(map(dist, get_pairs(findall(expanded .== '#'))))
