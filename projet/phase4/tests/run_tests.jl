include("test_node.jl");
include("test_edge.jl");
include("test_graph.jl");
include("test_mst_kruskal.jl")
include("test_mst_prim.jl")
include("test_tsp_rsl.jl")

run_test_node();
run_test_edge();
run_test_graph();
run_test_connected_components();
run_test_kruskal();
run_test_componentPrim();
run_test_prim();
run_test_tsp_rsl();