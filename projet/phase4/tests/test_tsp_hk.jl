using Test

function run_test_tsp_hk()
    print("Test de l'algorithme HK : ")
    G = stsp_to_graph("instances/stsp/bayg29.tsp"; verbose_flag = false)
    total_weight_tsp_optimal = 1610
    hk_one_tree, W_hk = hk(G; verbose = false)
    @test W_hk <= total_weight_tsp_optimal
    println("-v")
end
