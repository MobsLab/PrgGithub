function M = spkZcorrcoef(S,binSize,is)

%  M = SPKCORRCOEF(S,binSize,is)
%  this function computes correlation coefficients matrix of 
%  spikes in tsa *S*, split in bins of *binSize* for interval *is*

Q = MakeQfromS(S,binSize);
Q = Restrict(Q,is);
M = full(nancorrcoef(zscore(Data(Q))));
M(isnan(M))=0;
M = M - diag(diag(M));
