function y = ssprctile(x,p)
% This function computes the pth percentile of the data in vector X,
% where P is in percent (0 is minimum, 50 is median, and 100 is the
% maximum).
%
%     y = ssprctile(x,p)
%
% Y is the pth percentile of data in X.  If percentile does not fall
% on an integer index, linear interpolation is use to compute the
% percential from the neighboring data points.
%
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) April 2012


[len, c] = size(x);
if len < c  % if a row vector, make it a column vector
    x = x.';  % non conjugate transpose
    [len,c] = size(x);
end
% error messages 
if c > 1
    error('Input is a matrix, must be a vector')
end
if p > 100 || p < 0
    error('Percentile must be in interval [0 100]')
end
%  Compute percentile
lenm1 = len-1;  %  Max index relative to 0
sx = sort(x,'ascend');  %  Order data points
%  Find floating point index correponding to percentile
pt = lenm1*p/100;
pti = pt + 1;  %  Fractional percentile index relative to 1
intpti = floor(pti);  %  Least integer closest to  
% If index is an integer
if pti == intpti
    y = sx(intpti);  %  Assign data point
else  %  If index not an integer, interpolate
    y1 = sx(intpti);
    y2 = sx(ceil(pti));
    y = y1 + (y2-y1)*(pti-intpti);  %  Linear interpolation
end
    

