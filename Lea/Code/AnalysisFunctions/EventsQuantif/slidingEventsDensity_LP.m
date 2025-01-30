
%% slidingEVENTSDENSITY_LP function :
%
% 04/03/2020
%
% Function : Density of events, ie. mean occurrence frequency,
% as a function of time (computed over sliding timewindows).
%
% ----------------- INPUTS ----------------- :
%
%   - events : ts of events (ex: ts(Start(deltas_PFCx)) ), in 1E-4 s
%   - t : time array with first and last time of full time window, in s
%   - windowsize : duration of timewindow to compute event density, in s
%
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'step' : step between starts of 2 successive timewindows
%              Default = windowsize/2
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - evt_density : tsd array with Data = event density for each window
%                                  Range = middle of each window



function evt_density = slidingEventsDensity_LP(events, t, windowsize, varargin)


% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if nargin < 3 || mod(length(varargin),2) ~= 0  % At least 4 required arguments, and optional arguments as pairs ('arg_name', arg)  
      error('Incorrect number of parameters.');
    end
    
    % Parse optional parameter list :
    for i = 1:2:length(varargin)    % for each 'arg_name'
        if ~ischar(varargin{i})     % has to be a character array
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch(lower(varargin{i}))
            case 'step'
                step = varargin{i+1}; % assign argument value
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not
    if ~exist('step','var')
        step=windowsize/2;
    end
   
    
% ---------------------------------- Extract Event Density ----------------------------------- :

    % IntervalSet with time windows for the analysis :
    intervals_start = t(1):step:(t(end)-windowsize) ; %starting times for all successive windows
    intervals_end = intervals_start + windowsize ; % end times for all successive windows
    timewindows_is = intervalSet(intervals_start*1E4, intervals_end*1E4) ;

    
    % Event Density = Occurrence Frequency in each timewindow
    evt_density = intervalRate(events, timewindows_is, 'ts', 'time', 'middle') ;
    
end