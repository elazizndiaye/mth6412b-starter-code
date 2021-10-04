include("../edge.jl");

using Test

print("Test de la structure de donnée `Edge` : ")

# Constructeur
node1 = Node("a", 2); 
node2 = Node("b", 1); 
poids = 12.5
edge1 = Edge{Int,Float64}("E1", node1, node2, poids);

# Accesseurs
@test name(edge1) == "E1"
@test nodes(edge1) == (node2, node1);
@test start_node(edge1) == node2;
@test end_node(edge1) == node1;
@test weight(edge1) == poids;

# Opérateurs de comparaison
node3 = Node("c", 3);
edge2 = Edge{Int,Float64}("E2", node2, node3, 50.0);
edge3 = Edge{Int,Float64}("E3", node3, node1, 7.52);
edge4 = Edge{Int,Float64}("E4", node2, node1, 25.0);

@test edge1 < edge2
@test edge3 < edge1
@test edge1 == edge4

println("✓")