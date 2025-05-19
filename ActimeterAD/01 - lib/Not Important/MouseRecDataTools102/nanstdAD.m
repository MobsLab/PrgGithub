function m = nanstd(x)
%  This function computes the standard deviation of vector X after removing all NaN
%  values.
%
%       m = nanstd(x)
%
%   If x is a matrix, the standard deviaion will be taken along the columns and 
%   M will be a row vector of mean values.
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) May 2012

[r,c] = size(x);
%  If a row vector, make it a column vector
if r == 1 && c > 1
    x = x.';
    [r,c] = size(x);
end
%  Loop through each column
for k=1:c
    m(k) = std(x(~isnan(x(:,k)),k));
end