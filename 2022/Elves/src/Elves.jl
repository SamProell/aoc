module Elves

export read_elves_calories, most_calories_carried, sum_top_n_elves

"""
    read_elves(filename)

Read data on calories carried by each elf.
"""
function read_elves_calories(filename)
    elves::Vector{Vector{Int}} = [[]]
    for num in eachline(filename)
        if length(num) == 0
            push!(elves, [])
        else
            push!(elves[end], parse(Int, num))
        end
    end
    return elves
end

"""
    most_calories_carried(elves)

Find  the elf carrying most calories and the total amount carried.
"""
function most_calories_carried(elves::Vector{Vector{Int}})
    return findmax(map(sum, elves))
end

"""
    sum_top_n_elves(elves[, n])

Sum the calories carried by the n top elves.
"""
function sum_top_n_elves(elves::Vector{Vector{Int}}; n::Int=3)::Int
    return sum(sort(map(sum, elves))[end-n+1:end])
end

end # module Elves
