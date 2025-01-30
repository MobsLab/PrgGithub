function M2=MeanWithoutSingleRow(M)



if size(M,1)>1
    M2=nanmean(M);
else
    M2=M;
    
end
   