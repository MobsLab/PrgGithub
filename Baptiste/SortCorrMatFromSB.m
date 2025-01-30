clear Vals
for sp = 1:length(S)
    Vals(sp,:) = hist(Range(S{sp},'s'),[0:50:30000]); 
end
A = (corr(zscore(Vals')'));
[ccb1, isort] = sortBatches2(A);