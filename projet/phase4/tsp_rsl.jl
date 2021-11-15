
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

