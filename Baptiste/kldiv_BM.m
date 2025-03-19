


function KLD = kldiv_BM(X,Y)

M   = numel(X);                   
X   = reshape(X,[M,1]);           
Y   = reshape(Y,[M,1]);
tf=X~=0 & Y~=0;
KLD = nansum( X(tf) .* log( X(tf)./Y(tf) ) );










