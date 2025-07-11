function val = RasterImagePlot(S, varargin)
% RasterPlot(S, height, bar, tstart, tend)
% 
% Plot spike trains as rasters.
% INPUT:
% S: tsdArray of ts objects, spike trains
% OPTIONS: 
% Height: the height allocated to each cell (includes spacing), default 1
% BarFraction: the fraction of height occupied by a cell, default 0.8
% TStart, TEnd: the beginning and end of time interval to be plot, default
% 'Markers': times denoting a special event for each trial which that will
% be marked by a symbol
% 'MarkerTypes': symboles to denote markers, (first character color
% (optional), second character symbol. Defaults to '*'
% the whole thing
  
% battaglia & peyrache 2001,2007
  

opt_varargin = varargin;

defined_options = dictArray({ {'Height', {1, {'numeric'} } }, 
                                              {'BarFraction', {0.8, {'numeric'} } },
                                               {'LineWidth', {1, {'numeric'} } },
                                              {'TStart', {NaN, {'numeric'} } },
                                              {'TEnd', {1e100, {'numeric'} } } 
                                              { 'FigureHandle', {[], {'numeric'} } } 
                                              { 'AxHandle', {[], {'numeric'} } } 
                                              {'Markers', {{}, {'cell'} } }
						{'Markers2', {{}, {'cell'} } }
						{'MarkerTypes', { {}, {'cell' } } }
						{'MarkerTypes2', { {}, {'cell' } } }
                                              {'MarkerSize', { [], {'numeric'} } }
                                           });
                                       

  getOpt;  


if isempty(FigureHandle)
    FigureHandle = figure;
else
    figure(FigureHandle);
end

if ~isempty(AxHandle)
    axes(AxHandle);
end

if isfinite(TStart )
  for i = 1:length(S)
    Si{i} = Restrict(S{i}, TStart, TEnd);
  end
else 
  Si = S;
end

l=length(Range(Si{1}));
lIx = 1;

for i = 2:length(Si)

	if l>length(Range(Si{i}));
		l = length(Range(Si{i}));
		lIx = i;
	end

end


matVal = zeros(length(Si),l);
  
for i = 1:length(Si)

  v = Data(Si{i});
  matVal(i,:) = v(1:l)';

end

times = Range(Si{lIx});
val = tsd(times,matVal');
imagesc(times/10000,[1:length(Si)],matVal)

%  if max(max(matVal))<1&max(max(matVal))>0.6
%  caxis([0 1])
%  else  caxis([min(min(matVal)) mean(mean(matVal))+5*std(mean(matVal))])
%  end
if max(max(matVal))<=1&min(min(matVal))>=0
caxis([0 1])
end

axis xy
hold on
%  keyboard

if ~isempty(Markers)
    if isempty(MarkerTypes)
        for iM  = 1:length(Markers)
            MarkerTypes{iM} = '*';
        end
    end
    
    for iM = 1:length(Markers)
        M = Markers{iM};
        mt = MarkerTypes{iM};
        if length(mt) == 2
            mr = mt(2);
            mc = mt(1);
        elseif length(mt)==1
            mr = mt;
            mc= 'r';
        else error('MarkerTypes elements should have one or two characters')
        end
        
        i = 1:length(Si);
        l = line(M, (i)*Height, 'LineStyle', 'none', 'Marker', mr, 'MarkerEdgeColor', mc);
        if ~isempty(MarkerSize)
            set(l, 'MarkerSize', 20);
        end
    end
end

%----------------------------------------------------------------------------------------------------------
axis xy
hold on
%  keyboard

if ~isempty(Markers2)
    if isempty(MarkerTypes2)
        for iM  = 1:length(Markers2)
            MarkerTypes2{iM} = '*';
        end
    end
    
    for iM = 1:length(Markers2)
        M = Markers2{iM};
        mt = MarkerTypes2{iM};
        if length(mt) == 2
            mr = mt(2);
            mc = mt(1);
        elseif length(mt)==1
            mr = mt;
            mc= 'r';
        else error('MarkerTypes elements should have one or two characters')
        end
        
        i = 1:length(Si);
        l = line(M, (i)*Height, 'LineStyle', 'none', 'Marker', mr, 'MarkerEdgeColor', mc);
        if ~isempty(MarkerSize)
            set(l, 'MarkerSize', 20);
        end
    end
end

