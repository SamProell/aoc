##
using Revise
using Elves
##
function parse_seeds(line::AbstractString)::Vector{Int}
    return map(n -> parse(Int, n), split(line)[2:end])
end
parse_seeds("seeds: 79 14 55 13")
##
struct AlamnacRange
    shift::Int
    interval::Interval
end

struct AlmanacMap
    name::String
    ranges::Vector{AlamnacRange}
end

function parse_map(block::AbstractString)
    lines = split(block, "\n")
    name = split(lines[1])[1]
    ranges = []
    for line in lines[2:end]
        if length(line) < 2
            continue
        end
        dest, source, len = map(n -> parse(Int, n), split(line))
        push!(ranges, AlamnacRange(dest - source, Interval(source, source + len)))
    end
    return AlmanacMap(name, ranges)
end

block = """seed-to-soil map:
50 98 2
52 50 48
"""
parse_map(block)
##
almanac_input = replace(read("2023/data/05.txt", String), "\r" => "")
almanac_blocks = split(almanac_input, "\n\n")
seeds = parse_seeds(almanac_blocks[1])
almanac = map(parse_map, almanac_blocks[2:end])
##
function map_value(val::Int, almanac_map::AlmanacMap)::Int
    for r in almanac_map.ranges
        if contains(r.interval, val)
            return val + r.shift
        end
    end
    return val
end

map_value(55, almanac[1])
##
function get_location(seed, almanac)
    newvalue = seed
    for m in almanac
        # print(newvalue, " ", m, "\n")
        newvalue = map_value(newvalue, m)
    end
    return newvalue
end
locations = map(s -> get_location(s, almanac), seeds)
# Part 1
findmin(locations)
##
function parse_seeds2(line::AbstractString)::Vector{Interval}
    numbers = map(n -> parse(Int, n), split(line)[2:end])
    ranges = []
    for i in 1:2:length(numbers)
        start, len = numbers[i:i+1]
        push!(ranges, Interval(start, start + len))
    end
    return ranges
end
parse_seeds2("seeds: 79 14 55 13")
##
seeds2 = parse_seeds2(almanac_blocks[1])
##
function map_range(seed_interval::Interval, almanac_map::AlmanacMap)::Vector{Interval}
    dest_ranges = []
    for r in sort(almanac_map.ranges, by=r -> r.interval.start)
        if seed_interval.start == seed_interval.stop
            break
        end
        overlap = intersect(seed_interval, r.interval)
        if !(isnothing(overlap))
            if overlap.start > seed_interval.start
                push!(dest_ranges, Interval(seed_interval.start, overlap.start))
            end
            push!(dest_ranges, overlap + r.shift)
            if seed_interval.stop >= overlap.stop
                seed_interval = Interval(overlap.stop, seed_interval.stop)
            end
        end
    end
    if seed_interval.start != seed_interval.stop
        push!(dest_ranges, seed_interval)
    end
    return dest_ranges
end
map_range(seeds2[1], almanac[1])
##
function get_location2(seeds::Vector{Interval}, almanac_::Vector{AlmanacMap})::Vector{Interval}
    newvalue::Vector{Interval} = seeds
    for m in almanac_
        newvalue = vcat(map(s -> map_range(s, m), newvalue)...)
    end
    return newvalue
end

locations2 = get_location2(seeds2, almanac)
findmin(map(l -> l.start, locations2))
## 