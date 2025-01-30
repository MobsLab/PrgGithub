
%% EVENTSOCCUPANCY_LP function :
%
% 05/03/2020
%
% Function : Occupancy of (interval) events, ie. duration proportion.
%            -->  Mean occupancy over union of all intervals from intervalSet 
%            OR   Mean occupancy for each interval (ex. computed over sliding timewindows).
%
% ----------------- INPUTS ----------------- :
%
%   - events : IntervalSets of lasting events (ex: deltas_PFCx ), in 1E-4 s
%
%   - intervals : IntervalSet with time intervals in which occupancy is
%   computed, in 1E-4 s
%
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'union' : if = 1, computes the mean occupancy over time for all intervals
%   together.  if = 0, returns mean occupancy for each interval.
%              Default : union = 1
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - evt_occupancy : 
%           - if union = 0, tsd array with Data = event occupancy for each time interval
%                                         Range = middle time of each interval
%           - if union = 1, mean occupancy value over union of all intervals in intervalSet
% 
% /!\ in input time unit ^-1.  
%
%
%
% ----------------- Examples ----------------- :
%
% Mean occupancy of deltas during REM : 
%                                       evt_occupancy = EventsOccupancy_LP(alldeltas_PFCx , REM, 'union', 1) ; 
%
% Timecourse of delta occupancy with sliding timewindow :
%
%                                       % DEFINE : interval_start, interval_end, step, windowsize
%                                       window_starts = interval_start:step:interval_end ;
%                                       timewindows = intervalSet(window_starts,window_starts+windowsize) ;
%                                       evt_density = EventsOccupancy_LP( alldeltas_PFCx , timewindows,'union', 0) ;




function evt_occupancy = EventsOccupancy_LP(events, intervals, varargin)


% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if nargin < 2 || mod(length(varargin),2) ~= 0  % At least 4 required arguments, and optional arguments as pairs ('arg_name', arg)  
        error('Incorrect number of parameters.');
    end
    
    % Check type of arguments :
    try 
        Start(events);
    catch 
        error('First argument (events) has to be an intervalSet.')
    end
        
    % Parse optional parameter list :
    for i = 1:2:length(varargin)    % for each 'arg_name'
        if ~ischar(varargin{i})     % has to be a character array
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch(lower(varargin{i}))
            case 'union'
                union = varargin{i+1}; % assign argument value
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not
    if ~exist('union','var')
        union = 1 ;
    end
   
    
% ---------------------------------- Extract Event Occupancy ----------------------------------- :

    if union 
    % Mean Event Occupancy over union of all intervals
       evts_duration = tot_length(and(events,intervals)) ; 
       tot_interv_duration = tot_length(intervals) ; % = sum(End(intervals)-Start(intervals)) ; 
       evt_occupancy = evts_duration / tot_interv_duration ;
        
    else    
    % Timecourse of Event Occupancy / Mean occupancy for each interval
        all_event_occupancy = [] ;
        intervals_start = Start(intervals); intervals_end = End(intervals) ;
        
        for i=1:length(intervals_start) % for each interval in the intervalSet
            intv = intervalSet(intervals_start(i),intervals_end(i)) ;
            all_event_occupancy(i) = tot_length(and(events,intv)) / (intervals_end(i)-intervals_start(i)) ;
            
        end  
        intervals_middle = intervals_start + (intervals_end-intervals_start)/2 ;
        evt_occupancy = tsd(intervals_middle, all_event_occupancy') ;
    
end