import Base.show

"""Type representant un noeud d'une composante connexe d'un graphe."""
mutable struct Component{T}
    node::Node{T}
    parent::Node{T}
end

"""Construit une composante connexe à partir d'un noeud."""
Component(node::Node{T}) where T = Component{T}(node, node);

"""Retourne le noeud parent d'un noeud-composante."""
parent(compo::Component{T}) where T = compo.parent;

"""Retourne le noeud d'un noeud-composante."""
node(compo::Component{T}) where T = compo.node;

"""Mute le noeud parent d'un noeud-composante."""
function set_parent!(compo::Component{T}, parent::Node{T}) where T 
    compo.parent = parent;
end

"""Type représentant l'ensemble des composantes connexes d'un graphe."""
mutable struct ConnectedComponents{T}
    components::Dict{Node{T}}{Component{T}}
end

"""Construit un ensemble de composantes connexes à partir d'un vecteur de noeud-composante."""
function ConnectedComponents(compos::Vector{Component{T}}) where T 
   connec_compos = ConnectedComponents(Dict{Node{T},Component{T}}());
   for icompo = 1:length(compos)
    add_component!(connec_compos, compos[icompo]);
   end
   connec_compos
end

"""Ajoute un noeud-composante dans l'ensemble des composante des composantes connexes."""
function add_component!(connec_compos::ConnectedComponents{T}, compo::Component{T}) where T
    node_ = node(compo);
    connec_compos.components[node_] = compo;
    return connec_compos
end

"""Retourne un noeud-composante à partir d'un noeud."""
function component(connec_compos::ConnectedComponents{T}, node::Node{T}) where T
    compo = connec_compos.components[node];
    return compo
end

"""Retourne la racine d'un noeud."""
function find_root(connec_compos::ConnectedComponents{T}, node_::Node{T}) where T
    compo = component(connec_compos, node_);
    parent_ = parent(compo);
    if parent_ != node_
        node_ = parent_;
        node_ = find_root(connec_compos, node_);
    end
    node_
end

"""Fusionne deux composantes connexes."""
function union_components!(connec_compos::ConnectedComponents{T}, node1::Node{T}, node2::Node{T}) where T
    root1 = find_root(connec_compos, node1);
    root2 = find_root(connec_compos, node2);
    compo1 = component(connec_compos, root1);
    set_parent!(compo1, root2);
end

"""Retourne l'arbre de recouvrement minimal en utilisant l'algorithme de Kruskal."""
function kruskal(graph::AbstractGraph)
    # Tri des arêtespar poids
    sorted_edges = sort_edge(graph);
    # Initialisation des composantes connexes
    connec_compos = ConnectedComponents(Component{Int}[]);
    nodes_ = nodes(graph);
    nb_nodes_ = nb_nodes(graph);
    for inode = 1:nb_nodes_
        compo = Component(nodes_[inode]);
        add_component!(connec_compos, compo);
    end
    # Construction de l'arbre de recouvrement minimal
    mst = Edge{Int}[]
    nb_edges_ = nb_edges(graph)
    for iedge = 1:nb_edges_
        edge = sorted_edges[iedge];
        node1 = start_node(edge);
        node2 = end_node(edge);
        root1 = find_root(connec_compos, node1);
        root2 = find_root(connec_compos, node2);
        if root1 != root2
            push!(mst, edge);
            union_components!(connec_compos, root1, root2);
        end
    end
    return mst
end

"""Retourne le poids total de l'arbre de recouvrement minimal."""
function weight_mst(mst::Vector{Edge{Int}})
    total_weight = 0
    for iedge = 1:length(mst)
        edge = mst[iedge];
        total_weight += weight(edge);
    end
    total_weight
end