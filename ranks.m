function  r = ranks(data, glob)
%--------------------------------------------------------------------
% RANK TRANSFORMATION of data on input
%    Input: data - data to be ranked, data is matrix
%           glob - how to rank data matrix. glob=1 ranks amm matrix components (global 
%                  ranking; glob ne 1 - rank by columns of data. Default glob=1.
%    Output:   r - rank-transformed data
% Finds ranks of a vector of observations and adjusts for ties (by averaging)
% 
% Comment. If ties are no present (ties in ranking are matching observations), 
% ranks can be found simply as the indices in sorting of the indices of the
% sorted data (sentence is OK), i.e.,  [a,b]=sort(data); [c,d]=sort(b);
% and the ranks are in 'd'. If there are ties, they are ranked from left to
% right and also from right to left, and then averaged!
%---------------------------------------------------------------------
if nargin < 2
    glob = 1;
end
    shape = size(data);
if glob == 1    
     data=data(:);
 end     
% Ties ranked from UptoDown
  [ irrelevant , indud ]  =  sort(data);
  [ irrelevant , rUD ]    =  sort(indud);
% Ties ranked from RtoL
  [ irrelevant , inddu ]  =  sort(flipud(data));
  [ irrelevant , rDU ]    =  sort(inddu);
% Averages ranks of ties, keeping ranks of no-tie-observations the same
r = (rUD + flipud(rDU))./2;
r = reshape(r,shape); 
%---------------------------------------------------------------------
% Copyright (C) 2002 by GaTech
% Ver 0.1   9/28/2002