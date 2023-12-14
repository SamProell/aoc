module Elves
import Base: +, contains, intersect

export Interval, intersect, +, contains, read_char_array

first_digit(s::String)::Char = first(filter(isdigit, s))

WrittenDigits = Dict("one" => "1", "two" => "2", "three" => "3", "four" => "4",
    "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9")


function first_element(iterator)
    for i in iterator
        return i
    end
    return nothing
end

function extract_written_number(s::String)::Int
    matches = eachmatch(r"(one|two|three|four|five|six|seven|eight|nine|\d)", s, overlap=true)
    matched_strings = map(x -> x[1], matches)
    first_string = first_element(matched_strings)
    first = get(WrittenDigits, first_string, first_string)
    second_string = first_element(reverse(matched_strings))
    second = get(WrittenDigits, second_string, second_string)
    return parse(Int, first * second)
end

function extract_number(s::String)::Int
    first = first_digit(s)
    second = first_digit(reverse(s))
    return parse(Int, first * second)
end


struct Interval
    start::Int
    stop::Int
end

function intersect(a::Interval, b::Interval)::Union{Interval,Nothing}
    a, b = sort([a, b], by=i -> i.start)
    start = nothing
    if a.stop >= b.start
        start = b.start
    end
    stop = a.stop - 1
    if stop > b.stop
        stop = b.stop
    end
    if isnothing(start)
        return nothing
    end
    return Interval(start, stop)
end

contains(ab::Interval, c::Int)::Bool = (c >= ab.start) && (c < ab.stop)

+(ab::Interval, c::Int) = Interval(ab.start + c, ab.stop + c)

read_char_array(filename) = permutedims(reduce(hcat, collect.(eachline(filename))))

end # module Elves
