%%CompareSleepEventDetections
% 25.04.2018 KJ
%
% Compare two intervalSet of sleep events and return measures of comparison
%
% [recall, precision, distance_density, diff_slope, diff_duration, curves] = CompareSleepEventDetections(Epoch1, Epoch2, varargin)
%
% INPUT:
% - Epoch1                  = (intervalSet) intervals for sleep events 1 (e.g down states)
% - Epoch2                  = (intervalSet) intervals for sleep events 2 (e.g delta waves)                          
%
% - densityBin (optional)   = (int) duration of the intervals bins for density estimation
%                             (default 60s)
% - margin (optional)       = (int) time margin to consider that one event of Epoch2 coincide with one of Epoch 1
%                             (default 0ms)
%
%
% OUTPUT:
% - recall                  = (int) recall of Epoch1 from Epoch2  
% - precision               = (int) precision of detection of Epoch1 from Epoch2     
% - distance_density        = (int) distance between density curves 
% - diff_slope              = (int) difference between the slope of density curves 
% - diff_duration           = (int) difference between median duration of epochs
% - curves                  = (struct) struct with density curves for both events
%
%
%   see 
%       Get_DownGammaStat_detection_KJ GammaDownChannelAnalysis
%


function [recall, precision, distance_density, diff_slope, diff_duration, curves] = CompareSleepEventDetections(Epoch1, Epoch2, varargin)


%% CHECK INPUTS

if nargin < 2 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'densitybin'
            densityBin = varargin{i+1};
            if densityBin<=0
                error('Incorrect value for property ''densityBin''.');
            end
        case 'margin'
            marginEp2 = varargin{i+1};
            if marginEp2<0
                error('Incorrect value for property ''margin''.');
            end
        case 'smoothing'
            smoothing = varargin{i+1};
            if ~isivector(smoothing,'>=',0,'#',1)
                error('Incorrect value for property ''smoothing''.');
            end

        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('densityBin','var')
    densityBin=60;
end
if ~exist('marginEp2','var')
    marginEp2=0;
end
if ~exist('smoothing','var')
    smoothing=1;
end


%% init
%in ts
densityBin = densityBin * 1e4; 
marginEp2 = marginEp2 * 10;

%
event1_tmp = Start(Epoch1);
event2_tmp = Start(Epoch2);
night_duration = max([End(Epoch1) ; End(Epoch2)]); 


%% Intersection : recall and precision

%intersection
larger_epoch2 = [Start(Epoch2)-marginEp2, End(Epoch2)+marginEp2];
[status, ~, ~] = InIntervals(event1_tmp, larger_epoch2);
both_event  = sum(status);

%recall & precision
recall    = both_event / length(event1_tmp);
precision = both_event / length(event2_tmp);


%% Density estimation

%intervals
intervals_start = 0:densityBin:night_duration;    
x_intervals = (intervals_start + densityBin/2)/(3600E4);

%density epoch 1
event1_density = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + densityBin);
    event1_density(t) = length(Restrict(ts(event1_tmp),intv)) / tot_length(intv,'s');
end
event1_density = Smooth(event1_density, smoothing);
    
%density epoch 2
event2_density = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + densityBin);
    event2_density(t) = length(Restrict(ts(event2_tmp),intv)) / tot_length(intv,'s');
end
event2_density = Smooth(event2_density, smoothing);
    
%distance and slope difference
diff_slope        = CompareDecreaseDensity(event1_density, event2_density, x_intervals');
distance_density  = DiscreteFrechetDist(event1_density, event2_density);


%% Duration difference
dur1 = median(End(Epoch1) - Start(Epoch1))/10; %in ms
dur2 = median(End(Epoch2) - Start(Epoch2))/10; %in ms
diff_duration =  dur1 - dur2;


%% curves
curves.x  = x_intervals';
curves.y1 = event1_density;
curves.y2 = event2_density;


end





