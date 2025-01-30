function [fh, rasterAx, histAx] = RasterPETHRipples(EEGSignal,S, center, TStart, TEnd, varargin)



font_name = 'Arial';
    font_size = 10;
    font_weight = 'bold';
    line_width = 2;
    
opt_varargin = varargin;

defined_options  = dictArray({ { 'RasterFraction', {0.5, {'numeric'}} }
                               { 'BinSize', {2, {'numeric'}}},
                                {'LineWidth', {10, {'numeric'} } },
                                {'Markers', { {}, {'cell'}} } ,
                                 {'MarkerTypes', { {}, {'cell'}}}, 
                                {'MarkerSize', { [], {'numeric'} } }
                                });
getOpt;

is = intervalSet(center+TStart, center+TEnd);
%  

for i=1:length(S)
	sweeps{i} = Restrict(S{i},is);
end
%  
for iM = 1:length(Markers)
    Markers{iM} = (Range(Markers{iM}) - Range(center))/10; 
end

rf = RasterFraction * 0.8;


rf = 0.5;
rasterAx = axes('position', [0.1 0.05 0.8 (rf+0.05)]);
histAx = axes('position', [0.1 (rf+0.15) 0.8 (0.75-rf)/2]);
eegAx = axes('position', [0.1 0.05+(0.75-rf)/2+(rf+0.15) 0.8 (0.60-rf)]);


fh = gcf;

axes(rasterAx);

%  RasterPlot(S,'TStart',center+TStart,'TEnd', center+TEnd', 'AxHandle', rasterAx,'FigureHandle', fh)



set(gca, 'FontName', font_name);
set(gca, 'FontWeight', font_weight);
set(gca, 'FontSize', font_size);
set(gca, 'LineWidth', line_width);
%  set(gca, 'XLim', [TStart TEnd]/10);
RasterPlot(S, 'AxHandle', rasterAx, ...
    'FigureHandle', fh, ...
    'TStart', center+TStart, ...
    'TEnd', center+TEnd);

set(gca, 'Box', 'on');

axes(histAx);


for i=1:length(S)

	if (i==1)
		sq = Data(intervalRate(S{i}, regular_interval(center+TStart, center+TEnd, BinSize)));
	else
		sq = sq + Data(intervalRate(S{i}, regular_interval(center+TStart, center+TEnd, BinSize)));
	end
end


dArea =  sq/length(S);
area([1:length(sq)], sq/length(S), 'FaceColor', 'k');
set(gca, 'FontName', font_name);
set(gca, 'FontWeight', font_weight);
set(gca, 'FontSize', font_size);
set(gca, 'LineWidth', line_width);
set(gca, 'XLim', [TStart TEnd]/10);
if max(dArea) > 0
    set(gca, 'YLim', [0 max(dArea) * 1.2]);
end
yl = get(gca, 'YTick');
yl = yl(find(yl==floor(yl)));
set(gca, 'YTick', yl);

axes(eegAx);
set(gca, 'FontName', font_name);
set(gca, 'FontWeight', font_weight);
set(gca, 'FontSize', font_size);
set(gca, 'LineWidth', line_width);
set(gca, 'XLim', [TStart TEnd]/10);

plot([1:length(EEGSignal)],EEGSignal);
set(gca, 'Box', 'on');


fh = gcf;
