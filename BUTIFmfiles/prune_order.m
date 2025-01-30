function lm = prune_order(model, mxb)
% This function prunes a sparse time-frequency bump model
% Do not call this function directly, prune_model.m should be used instead
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

lm = model;
lm.num = mxb;
TERMSEUIL = 3;
num  = model.num;
newdec = -1*ones(lm.N*mxb,size(model.dec,2));
newwind = -1*ones(lm.N*mxb,size(model.windows,2));
for i=1:model.N
    indec = -1*ones(model.num,size(model.dec,2));
    inwind = -1*ones(model.num,size(model.windows,2));
    for j=1:num
        indec(j,:) = model.dec((i-1)*num +j,:);
        inwind(j,:) = model.windows((i-1)*num +j,:);
    end;
    [clsd,index] = sort(inwind(:,2)+indec(:,5),1,'ascend');
    j=1;
    while (j <= mxb) & (j <= length(model.restes{i}.bump))  
        newdec((i-1)*lm.num+j,:) = indec(index(j),:);       
        newwind((i-1)*lm.num+j,:) = inwind(index(j),:);        
        inrestes{i}.bump{j} = model.restes{i}.bump{index(j)};
        inerreur{i}.bump{j} = model.erreur{i}.bump{index(j)};
        j=j+1;
    end;
end;
lm.dec = newdec;
lm.windows = newwind;
lm.num = mxb;
lm.restes = inrestes;
lm.erreur = inerreur;