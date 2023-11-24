##
"""
    read_elves(filename)

Read data on calories carried by each elf.
"""
function read_elves(filename)
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
##
elves = read_elves("2022/data/01.txt")
##
# Find the elf carrying the most calories.
findmax(map(sum, elves))
##
# Sum the calories of top three elves.
sum(sort(map(sum, elves))[end-2:end])
