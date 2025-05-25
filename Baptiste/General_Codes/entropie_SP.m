function [entropie] = entropie_SP(SP)
entropie = SP(:,1);
for i=1:length(entropie)
    entropie(i) = entropy(SP(i,:));
end
