function [no,xo1,xo2] = hist2d(y1,y2,x1,x2,z,minmax)
%HIST2  2-D Histogram.
%   [N, X] = HIST2(Y1,Y2) bins the elements of Y1 and Y2 
%   into 10x10 equally spaced containers
%   and returns the number of elements in each container.  If Y1 and Y2 are
%   matrices, HIST works down the columns.
%
%   N = HIST(Y1,Y2,M,N), where M and N are scalars, uses MxN bins.
%
%   N = HIST(Y1,Y2,X), where X is a matrix, returns the distribution of Y
%   among bins with centers specified by X.
%
%   [N,X1,X2] = HIST(...) also returns the position of the bin centers in X1,X2.
%
%   HIST(...) without output arguments produces a colormap plot of
%   the results.


[m,n] = size(y1);
if ~all(size(y2) == [m,n])
    error('Y1 and Y2 must have the same size.')
end

    miny1 = minmax(1,1);
    maxy1 = minmax(1,2);
    binwidth1 = (maxy1 - miny1) ./ x1;
    xx1 = miny1 + binwidth1*(0:x1);
    xx1(length(xx1)) = maxy1;
    x1 = xx1(1:length(xx1)-1) + binwidth1/2;

    length(x2) == 1
    miny2 = minmax(2,1);
    maxy2 = minmax(2,2);
    binwidth2 = (maxy2 - miny2) ./ x2;
    xx2 = miny2 + binwidth2*(0:x2);
    xx2(length(xx2)) = maxy2;
    x2 = xx2(1:length(xx2)-1) + binwidth2/2;

nbin1 = length(xx1);
nbin2 = length(xx2);
xx1 = [0 xx1];
xx2 = [0 xx2];
nn = zeros(nbin1-1,nbin2-1,n);

for i=2:nbin1
   for j=2:nbin2
      
      nn(i-1,j-1,:) = nanmean(z(y1 < xx1(i) & y1 > xx1(i-1) & y2 < xx2(j) & y2 >  xx2(j-1))  );
  end
end

    no = nn;
    xo1 = x1;
    xo2 = x2;

