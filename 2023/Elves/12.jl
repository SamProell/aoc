##
using Revise
using Elves
##
function parse_line(line::AbstractString)::Tuple{String,Vector{Int}}
    springs, numbers = split(line)
    return springs, parse.(Int, split(numbers, ","))
end
parse_line("?#?#?#?#?#?#?#? 1,3,1,6")
##
