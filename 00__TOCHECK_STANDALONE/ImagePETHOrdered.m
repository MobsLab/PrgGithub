function [fh, rasterAx, histAx, matVal] = ImagePETHOrdered(S, center, idx_order, TStart, TEnd, varargin)

% [fh, rasterAx, histAx, matVal] = ImagePETHOrdered(S, center, idx_order, TStart, TEnd, varargin)

% S: tsd containing data to plot
% center: tsd containing time of events 
% idx_order: list of center index
% TStart : time from event (negative if before event), in 1E-4s
% TEnd : in 1E-4s
%

font_name = 'Arial';
    font_size = 10;
    font_weight = 'bold';
    line_width = 2;
    
opt_varargin = varargin;

defined_options  = dictArray({ { 'RasterFraction', {0.7, {'numeric'}} }
                               { 'BinSize', {10, {'numeric'}}},
                                {'LineWidth', {1, {'numeric'} } },
                                {'Markers', { {}, {'cell'}} } ,
				{'Markers2', { {}, {'cell'}} },
				{'MarkerTypes', { {}, {'cell'}}},
				{'MarkerTypes2', { {}, {'cell'}}}, 
                                {'MarkerSize', { [], {'numeric'} } }});
getOpt;

is = intervalSet(Range(center)+TStart, Range(center)+TEnd);

sweeps = intervalSplit(S, is, 'OffsetStart', TStart);
sweeps_order = sweeps(idx_order);

for iM = 1:length(Markers)
    Markers{iM} = (Range(Markers{iM}) - Range(center))/10000; 
end

for iM = 1:length(Markers2)
    Markers2{iM} = (Range(Markers2{iM}) - Range(center))/10000; 
end


rf = RasterFraction * 0.8;
rasterAx = axes('position', [0.1 0.05 0.8 (rf+0.05)]);
histAx = axes('position', [0.1 (rf+0.15) 0.8 (0.75-rf)]);

fh = gcf;
axes(rasterAx);


set(gca, 'FontName', font_name);
set(gca, 'FontWeight', font_weight);
set(gca, 'FontSize', font_size);
set(gca, 'LineWidth', line_width);
set(gca, 'XLim', [TStart TEnd]/10000);
matVal = RasterImagePlot(sweeps_order, 'AxHandle', rasterAx, ...
	'FigureHandle', fh, ...
	'TStart', TStart, ...
	'TEnd', TEnd, ...
	'LineWidth', LineWidth, ...
	'Markers', Markers, ...
	'Markers2', Markers2, ...
	'MarkerTypes', MarkerTypes, ...
	'MarkerTypes2', MarkerTypes2, ...
	'MarkerSize', MarkerSize);

set(gca, 'Box', 'on');
axes(histAx);


 % keyboard

dArea =  mean(Data(matVal)');
area(Range(matVal, 's'), dArea, 'FaceColor', 'k');
set(gca, 'FontName', font_name);
set(gca, 'FontWeight', font_weight);
set(gca, 'FontSize', font_size);
set(gca, 'LineWidth', line_width);
set(gca, 'XLim', [TStart TEnd]/10000);

yl = [min(0,1.2*min(dArea)) max(dArea) * 1.2];

if max(dArea) > 0
    set(gca, 'YLim', yl);
end

yM = max(yl);%floor(100*max(yl))/100;
ym = min(yl);%floor(100*min(yl))/100;
yl = [ym:(yM-ym)/3:yM];
set(gca, 'YTick', yl);
fh = gcf;


matVal=matVal;

