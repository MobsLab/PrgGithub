function [map,stats]=PlaceField_SB(tsa,XS,YS,varargin)

%  INPUT
%    tsa = tsd of spike times
%    XS & YS = tsdof positions
%    varargin :
%       'threshold' : 0-1 : perc of peak used to identify firing field
%       default is 0.7
%       'figure' : set to 1 to get a figure
%       'smoothing' : smoothing factor applied to maps, std of gaussian,
%       measured in number of samplesm default is 3
%       'size' : map will be on a size*size grid, default is 50
%       'limitmaze' : [Xmin Xmax Ymin Ymax] limits of maze incase mouse
%       didnt't go everywhere
%  OUTPUT
%
%    map.x          x bins
%    map.y          y bins
%    map.rate       average firing rate map (in Hz)
%    map.time       occupancy map (in s)
%    map.count      firing count map
%    stats.x        abscissa of the peak (in bins)
%    stats.y        ordinate of the peak (in bins)
%    stats.peak     in-field peak firing rate (in Hz)
%    stats.mean     in-field mean firing rate (in Hz)
%    stats.size     firing field size (in bins)
%    stats.field    firing field (1 = bin in field, 0 = bin not in field)
%    stats.fieldX   firing field x boundaries (in bins)
%    stats.fieldY   firing field y boundaries (in bins)
%
%  NOTE
%
%    Position (x,y) is used to compute column bin(x) and row bin(y) in all
%    output matrices (e.g. 'map.rate'). Increasing values y are upwards.
%
%


for i=1:2:length(varargin)
    
    switch(lower(varargin{i})),
        
        case 'smoothing',
            smo = varargin{i+1};
            if ~isa(smo,'numeric'),
                error('Incorrect value for property ''smoothing'' (type ''help PlaceField'' for details).');
            end
            
        case 'figure',
            plo = varargin{i+1};
            if ~isa(plo,'numeric'),
                error('Incorrect value for property ''figure'' (type ''help PlaceField'' for details).');
            end
        case 'threshold',
            threshold = varargin{i+1};
            if ~isa(threshold,'numeric'),
                error('Incorrect value for property ''threshold'' (type ''help PlaceField'' for details).');
            end
        case 'size',
            sizeMap = varargin{i+1};
            if ~isa(sizeMap,'numeric'),
                error('Incorrect value for property ''size'' (type ''help PlaceField'' for details).');
            end
        case 'limitmaze',
            lim = varargin{i+1};
            lim(1:2)=sort(lim(1:2));
            lim(3:4)=sort(lim(3:4));
    end
end

% set defaults if not given
try,threshold;catch,threshold = 0.7;end
try,plo;catch,plo=0;end
try,smo;catch,smo=3;end
try,sizeMap;catch,sizeMap=50;end
try,lim;catch,lim=[min(Data(XS)),max(Data(XS)),min(Data(YS)),max(Data(YS))];end


% Align X and Y values to nearest spikes
px =(Restrict(XS,tsa,'align','closest'));
py =(Restrict(YS,tsa,'align','closest'));


% Create 2D place map
pasX=(lim(2)-lim(1))/(sizeMap-2); XAx=lim(1)-pasX/2:pasX:lim(2)+pasX/2;
pasY=(lim(4)-lim(3))/(sizeMap-2); YAx=lim(3)-pasY/2:pasY:lim(4)+pasY/2;
[occH, ~,~] = hist2d(Data(XS), Data(YS), XAx,YAx );
occH=occH./median(diff(Range(XS,'s')));

% Create 2D firing map
pfH = hist2d(Data(px), Data(py), XAx, YAx);
pf = pfH./occH;

% Smooth maps
pf(isnan(pf))=0;
map.rateOr=pf';
map.rate=SmoothDec(pf,[smo,smo])';

occH(isnan(occH))=0;
map.timeOr=occH';
map.time=SmoothDec(occH,[smo,smo])';

pfH(isnan(pfH))=0;
map.countOr=pfH';
map.count=SmoothDec(pfH,[smo,smo])';

map.XAx=XAx;
map.YAx=YAx;

stats.x = [];
stats.y = [];
stats.field = [];
stats.size = [];
stats.peak = [];
stats.mean = [];
stats.fieldX = [];
stats.fieldY = [];
stats.spatialInfo=[];
stats.sparsity=[];
stats.specificity = [];

% Compute the spatial specificity of the firing map, based on the formula proposed
% by Skaggs et al. (1993).

T = sum(sum(map.time));
if T == 0,
    stats.specificity = 0;
else
    occupancy = map.time/(T+eps);
    meanFiringRate = sum(sum(map.count))/(sum(sum(map.time)+eps));
    if meanFiringRate == 0,
        stats.specificity = 0;
    else
        logArg = map.count/meanFiringRate;
        logArg(logArg <= 1) = 1;
        stats.specificity = sum(sum(map.count.*log2(logArg).*occupancy))/meanFiringRate;
    end
end

% Determine the firing field (i.e. the connex area where the firing rates are > threshold*peak).
% There are two ways to do this:
% 1) If the location of the center was provided (see 'center' property), the firing field is
%    found around the center.
% 2) Otherwise, the firing field is assumed to be around the bin with maximal firing rate
%    (when there are two fields, the one with the highest firing rate is selected unless the other
%    one is >20% bigger).

if max(max(map.rate)) == 0,
    stats.field = logical(zeros(size(map.rate)));
    return;
end

% First clean the map from very small regions of elevated firing rates
CleanRateMap = map.rate;


% In the absence of any information regarding the location of the center,
% find two candidate firing fields
for i = 1:2,
    % Find firing field and compute all parameters
    peak(i) = max(CleanRateMap(:));
    peakLocation = FindPeakLocation(CleanRateMap);
    x(i) = peakLocation(1);
    y(i) = peakLocation(2);
    
    diff_im = im2bw(CleanRateMap,threshold*peak(i));
    RegionInfo=bwconncomp(diff_im);
    for num=1:length(RegionInfo.PixelIdxList)
        [v1,v2]=ind2sub(size(diff_im),RegionInfo.PixelIdxList{num});
        if length(find(v1==y(i) & v2==x(i)))==1
            field{i}=zeros(size(diff_im));
            field{i}(RegionInfo.PixelIdxList{num})=1;
        end
    end
    
    try,    fieldSize(i) = sum(sum(field{i}));
        CleanRateMap(logical(field{i})) = 0;
    catch, fieldSize(i)=0; end
    % Remove this firing field from the rate map for next iteration
    
end

% Choose between the two candidate fields
if fieldSize(2) == 0,
    winner = 1;
else
    sizeRelativeDifference = (fieldSize(2)-fieldSize(1))/((fieldSize(1)+fieldSize(2))/2);
    if sizeRelativeDifference > 0.2,
        winner = 2; % Choose firing field #2 (see below)
    else
        winner = 1; % Choose firing field #1 (see below)
    end
end


% Set stats
stats.x = x(winner);
stats.y = y(winner);
stats.field = logical(field{winner});
stats.size = fieldSize(winner);
stats.peak = peak(winner);
stats.mean = mean(mean(map.rate(stats.field)));
i = find(max(stats.field,[],1));
if ~isempty(i),
    stats.fieldX = [i(1) i(end)];
end
i = find(max(stats.field,[],2));
if ~isempty(i),
    stats.fieldY = [i(1) i(end)];
end

stat=SpatialInfo(map);

stats.spatialInfo=stat.info;
stats.sparsity=stat.sparsity;

stats.C=GravityCenter(stats.field.*map.rate);

stats.PrField=field{1};
stats.ScField=field{2};

if plo
    
    figure('Color',[1 1 1]),
    
    clf, subplot(3,2,1), imagesc(XAx,YAx,map.time), axis xy, title('Occupation map'),colorbar
    subplot(3,2,2), imagesc(XAx,YAx,map.count), axis xy, title('Spike map'), colorbar
    subplot(3,2,3), imagesc(XAx,YAx,map.rate), axis xy, title('Firing map'), colorbar
    
    
    subplot(3,2,4) , plot(Data(XS),Data(YS),'Color',[0.8 0.8 0.8]),colorbar
    hold on, plot(Data(px),Data(py),'r.')
    xlim([lim(1) lim(2)])
    ylim([lim(3) lim(4)])
    rg=Range(XS,'s');
    title(['Firing rate : ',num2str(length(Range(tsa))/(rg(end)-rg(1))),' Hz'])
    
    subplot(3,2,5:6), hold on,
    plot(Range(XS,'s'),Data(XS))
    plot(Range(YS,'s'),Data(YS),'g')
    plot(Range(tsa,'s'),100*ones(length(Range(tsa,'s')),1),'r.')
    xlim([0 max(Range(YS,'s'))])
    
end


% FindPeakLocation - find the coordinates of the peak firing rate

function peakLocation = FindPeakLocation(map)

peak = max(max(map));
xy = (map == peak);
x = find(max(xy));
y = find(max(xy,[],2));
peakLocation = [x(1) y(1)];



