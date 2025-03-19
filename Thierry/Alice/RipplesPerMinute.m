function Ripplesm=RipplesPerMinute(Ripple)


    % -
    % Deltam=Deltaperhour(Deltas);
    %------------------------------------------------------------------------------------------------
    %
    % INPUTS
    % Deltas : intervalSet over the whole experiment //in seconds\\
    %
    % OUTPUTS
    % Deltam : list of the number of occurrences of delta (=Start(Delats))
    % over 1 minute

    tps=Start(Ripple,'s');
    fin=length(tps);
    nb_min=floor(tps(fin)/60);     % nombre de minute jusqu'au dernier Delta
    Ripplesm=zeros(nb_min,1);                     % initialisation du résultat : nombre de delta au cours de chaque minute d'enregistrement
    indicem=zeros(nb_min,1);                   % initialisation de la liste des indices du nombre de delta avant chacune des minutes
       
    % Minute
    
    for i=1:nb_min     % Pour chaque minute i d'enregistrement
        r=0;
        if i==1         % On fait une recherche dichotomique du nombre de delta avant la ième minute : indicem
            indice_min=1;    
        elseif indicem(i-1)==0
            indice_min=1; 
        else
            indice_min=indicem(i-1);
        end
        indice_max=length(tps);
        if tps(indice_min)>60*i
           r=1;
           if i==1
            indicem(i)=0;
           else
               indicem(i)=indicem(i-1);
           end
        end
 %       i
        while r==0;
            indice_mi=floor((indice_max+indice_min)/2);
            if tps(indice_min+1)>=60*i
                if tps(indice_min)<60*i
                    indicem(i)=indice_min;
                    r=1;
                end
            elseif tps(indice_max-1)<60*i
                if tps(indice_max)>=60*i
                    indicem(i)=indice_min;
                    r=1;
                end
            else
                if tps(indice_mi)<60*i
                    indice_min=indice_mi;
                elseif tps(indice_mi)>=60*i
                    indice_max=indice_mi;
                end
            end
 %           indice_min,indice_max,indice_mi,r
        end
    end

    Ripplesm(1)=indicem(1);                   % Pour chaque minute, on obtient en soustrayant l'indice précédent à l'indice actuel le nombre de delta par mintue : Deltam
    for i=2:nb_min
        Ripplesm(i)=indicem(i)-indicem(i-1);
    end
    
end



