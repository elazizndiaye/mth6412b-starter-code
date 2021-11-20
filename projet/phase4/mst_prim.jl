import Base.show, Base.isless
include("queue.jl")

"""Type representant un noeud d'une composante connexe d'un graphe."""
mutable struct ComponentPrim{T}
    node::Node{T}
    parent
    min_weight
end

"""Construit une composante connexe à partir d'un noeud."""
ComponentPrim(node::Node{T}) where {T} = ComponentPrim{T}(node, nothing, Inf);

"""Retourne le parent d'un noeud-composante."""
parent(compo::ComponentPrim{T}) where {T} = compo.parent;

"""Retourne le noeud d'un noeud-composante."""
node(compo::ComponentPrim{T}) where {T} = compo.node;

"""Retourne le poids d'un noeud-composante."""
min_weight(compo::ComponentPrim{T}) where {T} = compo.min_weight;

"""Mute le parent d'un noeud-composante."""
function set_parent!(compo::ComponentPrim{T}, parent) where {T}
    compo.parent = parent
end

"""Mute le poids d'un noeud-composante."""
function set_min_weight!(compo::ComponentPrim{T}, min_weight) where {T}
    compo.min_weight = min_weight
end

"""Compare deux noeud-composantes: inégalité stricte."""
isless(compo1::ComponentPrim{T}, compo2::ComponentPrim{T}) where {T} = min_weight(compo1) < min_weight(compo2);

"""Retourne l'arbre de recouvrement minimal en utilisant l'algorithme de Prim."""
function prim(graph::AbstractGraph; node_source = nothing)
    # Initialisation des noeud-composantes
    compos = Dict{Node{Int},ComponentPrim{Int}}()
    priorityQ = PriorityQueue{ComponentPrim{Int}}()
    nodes_ = nodes(graph)
    nb_nodes_ = nb_nodes(graph)
    for inode = 1:nb_nodes_
        compo = ComponentPrim(nodes_[inode])
        compos[nodes_[inode]] = compo
        push!(priorityQ, compo)
    end
    if node_source === nothing
        node_source = nodes_[1]
    end
    set_min_weight!(compos[node_source], 0)
    # Calcul des listes d'adjacence
    adj_edges_graph = node_to_edges(graph)
    # adj_edges_graph_start, adj_edges_graph = node_to_edges(graph)
    # Construction de l'arbre de recouvrement minimal
    mst = Edge{Int}[]
    nodes_mst = typeof(node_source)[]
    push!(nodes_mst, node_source)
    while !is_empty(priorityQ)
        compo = popfirst!(priorityQ)
        current_node = node(compo)
        parent_compo = parent(compo)
        if parent_compo !== nothing
            push!(mst, parent_compo)
            push!(nodes_mst, current_node)
        end
        # extraction des arêtes adjacents
        # istart = data(current_node)
        # adj_edges = adj_edges_graph[adj_edges_graph_start[istart]:adj_edges_graph_start[istart+1]-1]
        adj_edges = adj_edges_graph[current_node]
        for edge in adj_edges
            other_node = start_node(edge)
            if other_node == current_node
                other_node = end_node(edge)
            end
            other_compo = compos[other_node]
            if in_queue(priorityQ, other_compo) && weight(edge) < min_weight(other_compo)
                set_parent!(other_compo, edge)
                set_min_weight!(other_compo, weight(edge))
            end
        end
    end
    return mst, nodes_mst
end

"""Retourne le poids total de l'arbre de recouvrement minimal."""
function weight_mst(mst::Vector{Edge{Int}})
    total_weight = 0
    for iedge = 1:length(mst)
        edge = mst[iedge]
        total_weight += weight(edge)
    end
    total_weight
end