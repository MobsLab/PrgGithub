
%% EVENTSDENSITY_LP function :
%
% 05/03/2020
%
% Function : Density of events, ie. mean occurrence frequency.
%            -->  Mean density over union of all intervals from intervalSet 
%            OR   Mean density of each interval (ex. computed over sliding timewindows).
%
% ----------------- INPUTS ----------------- :
%
%   - events : ts of events (ex: ts(Start(deltas_PFCx)) ), in 1E-4 s
%
%   - intervals : IntervalSet with time intervals from which density is
%   computed, in 1E-4 s
%
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'union' : if = 1, computes the mean density over the union of all intervals
%   together.  if = 0, returns mean density for each interval.
%              Default : union = 1
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - evt_density : 
%           - if union = 0, tsd array with Data = event density for each time interval
%                                         Range = middle time of each interval
%           - if union = 1, mean density value over union of all intervals in intervalSet
% 
% /!\ in input time unit ^-1.  
%
%
%
% ----------------- Examples ----------------- :
%
% Mean density of deltas during REM : 
%                                       evt_density = EventsDensity_LP( ts(Start(alldeltas_PFCx)) , REM, 'union', 1) ; 
%
% Timecourse of delta density with sliding timewindow :
%
%                                       % DEFINE : interval_start, interval_end, step, windowsize
%                                       window_starts = interval_start:step:interval_end ;
%                                       timewindows = intervalSet(window_starts,window_starts+windowsize) ;
%                                       evt_density = EventsDensity_LP( ts(Start(alldeltas_PFCx)) , timewindows,'union', 0) ;




function evt_density = EventsDensity_LP(events, intervals, varargin)


% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if nargin < 2 || mod(length(varargin),2) ~= 0  % At least 4 required arguments, and optional arguments as pairs ('arg_name', arg)  
      error('Incorrect number of parameters.');
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
   
    
% ---------------------------------- Extract Event Density ----------------------------------- :

    if union 
    % Mean Event Density over union of all intervals
       tot_nb_events = sum(Data(intervalCount(events,intervals))) ; 
       tot_duration = sum(End(intervals)-Start(intervals)) ; 
       evt_density = tot_nb_events / tot_duration ;
        
    else    
     % Timecourse of Event Density = Occurrence Frequency in each timewindow
        all_event_density = [] ;
        intervals_start = Start(intervals); intervals_end = End(intervals) ;
        
        for i=1:length(intervals_start) % for each interval in the intervalSet
            intv = intervalSet(intervals_start(i),intervals_end(i)) ;
            all_event_density(i) = sum(belong(intv,Range(events))) / (intervals_end(i)-intervals_start(i)) ; % number of events during interval divided by interval length   
        end  
        intervals_middle = intervals_start + (intervals_end-intervals_start)/2 ;
        evt_density = tsd(intervals_middle, all_event_density') ;
        
      % OR if working :
      % evt_density = intervalRate(events,intervals, 'ts', 'time', 'middle') ;
      
    end
    
end