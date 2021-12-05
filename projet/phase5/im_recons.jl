include("../../shredder-julia/bin/tools.jl")

"""Retourne le vecteur tour obtenu avec les algorithmes RSL et HK."""
function nodes_tsp_to_tour(nodes_tsp)
    tour = Int[]
    index = 1
    for i = 1:length(nodes_tsp)
        if data(nodes_tsp[i]) == 1
            index = i
            break
        end
    end
    for j = index:length(nodes_tsp)
        push!(tour, data(nodes_tsp[j]) - 1)
    end
    for j = 1:index-1
        push!(tour, data(nodes_tsp[j]) - 1)
    end
    tour
end


"""Retourne le vecteur tour inversé (permet de retourner l'image)."""
function inverse_tour(tour)
    inv_tour = copy(tour)
    inv_tour[1] = 0
    inv_tour[2:end] = tour[end:-1:2]
    inv_tour
end

"""Ajuste les poids des arêtes reliés au noeud zéro pour aider l'algorithme RSL."""
function adjust_graph_weight!(graph::AbstractGraph)
    edges_ = edges(graph)
    max_weight = 0
    for edge in edges_
        if weight(edge) > max_weight
            max_weight = weight(edge)
        end
    end
    for edge in edges_
        if data(start_node(edge)) == 1 || data(end_node(edge)) == 1
            set_weight!(edge, max_weight + 1)
        end
    end
    graph
end

"""Reconstruit une instance en utilisant l'algorithme RSL."""
function rsl_reconstruct_image(instance_tsp::String, instance_shuffled::String; index_node_source = 1, inverse_tour_flag = false, verbose_flag = false)
    image_name = basename(instance_tsp)[1:end-4]
    graph = stsp_to_graph(instance_tsp; verbose_flag = verbose_flag)
    adjust_graph_weight!(graph)
    nodes_ = nodes(graph)
    node_source = nodes_[index_node_source]
    rsl_cycle, rsl_nodes_cycle = rsl(graph; node_source = node_source)
    rsl_cycle_weight = weight_cycle(rsl_cycle)
    # Ecriture de la tournée
    tour = nodes_tsp_to_tour(rsl_nodes_cycle)
    if inverse_tour_flag
        tour = inverse_tour(tour)
    end
    tour_file = "projet/phase5/reconstructed_images/tours/$image_name.rsl.tour"
    image_file = "projet/phase5/reconstructed_images/images/$image_name.rsl.png"
    write_tour(tour_file, tour, Float32(rsl_cycle_weight))
    reconstruct_picture(tour_file, instance_shuffled, image_file; view = true)
    println("Case: $image_name: total tour weight (RSL) = $rsl_cycle_weight")
end

"""Reconstruit une instance en utilisant l'algorithme de HK."""
function hk_reconstruct_image(instance_tsp::String, instance_shuffled::String; index_node_source = 1, inverse_tour_flag = false, verbose_flag = false, hk_mst_alg = "PRIM", hk_step = 1, hk_n_iterations = 50)
    image_name = basename(instance_tsp)[1:end-4]
    graph = stsp_to_graph(instance_tsp, verbose_flag = verbose_flag)
    nodes_ = nodes(graph)
    node_source = nodes_[index_node_source]
    _, _, _, tour_edges, tour_nodes = hk(graph; node_source = node_source, mst_alg = hk_mst_alg, step = hk_step, n_iterations = hk_n_iterations, verbose = false)
    hk_cycle_weight = weight_cycle(tour_edges)
    # Ecriture de la tournée
    tour = nodes_tsp_to_tour(tour_nodes)
    if inverse_tour_flag
        tour = inverse_tour(tour)
    end
    tour_file = "./projet/phase5/reconstructed_images/tours/$image_name.hk.tour"
    image_file = "./projet/phase5/reconstructed_images/images/$image_name.hk.png"
    write_tour(tour_file, tour, Float32(hk_cycle_weight))
    reconstruct_picture(tour_file, instance_shuffled, image_file; view = true)
    println("Case: $image_name: total tour weight (HK) = $hk_cycle_weight")
end
