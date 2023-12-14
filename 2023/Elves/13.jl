##
function read_pattern(block::AbstractString)
    permutedims(reduce(hcat, collect.(split(strip(block), "\n")))) .== '#'
end

block = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#."""
read_pattern(block)

blocks = split(replace(read("2023/data/13.txt", String), "\r" => ""), "\n\n")
patterns = map(read_pattern, blocks)
##
function splitborder(a::AbstractArray, c::Int)
    n = min(c, size(a)[2] - c)
    left, right = a[:, c-n+1:c], a[:, c+1:c+n]
    return left, right
end

num_differences(l, r) = sum(l .⊻ r[:, end:-1:1])

function is_reflection(l::AbstractMatrix, r::AbstractMatrix)::Bool
    num_differences(l, r) == 0
end
is_reflection([0 0 1; 0 0 1; 0 1 0] .== 1, [1 0 0; 1 0 0; 0 1 0] .== 1)
##
function get_reflection_border(a::AbstractMatrix, dim::Int; num_smudges::Int=0)
    if dim == 1
        a = permutedims(a)
    end
    for i in 1:(size(a)[2]-1)
        left, right = splitborder(a, i)
        if num_differences(left, right) == num_smudges
            return i
        end
    end
    return 0
end
##
# Part 1
sum(get_reflection_border.(patterns, 2)) + 100 * sum(get_reflection_border.(patterns, 1))
##
# Part 2
sum(get_reflection_border.(patterns, 2, num_smudges=1)) + 100 * sum(get_reflection_border.(patterns, 1, num_smudges=1))

##
