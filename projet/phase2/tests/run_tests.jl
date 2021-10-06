include("test_node.jl");
include("test_edge.jl");
include("test_graph.jl");
include("test_min_span_tree.jl")

run_test_node();
run_test_edge();
run_test_graph();
run_test_connected_components();
run_test_kruskal();