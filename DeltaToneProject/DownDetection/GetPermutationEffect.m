%%GetPermutationEffect
% 12.03.2018 KJ
%
% Return the permutation effect on down distribution 
%
% perm_effect = GetPermutationEffect(real_distrib, perm_distribs, duration_bins)
%
%   see 
%       
%


function [perm_effect, extravalues] = GetPermutationEffect(real_distrib, perm_distribs, duration_bins, methodperm)
    
    if nargin<4
        methodperm = 1;
    end
    %params
    th1 = 90;
    
    %% many methods
    
    if methodperm==1
        
        id_real = find(real_distrib>100,1,'last');
        durbin_real = duration_bins(id_real);
        for k=1:length(perm_distribs) 
            id_perm(k) = find(perm_distribs{k}>th1,1,'last');
            durbin_k(k) = duration_bins(id_perm(k));
        end
        
        distance1 = durbin_real - durbin_k;
        distance2 = max(durbin_k)-min(durbin_k);
        
        [perm_effect k] = max(distance1);
        
        perm_effect = round((2*distance2+perm_effect)/30)*10; 
        
        extravalues = [id_real id_perm(k) k];
        
        
    %method 2
    elseif methodperm==2
        th2 = duration_bins(find(real_distrib>50,1,'last'));
        if isempty(th2)
            thresh = [50 250];
        else
            thresh = [50 th2];
        end

        new_bins = logspace(log10(thresh(1)),log10(thresh(2)),50);
        real_distrib = interp1(duration_bins,real_distrib,new_bins); 

        for k=1:length(perm_distribs) 
            permdist = interp1(duration_bins, perm_distribs{k} ,new_bins); 
            diffdist = log(real_distrib+1) - log(permdist+1);
            diff_distrib(k) = mean(diffdist);
        end
        perm_effect = 10 * max(diff_distrib);
    
        extravalues=0;
    
    %% method 3
    
%     norm_real = real_distrib/max(real_distrib);
%     
%     thresh = [0 400];
%     for k=1:length(perm_distribs)
%         norm_perm = perm_distribs{k} / max(perm_distribs{k});
%         diffdist = norm_real ./ (norm_perm+1);
%         diff_distrib(k) = mean(diffdist(duration_bins>thresh(1) & duration_bins>thresh(2)));
%     end
%     perm_effect = 10 * max(diff_distrib);

    end
%     
end


