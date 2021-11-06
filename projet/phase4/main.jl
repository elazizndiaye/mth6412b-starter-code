# Programme principal
include("node.jl");
include("edge.jl");
include("read_stsp.jl");
include("graph.jl");
include("mst_kruskal.jl")
include("mst_prim.jl")

""" Programme principal. """
function main()
    showgraph = false;
    plotgraph = false;
    for (root, dirs, files) in walkdir("instances/stsp/")
        for file in files
            # Lecture et stockage du graph
            graph = stsp_to_graph(joinpath(root, file);show_graph_flag=showgraph,plot_graph_flag=plotgraph);
            # Arbre de recouvrement minimal du graph
            print("Arbre de recouvrement minimal : ")
            mst_kruskal = kruskal(graph);
            print("$(weight_mst(mst_kruskal)) (Kruskal) ");
            mst_prim = prim(graph);
            println("$(weight_mst(mst_prim)) (Prim) -v");
        end
    end
    
end

main()

