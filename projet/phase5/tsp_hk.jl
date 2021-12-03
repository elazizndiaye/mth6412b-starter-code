using Printf

"""Retourne une tournée à travers l'algorithme de Held et Karp."""
function hk(graph::AbstractGraph; node_source = nothing, mst_alg = "PRIM", step = 1.0, n_iterations = 100, verbose = true)
    graph_copy = deepcopy(graph)
    nodes_ = nodes(graph_copy)
    n_nodes = length(nodes_)
    if node_source === nothing
        node_source = nodes_[1]
    end
    sub_graph_init, adj_list_node_source = generate_sub_graph(graph_copy, node_source)
    W = -Inf
    k = 0
    pi_k = zeros(n_nodes)
    period_verbose = 20
    if verbose
        @printf("********** \tHeld and Karp\t **********\n")
        @printf("n_iterations (%d) - mst_algorithm (%s) - step size (%.1f) - node source (%d)\n", n_iterations, mst_alg, step, data(node_source))
        @printf("Iteration\tMean(v)\t\tWeight_Iteration\tMax_Weight\n")
    end
    min_one_tree = nothing
    while k < n_iterations
        sub_graph = deepcopy(sub_graph_init)
        adj_list_ns = deepcopy(adj_list_node_source)
        min_one_tree = compute_min_tree!(sub_graph, adj_list_ns, pi_k, node_source, mst_alg)
        weight_k = length_tree(min_one_tree) - 2 * sum(pi_k)
        W = max(W, weight_k)
        v_k = node_degrees(min_one_tree, n_nodes) .- 2
        if all(v_k .== 0)
            # Optimal value found
            return min_one_tree, W
        end
        pi_k = pi_k .+ step * v_k
        k = k + 1
        if verbose && rem(k - 1, period_verbose) == 0
            @printf("%d\t\t%.1e\t\t%.1f\t\t\t%.1f\n", k, sum(abs.(v_k)) / length(v_k), weight_k, W)
        end
    end
    return min_one_tree, W
end

"""Génére un sous-graphe en retirant un noeud."""
function generate_sub_graph(graph, node_source)
    edges_ = edges(graph)
    adj_list_node_source = typeof(edges_[1])[]
    n_edges = length(edges_)
    i_edge = 1
    while i_edge <= n_edges
        edge = edges_[i_edge]
        if (start_node(edge) == node_source) || (end_node(edge) == node_source)
            push!(adj_list_node_source, edge)
            popat!(edges_, i_edge)
            n_edges -= 1
        else
            i_edge += 1
        end
    end
    nodes_ = nodes(graph)
    for i = 1:length(nodes_)
        if nodes_[i] == node_source
            popat!(nodes_, i)
            break
        end
    end
    sub_graph = Graph(name(graph), nodes_, edges_)
    return sub_graph, adj_list_node_source
end

"""Calcule le minimume 1_tree de la graphe en entrée."""
function compute_min_tree!(sub_graph, adj_list_node_source, pi_k, node_source, mst_alg)
    edges_ = edges(sub_graph)
    for edge in edges_
        weight_edge = weight(edge)
        pi_k1 = pi_k[data(start_node(edge))]
        pi_k2 = pi_k[data(end_node(edge))]
        set_weight!(edge, weight_edge + pi_k1 + pi_k2)
    end
    for edge in adj_list_node_source
        weight_edge = weight(edge)
        pi_k1 = pi_k[data(start_node(edge))]
        pi_k2 = pi_k[data(end_node(edge))]
        set_weight!(edge, weight_edge + pi_k1 + pi_k2)
    end
    if mst_alg == "PRIM"
        mst, _ = prim(sub_graph)
    else
        mst = kruskal(sub_graph)
    end

    min_weight1 = Inf
    edge1 = nothing
    min_weight2 = Inf
    edge2 = nothing
    for edge in adj_list_node_source
        weight_edge = weight(edge)
        if weight_edge < min_weight1
            min_weight2 = min_weight1
            edge2 = edge1
            min_weight1 = weight_edge
            edge1 = edge
        elseif weight_edge < min_weight2
            edge2 = edge
            min_weight2 = weight_edge
        end
    end
    push!(mst, edge1)
    push!(mst, edge2)
    return mst
end

"""Retourne le poids du 1_tree."""
function length_tree(one_tree)
    length_ = 0
    for edge in one_tree
        length_ = length_ + weight(edge)
    end
    length_
end

"""Retourne le degré des noeuds d'un graphe."""
function node_degrees(one_tree, n_nodes::Int)
    d_k = zeros(Int, n_nodes)
    for edge in one_tree
        d_k[data(start_node(edge))] += 1
        d_k[data(end_node(edge))] += 1
    end
    d_k
end
