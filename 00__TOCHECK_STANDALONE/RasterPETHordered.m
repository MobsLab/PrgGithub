function [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETHordered(S, center, idx_order, TStart, TEnd, varargin)



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
                                });
getOpt;

is = intervalSet(Range(center)+TStart, Range(center)+TEnd);

sweeps = intervalSplit(S, is, 'OffsetStart', TStart);
sweeps_order = sweeps(idx_order);


for iM = 1:length(Markers)
    
    if length(Range(Markers{iM}))==length(Range(center))
        temp=Range(center);
        Markers{iM} = (Range(Markers{iM}) - temp(idx_order))/10; 
    else
        %MarkersTemp{iM} =[];
        rgC=Range(center);rgC=rgC(idx_order);
        for idd=1:length(rgC)
            temp=(Range(Markers{iM})-rgC(idd))/10;
            MarkersTemp{idd} = temp(find(temp>TStart/10&temp<TEnd/10));
            %MarkersTemp{iM} = [MarkersTemp{iM}; temp(find(temp>TStart&temp<TEnd))];
            clear temp
        end
        try
        Markers{iM} = MarkersTemp;
        catch 
            Markers{iM} =[];
        end
    end
end

rf = RasterFraction * 0.8;
rasterAx = axes('position', [0.1 0.05 0.8 (rf+0.05)]);
histAx = axes('position', [0.1 (rf+0.15) 0.8 (0.75-rf)]);

fh = gcf;
axes(rasterAx);

try
set(gca, 'FontName', font_name);
set(gca, 'FontWeight', font_weight);
set(gca, 'FontSize', font_size);
set(gca, 'LineWidth', line_width);
set(gca, 'XLim', [TStart TEnd]/10);
RasterPlot(sweeps_order, 'AxHandle', rasterAx, ...
    'FigureHandle', fh, ...
    'TStart', TStart, ...
    'TEnd', TEnd, ...
    'LineWidth', LineWidth, ...
    'Markers', Markers, ...
    'MarkerTypes', MarkerTypes, ...
    'MarkerSize', MarkerSize);
end
set(gca, 'Box', 'on');
axes(histAx);

ss = oneSeries(sweeps_order);
sq = intervalRate(ss, regular_interval(TStart, TEnd, BinSize));

dArea =  Data(sq)/length(sweeps);
area(Range(sq, 'ms'), Data(sq)/length(sweeps), 'FaceColor', 'k');
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
fh = gcf;
