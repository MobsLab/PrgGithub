function [fh, rasterAx, histAx, matVal] = RasterPPH(S, phiG, TStart, TEnd, varargin)



font_name = 'Arial';
    font_size = 10;
    font_weight = 'bold';
    line_width = 2;
    
opt_varargin = varargin;

defined_options  = dictArray({ { 'RasterFraction', {0.7, {'numeric'}} }
                               { 'BinSize', {10, {'numeric'}}},
                                {'LineWidth', {1, {'numeric'} } },
                                {'Markers', { {}, {'cell'}} } ,
                                 {'MarkerTypes', { {}, {'cell'}}}, 
                                {'MarkerSize', { [], {'numeric'} } }
                                {'SpaceBin', {0.1, {'numeric'} } }

                                });
getOpt;

is = intervalSet(Range(TStart), Range(TEnd));

sweeps = intervalSplit(S, is, 'OffsetStart', Range(TStart));
sweepsPos = intervalSplit(phiG, is, 'OffsetStart', Range(TStart));

for iM = 1:length(Markers)
    Markers{iM} = (Range(Markers{iM}) - Range(center))/10000; 
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
%  set(gca, 'XLim', [TStart TEnd]/10000);
matVal = RasterPPHPlot(sweeps, sweepsPos, 'AxHandle', rasterAx, ...
	'FigureHandle', fh, ...
	'LineWidth', LineWidth, ...
	'Markers', Markers, ...
	'MarkerTypes', MarkerTypes, ...
	'MarkerSize', MarkerSize, ...
	'SpaceBin', SpaceBin);

set(gca, 'Box', 'on');
axes(histAx);


%  keyboard

s=size(matVal);
for i=1:s(1,2)
dArea(i)=mean(matVal(find(matVal(:,i)~=0),i));
StdArea(i)=std(matVal(find(matVal(:,i)~=0),i));
end


%dArea =  mean(matVal);
area([-1:SpaceBin:1], dArea, 'FaceColor', 'k');
set(gca, 'FontName', font_name);
set(gca, 'FontWeight', font_weight);
set(gca, 'FontSize', font_size);
set(gca, 'LineWidth', line_width);

yl = [min(0,1.2*min(dArea)) max(dArea) * 1.2];

if max(dArea) > 0
    set(gca, 'YLim', yl);
end

yM = max(yl);%floor(100*max(yl))/100;
ym = min(yl);%floor(100*min(yl))/100;
yl = [ym:(yM-ym)/3:yM];
set(gca, 'YTick', yl);
fh = gcf;
