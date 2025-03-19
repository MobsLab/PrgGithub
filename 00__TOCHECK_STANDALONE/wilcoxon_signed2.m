function  [Tpl, Tp, p] = wilcoxon_signed2( data1, data2, alt )
% ------------------------------------------------------------------------------------
%   WILCOXON SIGNED RANK TEST
%   Input:  data1, data2 - first and second sample
%           alt - code for alternative hypothesis;
%               -1  mu1<m2; 0 mu1 ne m2; and 1 mu1>mu2
%   Output: Tpl - sum of signed ranks of positive differences
%           Tp - standardized Tpl but adjusted for the ties
%           p - p-value for testing equality of distributions (equality of locations)
%               ahainst th  e alternative spacified by input alt
%   Example of use:
%   >  dat1=[1 3 2 4 3 5 5 4 2 3 4 3 1 7 6 6 5 4 5 8 7];
%   >  dat2=[2 5 4 3 4 3 2 2 1 2 3 2 3 4 3 2 3 4 4 3 5];
%   >  [srs, tstat, pval] = wilcoxon_signed2(dat1, dat2, 1)
%
%   Needs: M-FILE ranks.m (ranking procedure) 
%-------------------------------------------------------------------------------------
data1 = data1(:)' ;       % convert sample 1 to a row vector  
data2 = data2(:)' ;       % convert sample 2 to a row vector
if length(data1) ~= length(data2)
    error('Sample sizes should coincide')
end
difs = data1 - data2;
difs = difs( difs ~= 0); %exclude 0 differences from consideration
rank_all = ranks(abs(difs));
n = length(rank_all);
signs1 =(difs > 0);
signs2 =2*(difs > 0)-1;
sig_ranks1 = signs1 .* rank_all;
sig_ranks2 = signs2 .* rank_all;
Tpl = sum( sig_ranks1 );      % sum of all signed ranks
etpl = n *(n+1)/4;
vartpl = sum( ( sig_ranks2.^2 ) )/4;
Tp  = (Tpl - etpl)/sqrt(vartpl);
cc = 0.5/sqrt(vartpl);
%-------------------------- alternatives ---------------------------------------
% alt == 0 for two sided;  alt == -1 for mu1 < mu2; alt == 1 for mu1 > mu2.
if      alt == 0
%             p = 2*cdf_nor(-abs( Tp ) + cc);
            p = 2*normcdf(-abs( Tp ) + cc);            
elseif  alt == -1
%             p = cdf_nor( Tp  + cc);
            p = normcdf( Tp  + cc);
elseif  alt == 1
%             p = cdf_nor( -Tp + cc);
            p = normcdf( -Tp + cc);            
else
        error('Wrong alternative code. Input "alt" should be either 0, -1, or 1.')
end
%-------------------------------------------------------------------------------------
% Copyright (C) 2002 by GaTech
% Ver 0.1   9/28/2002


