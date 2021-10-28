include("../min_span_tree.jl")

using Test

function run_test_connected_components()
    print("Test de la structure de données `Component` : ")
    # Constructeur de Component
    node_a = Node("a", 1); 
    node_b = Node("b", 2); 
    comp1 = Component(node_a, node_b);
    comp2 = Component(node_b);

    # Accesseurs et mutateurs de Component
    @test parent(comp1) == node_b;
    @test parent(comp2) == node_b;
    @test node(comp1) == node_a;
    node_c = Node("c", 3);
    set_parent!(comp2, node_c);
    @test parent(comp2) == node_c;
    println("-v");

    print("Test de la structure de données `ConnectedComponents` : ")

    # Constructeur d'un ensemble de composantes connexes
    connec_compos = ConnectedComponents([comp1,comp2])

    # Ajout d'une composante
    comp3 = Component(node_c);
    add_component!(connec_compos, comp3);

    # Find root
    @test find_root(connec_compos, node_a) == node_c

    # Fusion de composantes connexes
    node_d = Node("d", 4);
    node_e = Node("e", 5); 
    comp4 = Component(node_d, node_e);
    comp5 = Component(node_e);
    add_component!(connec_compos, comp4);
    add_component!(connec_compos, comp5);
    @test find_root(connec_compos, node_a) != find_root(connec_compos, node_d)
    union_components!(connec_compos, node_a, node_d);
    @test find_root(connec_compos, node_a) == find_root(connec_compos, node_d)

    println("-v");
end

function run_test_kruskal()
    print("Test de l'algorithme de Kruskal : ")
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
    G = Graph("G1", [node1,node2,node3,node4,node5,node6,node7,node8,node9],
                 [edge1,edge2,edge3,edge4,edge5,edge6,edge7,edge8,edge9,edge10,edge11,edge12,edge13])

    # Arbre de recouvrement minimal
    mst_test = kruskal(G);
    # Arbre de recouvrement exact
    mst_exact = [edge1,edge2,edge5,edge6,edge7,edge8,edge11,edge12]
    sort!(mst_exact)
    # Test
    @test length(mst_test) == 8; # taille des vecteurs
    @test weight_mst(mst_test) == 37; # Poids total de l'arbre minimal
    for iedge = 1:length(mst_test)
        @test mst_test[iedge] == mst_exact[iedge]; # arêtes de l'arbre
    end
    println("-v")
end
