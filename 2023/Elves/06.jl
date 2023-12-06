##
using Revise
using Elves
##
struct RaceRecord
    dur::Int
    dist::Int
end
function read_race_records(filename::AbstractString)::Vector{RaceRecord}
    lines = readlines(filename)
    times = [parse(Int, t) for t in split(split(lines[1], ":")[2])]
    distances = [parse(Int, d) for d in split(split(lines[2], ":")[2])]
    return map(p -> RaceRecord(p...), zip(times, distances))
end

records = read_race_records("2023/data/06.txt")
##
function possible_outcomes(dur::Int)::Vector{Int}
    # distances = []
    # for pressed in range(dur)
    #     push!(distances, pressed * (dur - pressed))
    # end
    # return distances
    return [pressed * (dur - pressed) for pressed in range(0, dur)]
end
##
function better_outcomes(record::RaceRecord)::Vector{Int}
    possible = possible_outcomes(record.dur)
    return filter(dist -> dist > record.dist, possible)
end
# Part 1: 275724
prod(map(r -> length(better_outcomes(r)), records))

## 
function read_race_record2(filename::AbstractString)::RaceRecord
    lines = readlines(filename)
    getnumber(l) = parse(Int, replace(split(l, ":")[2], " " => ""))
    return RaceRecord(getnumber(lines[1]), getnumber(lines[2]))
end

race_record = read_race_record2("2023/data/06.txt")
# Part 2: 37286485
length(better_outcomes(race_record))
##
