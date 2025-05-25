function lm = prune_threshold(model, ecartmin)
% This function prunes a sparse time-frequency bump model
% Do not call this function directly, prune_model.m should be used instead
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

lm = model;
TERMSEUIL = 3;
num  = model.num;
dec  = -1*ones(size(model.dec));
windows  = -1*ones(size(model.windows));
for i=1:length(model.restes)
   j = 1;
   stop = 0;
   while (stop < TERMSEUIL) & (j <= length(model.restes{i}.bump))
      if (j > 1)
         r    = model.restes{i}.bump{j};
         rans = model.restes{i}.bump{j-1};
         if (rans - r) < ecartmin
            stop = stop + 1;
         else
            stop = 0;
         end;
      end;      
      dec((i-1)*num+j,:) = model.dec((i-1)*num+j,:);
      windows((i-1)*num+j,:) = model.windows((i-1)*num+j,:);
      nrestes{i}.bump{j} = model.restes{i}.bump{j};
      nerreur{i}.bump{j} = model.erreur{i}.bump{j};
      j = j + 1;
   end;
end;
maxnum = 0;
for i=1:model.N
   stop = 0;
   j = 1;
   while stop == 0
      if j > maxnum
         d = dec((i-1)*num+j,:);
         if sum(d) == -5
            stop = 1;
         else
            maxnum = j;
         end;
      end;
      j = j + 1;
      if j > num
         stop = 1;
      end;      
   end;
end;
lm.num = maxnum;
newdec = zeros(lm.N*lm.num,size(model.dec,2));
newwind = zeros(lm.N*lm.num,size(model.windows,2));
for i=1:model.N
   for j=1:lm.num
      newdec((i-1)*lm.num+j,:) = dec((i-1)*num +j,:);
      newwind((i-1)*lm.num+j,:) = windows((i-1)*num +j,:);
   end;
end;
lm.dec = newdec;
lm.windows = newwind;
lm.restes = nrestes;
lm.erreur = nerreur;