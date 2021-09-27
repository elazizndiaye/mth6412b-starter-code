import Base.show

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les aretes d'un graphe.

Exemple:

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    weight = 251
    edge1 = Edge("name",[node2,node1],weight)

"""
mutable struct Edge{T} <: AbstractEdge{T}
  name::String
  nodes::Vector{Node{T}}
  weight::T
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `name`, `nodes` et `weight`.

"""Renvoie le nom de l'arête."""
name(edge::AbstractEdge) = edge.name

"""Renvoie les noeuds de l'arête."""
nodes(edge::AbstractEdge) = edge.nodes

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche une arête."""
function show(edge::AbstractEdge)
  nodes_of_edge = nodes(edge)
  println("Edge ", name(edge), ", weight: ", weight(edge), ", composed by nodes: ", name(nodes_of_edge[1]), " and ", name(nodes_of_edge[2]))
end
