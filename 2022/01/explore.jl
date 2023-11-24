##
input_filename = "2022/data/01.txt"

function read_elves(filename)
    elves = [[]]
    for num in eachline(input_filename)
        if length(num) == 0
            push!(elves, [])
        else
            push!(elves[end], parse(Int, num))
        end
    end
    return elves
end
elves = read_elves(input_filename)
##
findmax(map(sum, elves))
##
sum(sort(map(sum, elves))[end-2:end])
