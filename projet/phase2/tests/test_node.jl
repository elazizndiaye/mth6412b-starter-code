include("../node.jl");

using Test

println("Test de la structure de donnée `Node`")

# Constructeur
node1 = Node("a", 1); 

# Accesseurs
@test name(node1) == "a"
@test data(node1) == 1

# Opérateurs de comparaison
node2 = Node("b", 2); 
@test node1 < node2
node3 = Node("b", 2);
@test node2 == node3
@test node2 != node1

println("✓")