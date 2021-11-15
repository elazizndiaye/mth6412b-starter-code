
"""Retourne le poids total d'une tournée."""
function weight_cycle(cycle)
    total_weight = 0
    for iedge = 1:length(cycle)
        edge = cycle[iedge]
        total_weight += weight(edge)
    end
    total_weight
end