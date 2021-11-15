# include("../tsp_rsl.jl")
# include("../tsp.jl")
# include("../node.jl");
# include("../edge.jl");
# include("../read_stsp.jl");
# include("../graph.jl");

using Test

function run_test_tsp_rsl()
    print("Test de l'algorithme RSL : ")
    G = stsp_to_graph("instances/stsp/bayg29.tsp"; verbose_flag = false)
    total_weight_tsp_optimal = 1610
    cycle, nodes_cycle = rsl(G)
    # print(weight_cycle(cycle))
    @test weight_cycle(cycle) <= 2 * total_weight_tsp_optimal

    println("-v")
end
