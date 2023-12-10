##
using Revise
using Elves
##
mutable struct Node
    name::String
    left::String
    right::String
end

##
function parse_node(line::AbstractString)::Node
    parts = split(line, " = ")
    name = parts[1]
    left, right = split(strip(parts[2], ['(', ')']), ", ")
    return Node(name, left, right)
end



function parse_map(lines)::Tuple{Vector{AbstractString},Vector{Tuple{Int,Int}}}
    nodes = [parse_node(l) for l in lines]
    node_names = [node.name for node in nodes]
    node_indices = Dict([n => i for (i, n) in enumerate(node_names)])
    node_map = []
    for node in nodes
        push!(node_map, (node_indices[node.left], node_indices[node.right]))
    end
    return node_names, node_map
end


input_lines = readlines("2023/data/08.txt")

instructions = input_lines[1]
moves_ind = [(m == 'L' ? 1 : 2) for m in instructions]
node_names, node_map = parse_map(input_lines[3:end])
##
function traverse(start::Int, nodemap::Vector{Tuple{Int,Int}}, moves::Vector{Int}, names::Vector{AbstractString})
    n = 0
    current = start
    for move in Base.Iterators.cycle(moves)
        # println(n, " ", current, " ", names[current])
        if names[current] == "ZZZ"
            break
        end
        n += 1
        current = nodemap[current][move]
    end
    return n
end
# Part 1: 16579
traverse(findall(x -> x == "AAA", node_names)[1], node_map, moves_ind, node_names)
##
function traverse_as_ghost!(
    start::Vector{Int},
    nodemap,
    moves::Vector{Int},
    nodenames::Vector{AbstractString}
)::Int
    n = 0
    # current = copy(start)
    # target_set = Set(target)
    for move in Base.Iterators.cycle(moves)
        # if issetequal(current, target_set)
        # if endswith(node_names[start[6]], "Z")
        if all(endswith(nodenames[c], "Z") for c in start)
            break
        end
        start[1:end] = nodemap[start, move]
        n += 1
        if mod(n, 30_000_000) == 0
            println(n, " ", start)
        end
    end
    return n
end

node_matrix = [tup[k] for tup in node_map, k in 1:2]
target_nodes = findall(x -> endswith(x, "Z"), node_names)
start_nodes = findall(x -> endswith(x, "A"), node_names)
num_moves = [traverse_as_ghost!([node], node_matrix, moves_ind, node_names) for node in start_nodes]
##
# Part 2
lcm(num_moves...)
