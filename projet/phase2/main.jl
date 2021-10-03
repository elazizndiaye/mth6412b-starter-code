# Programme principal
include("node.jl");
include("edge.jl");
include("read_stsp.jl");
include("graph.jl");
include("min_span_tree.jl")

""" Programme principal. """
function main()
    # showgraph = false;
    # plotgraph = false;
    # for (root, dirs, files) in walkdir("instances/stsp/")
    #     for file in files
    #         graph_ = stsp_to_graph(joinpath(root, file);show_graph_flag=showgraph,plot_graph_flag=plotgraph);
    #     end
    # end
    node1 = Node("a", 1); node2 = Node("b", 2); node3 = Node("c", 3);
    node4 = Node("d", 4); node5 = Node("e", 5); node6 = Node("f", 6);
    node7 = Node("g", 7); node8 = Node("h", 8); node9 = Node("i", 9);
    edge1 = Edge{Int64,Int64}("a <-> b", node1, node2, 4);
    edge2 = Edge{Int64,Int64}("a <-> h", node1, node8, 8);
    edge3 = Edge{Int64,Int64}("b <-> c", node2, node3, 8);
    edge4 = Edge{Int64,Int64}("b <-> h", node2, node8, 11);
    edge5 = Edge{Int64,Int64}("c <-> d", node3, node4, 7);
    edge6 = Edge{Int64,Int64}("c <-> f", node3, node6, 4);
    edge7 = Edge{Int64,Int64}("c <-> i", node3, node9, 2);
    edge8 = Edge{Int64,Int64}("d <-> e", node4, node5, 9);
    edge9 = Edge{Int64,Int64}("d <-> f", node4, node6, 14);
    edge10 = Edge{Int64,Int64}("e <-> f", node5, node6, 10);
    edge11 = Edge{Int64,Int64}("f <-> g", node6, node7, 2);
    edge12 = Edge{Int64,Int64}("g <-> h", node7, node8, 1);
    edge13 = Edge{Int64,Int64}("g <-> i", node7, node9, 6);
    G = Graph("Ick", [node1,node2,node3,node4,node5,node6,node7,node8,node9],
                 [edge1,edge2,edge3,edge4,edge5,edge6,edge7,edge8,edge9,edge10,edge11,edge12,edge13])
    mst = kruskal(G);
end

main()

