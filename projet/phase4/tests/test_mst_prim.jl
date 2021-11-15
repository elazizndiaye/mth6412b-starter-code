include("../mst_prim.jl")

using Test

function run_test_componentPrim()
    print("Test de la structure de données `ComponentPrim` : ")

    # Constructeur de ComponentPrim
    node_a = Node("a", 1)
    node_b = Node("b", 2)
    edge1 = Edge{Int64,Int64}("a <-> b", node_a, node_b, 4)
    comp1 = ComponentPrim(node_a, edge1, 1.0)
    comp2 = ComponentPrim(node_b)

    # Accesseurs et mutateurs de ComponentPrim
    @test node(comp1) == node_a
    @test parent(comp1) == edge1
    @test min_weight(comp1) == 1.0

    @test node(comp2) == node_b
    @test parent(comp2) === nothing
    @test min_weight(comp2) == Inf

    node_c = Node("c", 3)
    edge2 = Edge{Int64,Int64}("b <-> c", node_b, node_c, 8)

    set_parent!(comp2, edge2)
    @test parent(comp2) == edge2

    set_min_weight!(comp2, 3.25)
    @test min_weight(comp2) == 3.25

    println("-v")
end

function run_test_prim()
    print("Test de l'algorithme de Prim : ")

    node1 = Node("a", 1)
    node2 = Node("b", 2)
    node3 = Node("c", 3)
    node4 = Node("d", 4)
    node5 = Node("e", 5)
    node6 = Node("f", 6)
    node7 = Node("g", 7)
    node8 = Node("h", 8)
    node9 = Node("i", 9)
    edge1 = Edge{Int64,Int64}("a <-> b", node1, node2, 4)
    edge2 = Edge{Int64,Int64}("a <-> h", node1, node8, 8)
    edge3 = Edge{Int64,Int64}("b <-> c", node2, node3, 8)
    edge4 = Edge{Int64,Int64}("b <-> h", node2, node8, 11)
    edge5 = Edge{Int64,Int64}("c <-> d", node3, node4, 7)
    edge6 = Edge{Int64,Int64}("c <-> f", node3, node6, 4)
    edge7 = Edge{Int64,Int64}("c <-> i", node3, node9, 2)
    edge8 = Edge{Int64,Int64}("d <-> e", node4, node5, 9)
    edge9 = Edge{Int64,Int64}("d <-> f", node4, node6, 14)
    edge10 = Edge{Int64,Int64}("e <-> f", node5, node6, 10)
    edge11 = Edge{Int64,Int64}("f <-> g", node6, node7, 2)
    edge12 = Edge{Int64,Int64}("g <-> h", node7, node8, 1)
    edge13 = Edge{Int64,Int64}("g <-> i", node7, node9, 6)
    G = Graph("G1", [node1, node2, node3, node4, node5, node6, node7, node8, node9],
        [edge1, edge2, edge3, edge4, edge5, edge6, edge7, edge8, edge9, edge10, edge11, edge12, edge13])

    # Test des listes d'adjacence
    adj_edges_graph_start, adj_edges_graph = node_to_edges(G)
    adj_edges = adj_edges_graph[adj_edges_graph_start[3]:adj_edges_graph_start[4]-1]  # node3
    adj_edges_exact = [edge3, edge5, edge6, edge7] # arêtes qui contiennent node3
    @test length(adj_edges) == length(adj_edges_exact)
    for i = 1:length(adj_edges)
        @test adj_edges[i] == adj_edges_exact[i]
    end

    # Arbre de recouvrement minimal
    mst_test, _ = prim(G)
    sort!(mst_test)
    mst_exact = [edge1, edge2, edge5, edge6, edge7, edge8, edge11, edge12] # Arbre de recouvrement exact
    sort!(mst_exact)

    @test length(mst_test) == 8 # taille des vecteurs
    @test weight_mst(mst_test) == 37 # Poids total de l'arbre minimal
    for iedge = 1:length(mst_test)
        @test weight(mst_test[iedge]) == weight(mst_exact[iedge]) # arêtes de l'arbre
    end

    # Changement du noeud de départ de l'algorithme de Prim
    mst_test, _ = prim(G; node_source = node6)
    @test length(mst_test) == 8 # taille des vecteurs
    @test weight_mst(mst_test) == 37 # Poids total de l'arbre minimal

    println("-v")
end
