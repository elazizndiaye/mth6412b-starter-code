import Base.show

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T,S} end

"""Type representant un graphe comme un ensemble de noeuds et d'arêtes.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    edge1 = Edge{Float64,Int}("E1",node1,node2,51)
    edge2 = Edge{Float64,Int}("E2",node2,node3,22)
    edge3 = Edge{Float64,Int}("E3",node3,node1,17)
    G = Graph("Ick",[node1, node2, node3], [edge1, edge2, edge3])

Attention, tous les noeuds ainsi que arêtes doivent avoir des données de même type.
"""
mutable struct Graph{T,S} <: AbstractGraph{T,S}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T,S}}
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where {T}
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arête au graphe."""
function add_edge!(graph::Graph{T}, edge::Edge{T}) where {T}
  push!(graph.edges, edge)
  graph
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name`,`nodes` et `edges`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie la liste des arêtes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie le nombre d,arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  for node in nodes(graph)
    show(node)
  end
  for edge in edges(graph)
    show(edge)
  end
end

"""Lit un fichier stsp et stocke les données dans une structure de type Graph.

Exemples :

    graph_structure = stsp_to_graph("bayg29.tsp")
    graph_structure = stsp_to_graph("bayg29.tsp";show_graph_flag=true)
    graph_structure = stsp_to_graph("bayg29.tsp";plot_graph_flag=true)
    graph_structure = stsp_to_graph("bayg29.tsp";show_graph_flag=true,plot_graph_flag=true)
"""
function stsp_to_graph(filename::String; show_graph_flag = false, plot_graph_flag = false, verbose_flag = true)
  # Lecture du fichier
  if verbose_flag
    println("File: $(basename(filename))")
  end
  graph_nodes, graph_edges, graph_edges_weight = read_stsp(filename; verbose_flag)

  # Stockage dans une structure de type Graph
  nodes_list = Node{Int}[]
  for i_node = 1:length(graph_edges)
    push!(nodes_list, Node{Int}("$i_node", i_node))
  end
  edges_list = Edge{Int,Int}[]
  nb_edges = div(length(graph_edges) * (length(graph_edges) - 1), 2)
  stocked_edge = fill(false, nb_edges)
  for i = 1:length(graph_edges)
    node1 = nodes_list[i]
    for j = 1:length(graph_edges[i])
      k = graph_edges[i][j]
      if k > i
        t1 = i
        t2 = k
      elseif k < i
        t1 = k
        t2 = i
      else
        continue
      end
      global_index = nb_edges - div((length(graph_edges) - t1 + 1) * (length(graph_edges) - t1), 2) + t2 - t1
      if stocked_edge[global_index] == false
        stocked_edge[global_index] = true
        node2 = nodes_list[k]
        poids = graph_edges_weight[i][j]
        edge = Edge{Int,Int}("$global_index", node1, node2, poids)
        push!(edges_list, edge)
      end
    end
  end
  graph_structure = Graph(basename(filename), nodes_list, edges_list)

  # Affichage du contenu du graphe
  if show_graph_flag
    show(graph_structure)
  end
  if plot_graph_flag
    plot_graph(graph_nodes, graph_edges)
  end
  graph_structure
end

"""Trie les arêtes d'un graphe suivant leurs poids."""
function sort_edge(graph::AbstractGraph)
  sorted_edges = sort(edges(graph))
  return sorted_edges
end

"""Cherche une arête du graphe donnée par ses deux noeuds."""
function find_edge(graph::AbstractGraph, node1::Node{T}, node2::Node{T}) where {T}
  edges_ = edges(graph)
  for edge in edges_
    if (start_node(edge) == node1 && end_node(edge) == node2) || (start_node(edge) == node2 && end_node(edge) == node1)
      return edge
    end
  end
  error("Edge not found")
end

"""Retourne les listes d'adjacene noeud -> arêtes."""
function node_to_edges(graph::AbstractGraph)
  nodes_ = nodes(graph)
  edges_ = edges(graph)
  n_adj_edges = Dict{typeof(nodes_[1]),Int}()
  for node in nodes_
    n_adj_edges[node] = 0
  end
  for edge in edges_
    n_adj_edges[start_node(edge)] += 1
    n_adj_edges[end_node(edge)] += 1
  end
  adj_edges = Dict{typeof(nodes_[1]),Vector{typeof(edges_[1])}}()
  for node in nodes_
    adj_edges[node] = Vector{typeof(edges_[1])}(undef, n_adj_edges[node])
    n_adj_edges[node] = 1
  end
  for edge in edges_
    node = start_node(edge)
    i_stor = n_adj_edges[node]
    adj_edges[node][i_stor] = edge
    n_adj_edges[node] = i_stor + 1
    node = end_node(edge)
    i_stor = n_adj_edges[node]
    adj_edges[node][i_stor] = edge
    n_adj_edges[node] = i_stor + 1
  end

  return adj_edges
end

