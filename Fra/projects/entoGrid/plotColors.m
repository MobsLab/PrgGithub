function plotColors(x, y, c, sz1)

sz = 1;
if nargin > 3
    sz = sz1;
end


% c = ceil((c - min(c)) / (max(c)-min(c)) * 64);
% c(c > 64) = 64;
% c(c< 1) = 1;

cmap = colormap;


K = linspace(min(c)-eps, max(c), 65);

for i = 1:64
    ix = find(c > K(i) & c <= K(i+1));
    plot(x(ix), y(ix), '.', 'Color', cmap(i,:), 'MarkerSize', sz);
    hold on
end
