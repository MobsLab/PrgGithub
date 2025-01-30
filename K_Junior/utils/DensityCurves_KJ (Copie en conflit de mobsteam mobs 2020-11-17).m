%%DensityCurves_KJ
% 22.06.2019 KJ
%
% function [x_density, y_density] = DensityCurves_KJ(events, varargin)
%
% INPUT:
% - events                  ts - events to deal with
%
% - homeostat (optional)    = 0, 1 or 2 - compute or not homeostat data (1: one fit, 2: double fit)
%                           (default 0)
% - windowsize (optional)   = windowsize for density computation
%                           (default 60s)
% - Epoch (optional)        = intervalSet - epoch where to compute homeostasis
%                           (default 'all night')
% - NewtsdZT (optional)     = tsd with timestamps and corresponding real ZT
%                           (default [])
% - starttime (optional)    = start time - in 1e-4 sec
%                           (default 0)
% - endtime (optional)      = end time - in 1e-4 sec
%                           (default - last event timestamp)
% - smoothing               = smoothing 
%                           (default 0)
%
% OUTPUT:
% - x_density       = timestamps of density curves
% - y_density       = values - number of events per windowsize
% - Hstat           = struct - data for homeostasis (x_intervals, y_density, x_peaks, y_peaks, p, reg)
%
%
% Example :
%   [x_density, y_density, Hstat] = DensityCurves_KJ(events, 'homeostat',1, 'windowsize',windowsize,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
%
% SEE 
%   PlotSwaDownDensity AdaptDensityCurves DensityOccupation_KJ
%
%


function [x_density, y_density, Hstat] = DensityCurves_KJ(events, varargin)

%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch (lower(varargin{i}))
        case 'homeostat'
            homeostat = varargin{i+1};
            if homeostat<0
                error('Incorrect value for property ''homeostat''.');
            end
        case 'windowsize'
            windowsize = varargin{i+1};
            if windowsize<=0
                error('Incorrect value for property ''windowsize''.');
            end
        case 'epoch'
            Epoch = varargin{i+1}; 
        case 'newtsdzt'
            NewtsdZT = varargin{i+1}; 
        case 'starttime'
            starttime = varargin{i+1};
            if starttime<0
                error('Incorrect value for property ''starttime''.');
            end
        case 'endtime'
            endtime = varargin{i+1};
            if endtime<=0
                error('Incorrect value for property ''endtime''.');
            end
        case 'smoothing'
            smoothing = varargin{i+1};
            if smoothing<0
                error('Incorrect value for property ''smoothing''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('homeostat','var')
    homeostat = 0;
end
if ~exist('windowsize','var')
    windowsize = 60E4; %60s
end
if ~exist('NewtsdZT','var')
    NewtsdZT = [];
end
if ~exist('starttime','var')
    starttime = 0;
end
if ~exist('endtime','var')
    endtime = max(Range(events))+2*windowsize;
end
if ~exist('smoothing','var')
    smoothing = 0;
end

if ~exist('Epoch','var')
    Epoch = intervalSet(starttime,endtime);
end


%ZT
if ~isempty(NewtsdZT)
    events = ts(Data(Restrict(NewtsdZT, events)));
    starttime = Data(Restrict(NewtsdZT, ts(starttime)));
    endtime = Data(Restrict(NewtsdZT, ts(endtime)));
    
    %Epoch format
    new_st = Data(Restrict(NewtsdZT, ts(Start(Epoch))));
    new_end = Data(Restrict(NewtsdZT, ts(End(Epoch))));
    Epoch = intervalSet(new_st, new_end);
    
end

%params
intervals_start = starttime:windowsize:endtime;
x_density = (intervals_start + windowsize/2)';
    
%density
y_density = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
    y_density(t) = length(Restrict(events,intv));
end

if smoothing>0
    y_density = Smooth(y_density,smoothing);
end


%% homeostat data
if homeostat
    Hstat = HomestasisStat_KJ(x_density, y_density, Epoch, homeostat);
else
    Hstat = cell(0);
end
   
end


