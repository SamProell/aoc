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
import LinearAlgebra
function is_reflection(a::AbstractMatrix, b::AbstractMatrix)::Bool
    n = min(size(a)[2], size(b)[2])
    left, right = a[:, end-n+1:end], b[:, n:-1:1]
    return left == right
end
is_reflection([0 0 1; 0 0 1; 0 1 0] .== 1, [1 0 0; 1 0 0; 0 1 0] .== 1)
function get_reflection_border(a::AbstractMatrix, dim::Int)
    if dim == 1
        a = permutedims(a)
    end
    for i in 1:(size(a)[2]-1)
        left, right = view(a, :, 1:i), @view a[:, i+1:end]
        if is_reflection(left, right)
            return i
        end
    end
    return 0
end
sum(get_reflection_border.(patterns, 2)) + 100 * sum(get_reflection_border.(patterns, 1))
