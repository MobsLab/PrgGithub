function [R,S,E]=MeanDifNan(M)

% [R,S,E]=MeanDifNan(M)

if size(M,1)==1&size(M,2)>1

        R=nanmean(M);
        S=nanstd(M);
        E=nanstd(M)/sqrt(length(M));

elseif size(M,2)==1&size(M,1)>1
    
        R=nanmean(M);
        S=nanstd(M);
        E=nanstd(M)/sqrt(length(M));
     
else
    
    for i=1:size(M,2)
        R(i)=mean(M(find(~isnan(M(:,i))),i));
        S(i)=std(M(find(~isnan(M(:,i))),i));
        E(i)=stdError(M(find(~isnan(M(:,i))),i));
    end
 
    
end


