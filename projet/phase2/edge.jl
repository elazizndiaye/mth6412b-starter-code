import Base.show
include("node.jl");

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T,S} end

"""Type représentant les aretes d'un graphe.

Exemple:

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    weight = 251
    edge1 = Edge("name",node1,node2,weight)

"""
mutable struct Edge{T,S} <: AbstractEdge{T,S}
  name::String
  start_node::Node{T}
  end_node::Node{T}
  weight::S
  function Edge{T,S}(name::String, start_node::Node{T}, end_node::Node{T}, weight::S) where {T,S}
    if end_node < start_node
      temp = start_node;
      start_node = end_node;
      end_node = temp;
    end
    new(name, start_node, end_node, weight);
  end
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `name`, `start_node`, `end_node` et `weight`.

"""Renvoie le nom de l'arête."""
name(edge::AbstractEdge) = edge.name

"""Renvoie les noeuds de l'arête."""
nodes(edge::AbstractEdge) = (edge.start_node, edge.end_node)

"""Renvoie le premier noeud de l'arête."""
start_node(edge::AbstractEdge) = edge.start_node

"""Renvoie le second noeud de l'arête."""
end_node(edge::AbstractEdge) = edge.end_node

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("Edge ", name(edge), ", weight: ", weight(edge), ", composed by nodes: ", name(start_node(edge)), " and ", name(end_node(edge)))
end
