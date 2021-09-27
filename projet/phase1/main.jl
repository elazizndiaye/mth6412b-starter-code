# Programme principal
include("node.jl");
include("edge.jl");
include("graph.jl");
include("read_stsp.jl");

"""Lit un fichier stp et stocke les données dans une structure de type graph.

Exemples :

    graph_structure = main("bayg29.tsp")
    graph_structure = main("bayg29.tsp";show_graph_flag=true)
    graph_structure = main("bayg29.tsp";plot_graph_flag=true)
    graph_structure = main("bayg29.tsp";show_graph_flag=true,plot_graph_flag=true)
"""
function main(filename::String;show_graph_flag=false,plot_graph_flag=false)
    # Lecture du fichier
    println("File: $(basename(filename))")
    graph_nodes, graph_edges, graph_edges_weight = read_stsp(filename);

    # Stockage dans une structure de type Graph
    nodes_list = Node{Int}[]
    for i_node = 1:length(graph_edges)
        push!(nodes_list, Node{Int}("$i_node", i_node));
    end
    edges_list = Edge{Int}[]
    i_edge = 0;
    for i = 1:length(graph_edges)
        node1 = nodes_list[i]
        for j = 1:length(graph_edges[i])
            i_edge += 1;
            node2 = nodes_list[graph_edges[i][j]]
            weight_ = graph_edges_weight[i][j]
            edge = Edge{Int}("$i_edge", [node1,node2], weight_);
            push!(edges_list, edge);
        end
    end
    graph_structure = Graph(basename(filename), nodes_list, edges_list)
    # Affichage du contenu du graphe
    if show_graph_flag
        show(graph_structure)
    end
    if plot_graph_flag
        plot_graph(graph_nodes, graph_edges)
    end
    return graph_structure
end

showgraph = false;
plotgraph = false;
for (root, dirs, files) in walkdir("instances/stsp/")
    for file in files
        graph_ = main(joinpath(root, file);show_graph_flag=showgraph,plot_graph_flag=plotgraph);
    end
end



