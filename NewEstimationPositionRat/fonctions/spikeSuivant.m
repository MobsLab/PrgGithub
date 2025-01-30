function [id, t, derniersIndices] = spikeSuivant(spikes, derniersIndices)
%SPIKESUIVANT Summary of this function goes here
%   Detailed explanation goes here

    nCL = size(spikes,2);
    id = 0; %id de la CL du spike suivant
    t  = NaN; %instant du spike suivant
    for i=1:nCL
        if(derniersIndices(i) == size(spikes{i},1))
            continue;
        end
        
        if (isnan(t) || spikes{i}(derniersIndices(i)+1) < t  )
            id = i;
            t = spikes{i}(derniersIndices(i)+1);
        end
    end
    if(id>0)
        derniersIndices(id) = derniersIndices(id)+1;
    end
end

