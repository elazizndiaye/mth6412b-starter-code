# Programme principal
include("node.jl");
include("edge.jl");
include("read_stsp.jl");
include("graph.jl");
include("mst_kruskal.jl")
include("mst_prim.jl")
include("tsp_rsl.jl")
include("tsp.jl")

""" Programme principal. """
function main()
    showgraph = false
    plotgraph = false
    for (root, dirs, files) in walkdir("instances/stsp/")
        for file in files
            # Lecture et stockage du graph
            graph = stsp_to_graph(joinpath(root, file); show_graph_flag = showgraph, plot_graph_flag = plotgraph)
            # Arbre de recouvrement minimal du graph
            println("Arbre de recouvrement minimal : -v")
            mst_kruskal = kruskal(graph)
            println("\tKruskl : $(weight_mst(mst_kruskal))")
            mst_prim, _ = prim(graph)
            println("\tPrim : $(weight_mst(mst_prim))")
            # Cycle Hamiltonien
            println("Cycle Hamiltonien : -v")
            cycle, nodes_cycle = rsl(graph)
            optimal = 10000
            println("\tOptimal cycle = $optimal")
            rsl_cycle_weight = weight_cycle(cycle)
            println("\tRSL cycle weight = $rsl_cycle_weight ($rsl_cycle_weight ≤ 2×$optimal)")
        end
    end
end


main()

