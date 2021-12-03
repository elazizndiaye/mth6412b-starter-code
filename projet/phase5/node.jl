import Base.show, Base.isless, Base.==

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Compare deux noeuds: inégalité stricte."""
isless(node1::AbstractNode, node2::AbstractNode) = data(node1) < data(node2)

"""Compare deux noeuds: égalité."""
function ==(node1::AbstractNode, node2::AbstractNode)
  ans = (data(node1) == data(node2)) && (name(node1) == name(node2))
  return ans
end

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node))
end
