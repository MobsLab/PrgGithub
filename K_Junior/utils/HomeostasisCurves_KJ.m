%%HomeostasisCurves_KJ
% 22.06.2019 KJ
%
% function Qdensity = HomeostasisCurves_KJ(events, varargin)
%
% INPUT:
% - events                  ts - events to deal with
%
% - windowsize (optional)   = windowsize for density computation
%                           (default 60s)
% - epoch (optional)        = intervalSet - epoch to Restrict the curves (e.g. NREM)
%                           (default [])
% - newtsdzt                = tsd (timestamps, real time), containing the real time of the day
%
% OUTPUT:
% - Qdensity                tsd - timestamps and number of events per window
%
%
% Example:
%      Qdensity = HomeostasisCurves_KJ(events, 'epoch', NREM, 'newtsdzt', NewtsdZT);
%
% 
%  SEE 
%    DensityCurves_KJ AdaptDensityCurves 
%


function Qdensity = HomeostasisCurves_KJ(events, varargin)

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
        case 'windowsize'
            windowsize = varargin{i+1};
            if windowsize<=0
                error('Incorrect value for property ''windowsize''.');
            end
        case 'epoch'
            Epoch = varargin{i+1};  
        case 'newtsdzt'
            NewtsdZT = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('windowsize','var')
    windowsize = 60e4; %60s
end
if ~exist('Epoch','var')
    Epoch = [];
end
if ~exist('Epoch','var')
    NewtsdZT = [];
end


% convert to real times eventually
if ~isempty(NewtsdZT)
    %events
    events = ts(Data(Restrict(NewtsdZT, events)));
    %Epoch
    if ~isempty(Epoch)
        st_epoch  = Data(Restrict(NewtsdZT,ts(Start(Epoch))));
        end_epoch = Data(Restrict(NewtsdZT,ts(End(Epoch))));
        Epoch = intervalSet(st_epoch, end_epoch); 
    end
end


%events density
Qdensity = MakeQfromS(tsdArray(events),windowsize);




%keep only Epoch periods eventually
if ~isempty(Epoch)
    x_density = Range(Qdensity);
    y_density = Data(Qdensity);

    idx_epoch = ismember(x_density, Range(Restrict(ts(x_density), Epoch)));
    y_density = y_density(idx_epoch);
    x_density = x_density(1:length(y_density));
    
    Qdensity = tsd(x_density, y_density);
end

    
end


