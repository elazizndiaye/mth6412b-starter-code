# Programme principal
include("node.jl");
include("edge.jl");
include("read_stsp.jl");
include("graph.jl");
include("min_span_tree.jl")

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
            mst = kruskal(graph);
            println("$(weight_mst(mst)) (poids total) ✓");
        end
    end
    
end

main()

