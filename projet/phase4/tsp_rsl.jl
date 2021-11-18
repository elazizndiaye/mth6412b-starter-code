
"""Retourne une tournée à travers l'algorithme RSL."""
function rsl(graph::AbstractGraph; node_source = nothing)
    _, nodes_mst = prim(graph; node_source = node_source)
    closing_edge = find_edge(graph, nodes_mst[end], nodes_mst[1])
    cycle = typeof(closing_edge)[]
    push!(cycle, closing_edge)
    for inode = 1:length(nodes_mst)-1
        edge = find_edge(graph, nodes_mst[inode], nodes_mst[inode+1])
        push!(cycle, edge)
    end
    cycle, nodes_mst
end

"""Retourne une tournée idéale à travers l'algorithme RSL."""
function rsl(graph::AbstractGraph, optimal_weight)
    rsl_error = Inf
    rsl_node_source = nothing
    rsl_nodes = nothing
    rsl_cycle = nothing
    nodes_ = nodes(graph)
    for node in nodes_
        cycle, nodes_mst = rsl(graph; node_source = node)
        rsl_cycle_weight = weight_cycle(cycle)
        error_ = compute_relative_error(rsl_cycle_weight, optimal_weight)
        if error_ < rsl_error
            rsl_node_source = node
            rsl_cycle = cycle
            rsl_nodes = nodes_mst
            rsl_error = error_
        end
    end
    rsl_cycle, rsl_nodes, rsl_node_source
end

"""Vérifie l'inégalité triangulaire pour un graphe donné."""
function check_triangular_inequality(graph::AbstractGraph)
    nodes_ = nodes(graph)
    for inode1 = 1:length(nodes_)
        node1 = nodes_[inode1]
        for inode2 = inode1+1:length(nodes_)
            node2 = nodes_[inode2]
            edge12 = find_edge(graph, node1, node2)
            weight12 = weight(edge12)
            for inode3 = inode2+1:length(nodes_)
                node3 = nodes_[inode3]
                edge13 = find_edge(graph, node1, node3)
                edge23 = find_edge(graph, node2, node3)
                weight13 = weight(edge13)
                weight23 = weight(edge23)
                if (weight12 > (weight13 + weight23)) || (weight13 > (weight12 + weight23)) || (weight23 > (weight12 + weight13))
                    return false
                end
            end
        end
    end
    return true
end
