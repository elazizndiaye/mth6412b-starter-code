# Programme principal
using Printf

include("node.jl");
include("edge.jl");
include("read_stsp.jl");
include("graph.jl");
include("mst_kruskal.jl")
include("mst_prim.jl")
include("tsp_rsl.jl")
include("tsp.jl")

""" Lit un fichier tsp et appliques les algorithmes de krusl, Prim, RSL et Held et Karp."""
function run_tsp_instance(instance)
    showgraph = false
    plotgraph = true
    # Lecture et stockage du graph
    filename = basename(instance)[1:end-4]
    graph = stsp_to_graph(instance; plot_graph_flag = plotgraph)
    # Arbre de recouvrement minimal du graph
    println("Arbre de recouvrement minimal : -v")
    mst_kruskal = kruskal(graph)
    println("\tKruskl : $(weight_mst(mst_kruskal))")
    mst_prim, _ = prim(graph)
    println("\tPrim : $(weight_mst(mst_prim))")
    # Cycle Hamiltonien
    println("Cycle Hamiltonien : -v")
    # # RSL
    tri_ineq = false
    # tri_ineq = check_triangular_inequality(graph)
    optimal = get_tsp_optimal_solution(filename)
    rsl_cycle, rsl_nodes_cycle = rsl(graph)
    # rsl_cycle, _, _ = rsl(graph, optimal)
    println("\tOptimal cycle = $optimal")
    rsl_cycle_weight = weight_cycle(rsl_cycle)
    error_rsl = compute_relative_error(rsl_cycle_weight, optimal)
    check_ineq_rsl = rsl_cycle_weight <= 2 * optimal
    @printf("\tRSL cycle weight = %d [Relative Error (%.2f%%)] - [Triangular inequality (%s)] - [%d ≤ 2×%d (%s)]\n", rsl_cycle_weight, 100 * error_rsl, tri_ineq, rsl_cycle_weight, optimal, check_ineq_rsl)
    # Affichage de la solution rsl
    fig = plot_tsp_solution(instance, rsl_nodes_cycle)
    fig
end

""" Programme principal. """
function main()
    showgraph = false
    plotgraph = true
    for (root, dirs, files) in walkdir("instances/stsp/")
        for file in files
            # Lecture et stockage du graph
            filepath = joinpath(root, file)
            filename = basename(filepath)[1:end-4]
            graph = stsp_to_graph(filepath; show_graph_flag = showgraph, plot_graph_flag = plotgraph)
            # Arbre de recouvrement minimal du graph
            println("Arbre de recouvrement minimal : -v")
            mst_kruskal = kruskal(graph)
            println("\tKruskl : $(weight_mst(mst_kruskal))")
            mst_prim, _ = prim(graph)
            println("\tPrim : $(weight_mst(mst_prim))")
            # Cycle Hamiltonien
            println("Cycle Hamiltonien : -v")
            # # RSL
            tri_ineq = false
            # tri_ineq = check_triangular_inequality(graph)
            optimal = get_tsp_optimal_solution(filename)
            rsl_cycle, _ = rsl(graph)
            # rsl_cycle, _, _ = rsl(graph, optimal)
            println("\tOptimal cycle = $optimal")
            rsl_cycle_weight = weight_cycle(rsl_cycle)
            error_rsl = compute_relative_error(rsl_cycle_weight, optimal)
            check_ineq_rsl = rsl_cycle_weight <= 2 * optimal
            @printf("\tRSL cycle weight = %d [Relative Error (%.2f%%)] - [Triangular inequality (%s)] - [%d ≤ 2×%d (%s)]\n", rsl_cycle_weight, 100 * error_rsl, tri_ineq, rsl_cycle_weight, optimal, check_ineq_rsl)
        end
    end
end


main()
# run_tsp_instance("C:/Users/dabakh/Desktop/A21/MTH6412B/Code/Projet/mth6412b-starter-code/instances/stsp/bayg29.tsp")

# file = "C:/Users/dabakh/Desktop/A21/MTH6412B/Code/Projet/mth6412b-starter-code/instances/stsp/bayg29.tsp"
