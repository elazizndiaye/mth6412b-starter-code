include("../../shredder-julia/bin/tools.jl")

"""Retourne le vecteur tour obtenu avec l'algorithme RSL."""
function rsl_tour(nodes_tsp)
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

"""Retourne le vecteur tour obtenu avec l'algorithme HK."""
function hk_tour(one_tree)
    tour = Int[]
    tour
end

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

# """Reconstruit une instance en utilisant l'algorithme RSL."""
# function rsl_reconstruct_image(filename::String; index_node_source = 1)
#     image_name = basename(filename)[1:end-4]
#     graph = stsp_to_graph(filename)
#     nodes_ = nodes(graph)
#     node_source = nodes_[index_node_source]
#     rsl_cycle, rsl_nodes_cycle = rsl(graph; node_source = node_source)
#     rsl_cycle_weight = weight_cycle(rsl_cycle)
#     # Ecriture de la tournée
#     tour = rsl_tour(rsl_nodes_cycle)
#     tour_file = "./reconstructed_images/tour/$image_name.tour"
#     image_file = "./reconstructed_images/tour/$image_name.png"
#     write_tour(tour_file, tour, rsl_cycle_weight)
#     reconstruct_picture(tour_file, filename, image_file; view = true)
# end

# instance = "../../shredder-julia/tsp/instances/abstract-light-painting.tsp"
# rsl_reconstruct_image(instance)
