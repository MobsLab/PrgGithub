function varargout = binXYZonXY( x_bin_edges, y_bin_edges, x, y, z, flag4std, to_plot )
%[average, stdev, centers, population, out_of_range] = binXYZonXY( x_bin_edges, y_bin_edges, x, y, z, flag4std, to_plot )
%returns avg, std, population for the matrix created by x_bins and y_bins.
%bins are defined by bin_edges (assumed sorted and equi-spaced)
%x, y, z are vectors having same number of elements
%centers aresquare bin centers produced using ndgrid
%out_of_range is indices of values out of range
% optional commands
% binXYZonXY( x_bin_edges, y_bin_edges, x, y, z, flag4std, to_plot )
% where flag4std==0 to use the default normalization by N-1, or 1 to use N.
% where to_plot = 1 for showing a quick 3D plot
% this is vectorized for speed
%example
%    x_bin_edges = 0.:.1:1;
%     y_bin_edges =  0.:.1:1;
%     x = rand(1000);
%     y = rand(1000);
%     z = x.^2+y.^2;
% [average, stdev, centers, population, out_of_range] = binXYZonXY( x_bin_edges, y_bin_edges, x, y, z, 0, 1 );
%sak 2013

%%
max_double_size = 100000000; %this value is used to split up the input data into chuncks
if ~exist( 'x_bin_edges', 'var' )
    disp( 'debugging' );
    x_bin_edges = linspace(0, 1, 10 );
    y_bin_edges = linspace(0, 1, 10 );
    x = rand(50);
    y = rand(size(x));
    z = x.^2+y.^2;
    flag4std = 1;
    to_plot = 1;
end
% tic
x_bin_edges = shiftdim(x_bin_edges);
x = shiftdim(x(:));
y_bin_edges = shiftdim(y_bin_edges);
y = shiftdim(y(:));
z = shiftdim(z(:));
z2 = z.^2;
out_of_range = x>x_bin_edges(end)|x<x_bin_edges(1)|y>y_bin_edges(end)|y<y_bin_edges(1) ;
x_bin_edges(end) = x_bin_edges(end)+eps;
y_bin_edges(end) = y_bin_edges(end)+eps;
x(out_of_range) = [];
y(out_of_range) = [];
z(out_of_range) = [];
%%
coeff.x = polyfit( x_bin_edges, [1:numel(x_bin_edges )]', 1 );
coeff.y = polyfit( y_bin_edges, [1:numel(y_bin_edges )]', 1 );
%%
[first, second, population] = deal( zeros(  numel( x_bin_edges )-1, numel( y_bin_edges )-1 ) );
chunck = min( [ceil( max_double_size/numel( first ) ), numel(z) ] );
ks = unique( [ 1:chunck:numel(x)+1, numel(x)+1] );
ind = false( numel( x_bin_edges )-1, numel( y_bin_edges )-1, chunck );
out = zeros( numel( x_bin_edges )-1, numel( y_bin_edges )-1, chunck );

for k=1:numel(ks)-1
    sub = [ks(k):ks(k+1)-1];
    i = floor( polyval( coeff.x, x(sub) ) );
    j = floor( polyval( coeff.y, y(sub) ) );
    %%
    ind(:) = false;
    out(:) = 0;
    if numel(sub) < chunck
        out = out(:,:,1:numel(sub));
        ind = ind(:,:,1:numel(sub));
    end
    ind(i+(j-1)*(numel(x_bin_edges)-1) + (numel(x_bin_edges)-1)*(numel(y_bin_edges)-1)*[0:numel(sub)-1]' ) = true;
    out(ind) = z(sub);
    first = first+sum( out, 3);
    out(ind) = z2(sub);
    second = second+sum( out, 3);
    population = population+sum( ind, 3);
end

average = first./population;
%
%%
if exist( 'flag4std', 'var' ) & flag4std
    stdev = sqrt( (second - 2*first.*average)./population + average.^2 );
else
    stdev = sqrt( (second - 2*first.*average)./population + average.^2 ).*sqrt(population./(population-1));
end
%%
% [i, j] = deal( 4, 2);
% sub = x > x_bin_edges(i ) &  x < x_bin_edges(i+1 ) & y > y_bin_edges(j ) &  y < y_bin_edges(j+1 );
% std( z(sub) )
% stdev
%%
[centers.x, centers.y] = ndgrid( ( x_bin_edges(1:end-1)+x_bin_edges(2:end) )/2, ( y_bin_edges(1:end-1)+y_bin_edges(2:end) )/2 );
varargout = {average, stdev, centers, population, out_of_range};
varargout = varargout(1:nargout);
%%
if ( exist( 'to_plot' ) & to_plot) | ( ~exist( 'to_plot' ) & nargout == 0 )
    cla;
    plot3( x, y, z, '.k', 'markeredgecolor', 0.6*[1 1 1] )
    hold on;
    tmp = any(ind, 3);
    plot3( centers.x(tmp), centers.y(tmp), average(tmp), 'or' );
end
%     toc