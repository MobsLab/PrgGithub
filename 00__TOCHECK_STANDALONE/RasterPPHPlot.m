function matVal = RasterPlot(S, phiG, varargin)
% RasterPlot(S, height, bar, tstart, tend)
% 
% Plot spike trains as rasters.
% INPUT:
% S: tsdArray of ts objects, spike trains
% OPTIONS: 
% Height: the height allocated to each cell (includes spacing), default 1
% BarFraction: the fraction of height occupied by a cell, default 0.8
% TStart, TEnd: the beginning of end of time interval to be plot, default
% 'Markers': times denoting a special event for each trial which that will
% be marked by a symbol
% 'MarkerTypes': symobels to denote markers, (first character color
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
                                              {'MarkerTypes', { {}, {'cell' } } }
                                              {'MarkerSize', { [], {'numeric'} } }
                                              {'SpaceBin', {0.1, {'numeric'} } }
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

%  if isfinite(TStart )
%    for i = 1:length(S)
%      Si{i} = Restrict(S{i}, TStart, TEnd);
%      phiGi{i} = Restrict(phiG{i}, TStart, TEnd);	
%    end
%  else 
%    Si = S;
%  end

Si = S;
phiGi = phiG;


binVect = [-1:SpaceBin:1];
Sbin = zeros(1,length(binVect));
matVal = zeros(length(Si),length(binVect));

for trial = 1:length(Si)
	
	for i=1:length(binVect)-1
	
		intBinDw = thresholdIntervals(phiGi{trial},binVect(i),'Direction','Above');
		intBinUp = thresholdIntervals(phiGi{trial},binVect(i+1),'Direction','Below');
		intBin = intersect(intBinUp,intBinDw);
		if length(Start(intBin))
 			%keyboard
			s = Restrict(Si{trial},intBin);
            if length(s)==0
            matVal(trial,i)=0;
            else matVal(trial,i) = mean(s);
            end
        end

	end

end

matVal(isnan(matVal))=0;

imagesc(binVect,[1:length(Si)],matVal)

if max(max(matVal))<1&max(max(matVal))>0.7
caxis([0 1])
else  
if length(matVal)>2
caxis([min(min(matVal)) mean(mean(matVal))+5*std(mean(matVal))])

end
end

%  caxis([0 1])

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


