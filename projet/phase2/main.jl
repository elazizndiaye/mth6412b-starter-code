# Programme principal
include("graph.jl");

""" Programme principal. """
function main()
    showgraph = false;
    plotgraph = false;
    for (root, dirs, files) in walkdir("instances/stsp/")
        for file in files
            graph_ = stsp_to_graph(joinpath(root, file);show_graph_flag=showgraph,plot_graph_flag=plotgraph);
        end
    end
end



