%% slidingEVENTSOCCUPANCY_LP function :
%
% 04/03/2020
%
% Function : Occupancy of (interval) events, ie. duration proportion,
% as a function of time (computed over sliding timewindows).
%
% ----------------- INPUTS ----------------- :
%
%   - events : IntervalSets of lasting events (ex: deltas_PFCx ), in 1E-4 s
%   - t : time array with first and last time of full time window to compute occupancy, in s
%   - windowsize : duration of timewindow to compute occupancy, in s
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
%   - evt_occupancy : tsd array with Data = mean event occupancy for each window
%                                    Range = middle time of each window (1E-4 s)



function evt_density = slidingEventsOccupancy_LP(events, t, windowsize, varargin)


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
    
    % Event Density = Occurrence Frequency in each timewindow
    event_occupancy = [] ;
    for i=1:length(intervals_start)
        intv = intervalSet(intervals_start(i)*1E4,intervals_end(i)*1E4);
        event_occupancy(i) = tot_length(and(events,intv)) / (windowsize*1E4);   
    end  
    
    evt_occupancy = tsd((intervals_start+windowsize/2)*1E4, event_occupancy) ;
    
end