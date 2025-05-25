function [no,xo1,xo2] = hist2dDB(y1,y2,x1,x2,varargin)
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

% Modified from hist2d.m by Dmitri Bryzgalov 16.04.2018
% histlimits added - this allows you to fix the size of histogram  
% you want to get
%

if nargin < 2
    error('Requires  at least two  input arguments.')
end
if nargin == 2
    x1 = 10;
    x2 = 10;
end
if min(size(y1))==1, y1 = y1(:); end
if min(size(y2))==1, y2 = y2(:); end
if isstr(x1) | isstr(x2) | isstr(y1) | isstr(y2)
    error('Input arguments must be numeric.')
end

miny1 = [];
maxy1 = [];
miny2 = [];
maxy2 = [];

% Parse parameter list
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).']);
	end
	switch(lower(varargin{i})),
		case 'histlimits',
			histlimits = varargin{i+1};
            miny1 = histlimits(1);
            maxy1 = histlimits(2);
            miny2 = histlimits (3);
            maxy2 = histlimits (4);
    end
end

[m,n] = size(y1);
if ~all(size(y2) == [m,n])
    error('Y1 and Y2 must have the same size.')
end
if length(x1) == 1
    if isempty(miny1) && isempty(maxy1)
        miny1 = min(min(y1));
        maxy1 = max(max(y1));
        binwidth1 = (maxy1 - miny1) ./ x1;
        xx1 = miny1 + binwidth1*(0:x1);
        xx1(length(xx1)) = maxy1;
        x1 = xx1(1:length(xx1)-1) + binwidth1/2;
    else
        binwidth1 = (maxy1 - miny1) ./ x1;
        xx1 = miny1 + binwidth1*(0:x1);
        xx1(length(xx1)) = maxy1;
        x1 = xx1(1:length(xx1)-1) + binwidth1/2;
    end
else
    xx1 = x1(:)';
    miny1 = min(min(y1));
    maxy1 = max(max(y1));
    binwidth1 = [diff(xx1) 0];
    xx1 = [xx1(1)-binwidth1(1)/2 xx1+binwidth1/2];
    xx1(1) = miny1;
    xx1(length(xx1)) = maxy1;
end

if length(x2) == 1
    if isempty(miny2) && isempty(maxy2)
        miny2 = min(min(y2));
        maxy2 = max(max(y2));
        binwidth2 = (maxy2 - miny2) ./ x2;
        xx2 = miny2 + binwidth2*(0:x2);
        xx2(length(xx2)) = maxy2;
        x2 = xx2(1:length(xx2)-1) + binwidth2/2;
    else
        binwidth2 = (maxy2 - miny2) ./ x2;
        xx2 = miny2 + binwidth2*(0:x2);
        xx2(length(xx2)) = maxy2;
        x2 = xx2(1:length(xx2)-1) + binwidth2/2;
    end
else
    xx2 = x2(:)';
    miny2 = min(min(y2));
    maxy2 = max(max(y2));
    binwidth2 = [diff(xx2) 0];
    xx2 = [xx2(1)-binwidth2(1)/2 xx2+binwidth2/2];
    xx2(1) = miny2;
    xx2(length(xx2)) = maxy2;
end
nbin1 = length(xx1);
nbin2 = length(xx2);
xx1 = [0 xx1];
xx2 = [0 xx2];
nn = zeros(nbin1-1,nbin2-1,n);

for i=2:nbin1
   for j=2:nbin2
      
      nn(i-1,j-1,:) = sum((y1 < xx1(i) & y1 > xx1(i-1) & y2 < xx2(j) & y2 >  xx2(j-1))  );
  end
end

    no = nn;
    xo1 = x1;
    xo2 = x2;

