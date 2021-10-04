include("../graph.jl");

using Test

println("Test de la structure de donnée `Graph`")

# Constructeur
node1 = Node("a", 2); 
node2 = Node("b", 1); 
poids = 12.5
edge1 = Edge{Int,Float64}("E1", node1, node2, poids);
graph = Graph("G1", [node1,node2], [edge1])

# Mutateurs
node3 = Node("c", 3);
add_node!(graph,node3);
edge2 = Edge{Int,Float64}("E2", node2, node3, 50.0);
edge3 = Edge{Int,Float64}("E3", node3, node1, 7.52);
add_edge!(graph,edge2);
add_edge!(graph,edge3);

# Accesseurs
@test name(graph) == "G1"
@test nb_nodes(graph) == 3;
@test nodes(graph) == [node1, node2, node3];
@test nb_edges(graph) == 3;
@test edges(graph) == [edge1, edge2, edge3];
@test start_node(edge1) == node2;
@test end_node(edge1) == node1;
@test weight(edge1) == poids;

# Fonction de tri
edges_sorted = sort_edge(graph);
@test edges_sorted == [edge3, edge1, edge2];

println("✓")