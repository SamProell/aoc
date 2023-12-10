##
using Revise
using Elves
##
mutable struct Node
    name::String
    left::Union{Node,Missing}
    right::Union{Node,Missing}
    function Node(n)
        return new(n, missing, missing)
    end
    function Node(n, l, r)
        return new(n, l, r)
    end
end

function apply_move(node, move::Char)::Node
    if move == 'R'
        return node.right
    else
        return node.left
    end
end

function traverse(node, moves)
    next = node
    count = 0
    for move in Base.Iterators.cycle(moves)
        next = apply_move(next, move)
        count += 1
        # println(count, " ", next.name, " ", move, " ", next.left.name, " ", next.right.name)
        if next.name == "ZZZ"
            return count
        end
    end
end

##
function parse_node(line::AbstractString)::Pair{String,Node}
    parts = split(line, " = ")
    name = parts[1]
    left, right = split(strip(parts[2], ['(', ')']), ", ")
    return name => Node(name, Node(left), Node(right))
end



function parse_map(lines)
    nodes = [parse_node(l) for l in lines]
    node_map = Dict(nodes)
    for (_, node) in nodes
        node.left = node_map[node.left.name]
        node.right = node_map[node.right.name]
    end
    return node_map
end


input_lines = readlines("2023/data/08.txt")

instructions = input_lines[1]
nodemap = parse_map(input_lines[3:end])
traverse(nodemap["AAA"], instructions)
##
function traverse_as_ghost(nodes, moves)
    next_nodes = copy(nodes)
    count = 0
    for move in Base.Iterators.cycle(moves)
        for i in eachindex(next_nodes)
            next_nodes[i] = apply_move(next_nodes[i], move)
        end
        count += 1
        if all(map(n -> endswith(n.name, "Z"), next_nodes))
            return count
        end
    end
end
traverse_as_ghost([n for n in values(nodemap) if endswith(n.name, "A")], instructions)

