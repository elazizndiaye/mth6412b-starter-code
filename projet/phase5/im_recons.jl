include("../../shredder-julia/bin/tools.jl")

"""Retourne le vecteur tour obtenu avec l'algorithme RSL."""
function rsl_tour(nodes_tsp)
    tour = Int[]
    for node in nodes_tsp
        push!(tour, data(node) - 1)
    end
    tour
end

"""Retourne le vecteur tour obtenu avec l'algorithme HK."""
function hk_tour(one_tree)
    tour = Int[]
    tour
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
