# Programme principal
using Printf, Random, FileIO, Images, ImageView, ImageMagick

include("node.jl");
include("edge.jl");
include("read_stsp.jl");
include("graph.jl");
include("mst_kruskal.jl")
include("mst_prim.jl")
include("tsp_rsl.jl")
include("tsp_hk.jl")
include("tsp.jl")
include("../../shredder-julia/bin/tools.jl")
include("im_recons.jl")

""" Lit un fichier tsp et appliques les algorithmes de krusl, Prim, RSL et Held et Karp."""
function run_tsp_instance(instance;
    rsl_flag = true, index_node_source = 1, rsl_check_triangular_ineq = false,
    hkl_flag = true, hk_mst_alg = "PRIM", hk_step = 1, hk_n_iterations = 100, hk_verbose = false
)
    # Lecture et stockage du graph
    filename = basename(instance)[1:end-4]
    graph = stsp_to_graph(instance)
    nodes_ = nodes(graph)
    node_source = nodes_[index_node_source]
    # Arbre de recouvrement minimal du graph
    println("Arbre de recouvrement minimal : -v")
    mst_kruskal = kruskal(graph)
    println("\tKruskl : $(weight_mst(mst_kruskal))")
    mst_prim, _ = prim(graph)
    println("\tPrim : $(weight_mst(mst_prim))")
    # Cycle Hamiltonien
    println("TSP solution: -v")
    optimal = get_tsp_optimal_solution(filename)
    println("\tOptimal cycle = $optimal")
    # RSL
    if rsl_flag
        @printf("\tRSL algorithm:\n")
        if rsl_check_triangular_ineq
            tri_ineq = check_triangular_inequality(graph)
            @printf("\t\tTriangular inequality :%s\n", tri_ineq)
        end
        # Calcul de la solution
        rsl_cycle, rsl_nodes_cycle = rsl(graph; node_source = node_source)
        rsl_cycle_weight = weight_cycle(rsl_cycle)
        error_rsl = compute_relative_error(rsl_cycle_weight, optimal)
        check_ineq_rsl = rsl_cycle_weight <= 2 * optimal
        @printf("\t\tRSL cycle weight = %d\n\t\tRelative Error = %.2f%%\n\t\t %d ≤ 2×%d (%s)\n", rsl_cycle_weight, 100 * error_rsl, rsl_cycle_weight, optimal, check_ineq_rsl)
        # Affichage de la solution rsl
        plot_tsp_rsl_solution(instance, rsl_nodes_cycle)
    end
    if hkl_flag
        @printf("\tHK algorithm:\n")
        # Calcul de la solution
        hk_one_tree, W_hk = hk(graph; node_source = node_source, mst_alg = hk_mst_alg, step = hk_step, n_iterations = hk_n_iterations, verbose = hk_verbose)
        error_hk = compute_relative_error(W_hk, optimal)
        @printf("\t\tHK cycle weight = %d\n\t\tRelative Error = %.2f%%\n", W_hk, 100 * error_hk)
        # Affichage de la solution HK
        plot_tsp_hk_solution(instance, hk_one_tree)
    end
end

""" Programme principal. """
function main()
    showgraph = false
    plotgraph = true
    for (root, dirs, files) in walkdir("instances/stsp/")
        for file in files
            # Lecture et stockage du graph
            filepath = joinpath(root, file)
            run_tsp_instance(filepath)
        end
    end
end

"""Reconstruit une instance en utilisant l'algorithme RSL."""
function rsl_reconstruct_image(instance_tsp::String, instance_shuffled::String; index_node_source = 1)
    image_name = basename(instance_tsp)[1:end-4]
    graph = stsp_to_graph(instance_tsp)
    adjust_graph_weight!(graph)
    nodes_ = nodes(graph)
    node_source = nodes_[index_node_source]
    rsl_cycle, rsl_nodes_cycle = rsl(graph; node_source = node_source)
    rsl_cycle_weight = weight_cycle(rsl_cycle)
    # Ecriture de la tournée
    tour = rsl_tour(rsl_nodes_cycle)
    inv_tour = inverse_tour(tour)
    tour_file = "./projet/phase5/reconstructed_images/tours/$image_name.tour"
    inv_tour_file = "./projet/phase5/reconstructed_images/tours/$image_name.inv.tour"
    image_file = "./projet/phase5/reconstructed_images/images/$image_name.png"
    inv_image_file = "./projet/phase5/reconstructed_images/images/$image_name.inv.png"
    write_tour(tour_file, tour, Float32(rsl_cycle_weight))
    write_tour(inv_tour_file, inv_tour, Float32(rsl_cycle_weight))
    reconstruct_picture(tour_file, instance_shuffled, image_file; view = true)
    reconstruct_picture(inv_tour_file, instance_shuffled, inv_image_file; view = true)
end

instance_tsp = "./shredder-julia/tsp/instances/alaska-railroad.tsp"
instance_shuffled = "./shredder-julia/images/shuffled/alaska-railroad.png"
rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 56)

# Executer toutes les instances
#main()
