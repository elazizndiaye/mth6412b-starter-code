
"""Retourne le poids total d'une tournée."""
function weight_cycle(cycle)
    total_weight = 0
    for iedge = 1:length(cycle)
        edge = cycle[iedge]
        total_weight += weight(edge)
    end
    total_weight
end

"""Retourne les solutions optimales des problèmes TSP."""
function get_tsp_optimal_solutions()
    optimal_solutions = Dict{String}{Int}()
    optimal_solutions["bayg29"] = 1610
    optimal_solutions["bays29"] = 2020
    optimal_solutions["brazil58"] = 25395
    optimal_solutions["brg180"] = 1950
    optimal_solutions["dantzig42"] = 699
    optimal_solutions["fri26"] = 937
    optimal_solutions["gr17"] = 2085
    optimal_solutions["gr21"] = 2707
    optimal_solutions["gr24"] = 1272
    optimal_solutions["gr48"] = 5046
    optimal_solutions["gr120"] = 6942
    optimal_solutions["hk48"] = 11461
    optimal_solutions["pa561"] = 2763
    optimal_solutions["swiss42"] = 1273
    return optimal_solutions
end

"""Retourne la solution optimale d'un problème TSP."""
function get_tsp_optimal_solution(tsp_file::AbstractString)
    if tsp_file == "bayg29"
        return 1610
    elseif tsp_file == "bays29"
        return 2020
    elseif tsp_file == "brazil58"
        return 25395
    elseif tsp_file == "brg180"
        return 1950
    elseif tsp_file == "dantzig42"
        return 699
    elseif tsp_file == "fri26"
        return 937
    elseif tsp_file == "gr17"
        return 2085
    elseif tsp_file == "gr21"
        return 2707
    elseif tsp_file == "gr24"
        return 1272
    elseif tsp_file == "gr48"
        return 5046
    elseif tsp_file == "gr120"
        return 6942
    elseif tsp_file == "hk48"
        return 11461
    elseif tsp_file == "pa561"
        return 2763
    elseif tsp_file == "swiss42"
        return 1273
    else
        error("File not found")
    end
end

"""Calcule l'erreur relative de la solution approximative."""
function compute_relative_error(weight_approx, weight_optimal)
    error_ = abs(weight_approx - weight_optimal) / weight_optimal
    return error_
end

"Affiche la solution tsp"
function plot_tsp_solution(tsp_file::AbstractString, nodes_cycle)
    fig = plot(legend = false)
    verbose_flag = false
    nodes, edges = read_stsp(tsp_file; verbose_flag)
    if isempty(nodes)
        println("The TSP solution cannot be displayed. The coordinates are not given.")
        return
    end
    # edge positions
    for i = 1:length(nodes_cycle)-1
        n1 = data(nodes_cycle[i])
        n2 = data(nodes_cycle[i+1])
        plot!([nodes[n1][1], nodes[n2][1]], [nodes[n1][2], nodes[n2][2]],
            linewidth = 1.5, alpha = 0.75, color = :lightgray)
    end
    # close cycle
    n1 = data(nodes_cycle[end])
    n2 = data(nodes_cycle[1])
    plot!([nodes[n1][1], nodes[n2][1]], [nodes[n1][2], nodes[n2][2]],
        linewidth = 1.5, alpha = 0.75, color = :lightgray, title = "$(basename(tsp_file)[1:end-4])")
    # node positions
    xys = values(nodes)
    x = [xy[1] for xy in xys]
    y = [xy[2] for xy in xys]
    scatter!(x, y)
    display(fig)
end