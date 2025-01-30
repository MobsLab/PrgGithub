
%% EVENTSDURATION_LP function :
%
% 05/03/2020
%
% Function : Mean duration of lasting events.
%            -->  over union of all intervals from intervalSet 
%            OR   for each intervalfrom intervalSet.
%            Can also return variance or std of duration instead of mean (Cf. varargin)  
%
% ----------------- INPUTS ----------------- :
%
%   - events : IntervalSets of lasting events (ex: deltas_PFCx ), in 1E-4 s
%
%   - intervals : IntervalSet with time intervals in which event duration is
%   computed, in 1E-4 s
%
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'union' : if = 1, computes the mean duration over the union of all intervals
%   together.  if = 0, returns mean duration of events for each interval.
%              Default : union = 1
%
%   - 'function' : function to be computed on event duration. 
%       Default = 'mean'. Other possible values : 'var', 'std', 'sem'.
%
% ----------------- OUTPUTS ----------------- :
%
%   - evt_density : 
%           - if union = 0, tsd array with Data = mean event duration for each time interval
%                                         Range = middle time of each interval
%           - if union = 1, mean event duration for events from all intervals in intervalSet
% 
% /!\ in input time unit ^-1.  
%
%
%
% ----------------- Examples ----------------- :
%
% Mean duration of deltas during REM : 
%                                       evt_duration = EventsDuration_LP(alldeltas_PFCx, REM, 'union', 1) ; 
%
% Variance of duration of deltas during N3 : 
%                                       evt_duration = EventsDuration_LP(alldeltas_PFCx, N3, 'union', 1, 'function', 'var') ; 
%
% Timecourse of mean delta duration with a sliding timewindow :
%
%                                       % DEFINE : interval_start, interval_end, step, windowsize
%                                       window_starts = interval_start:step:interval_end ;
%                                       timewindows = intervalSet(window_starts,window_starts+windowsize) ;
%                                       evt_duration = EventsDuration_LP( alldeltas_PFCx , timewindows,'union', 0) ;




function evt_duration = EventsDuration_LP(events, intervals, varargin)


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
            case 'function'
                func = varargin{i+1};
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not
    if ~exist('union','var')
        union = 1 ;
    end
    
    if ~exist('func','var')
        func = 'mean' ;
    end
    
% ---------------------------------- Extract Event Duration ----------------------------------- :

    if union 
    % Mean Event Duration over union of all intervals
        event_length_all = length(events,'ts','time','middle'); % tsd with middle time and length of all events
        event_in_interv = logical(belong(intervals,Range(event_length_all))); % true when event has its 'middle' during an interval from intervalSet
        evt_duration_all = Data(event_length_all) ; % duration of all events
        
        switch func
            case 'mean'
                evt_duration = mean(evt_duration_all(event_in_interv)); % mean duration of all events with middle time during an interval from intervalSet
            case 'var'
                evt_duration = var(evt_duration_all(event_in_interv)); % variance
            case 'std'
                evt_duration = std(evt_duration_all(event_in_interv)); % standard deviation
            case 'sem'
                evt_duration = std(evt_duration_all(event_in_interv)) / sqrt(sum(event_in_interv)); % standard deviation
        end
        
        
                
    else    
     % Mean Event Duration for each interval
        event_length_all = length(events,'ts','time','middle');
        all_interv_duration = [] ;
        intervals_start = Start(intervals); intervals_end = End(intervals) ;
        
        for i=1:length(intervals_start) % for each interval in the intervalSet
            intv = intervalSet(intervals_start(i),intervals_end(i)) ;
            event_in_interv = logical(belong(intv,Range(event_length_all))); % true when event with middle time during an interval from intervalSet
            evt_duration_all = Data(event_length_all) ; % duration of all events
            
            switch func
                case 'mean'
                    all_interv_duration(i) = mean(evt_duration_all(event_in_interv)); % mean duration for this interval
                case 'var'
                    all_interv_duration(i) = var(evt_duration_all(event_in_interv)); % variance
                case 'std'
                    all_interv_duration(i) = std(evt_duration_all(event_in_interv)); % standard deviation
                case 'sem'
                    all_interv_duration(i) = std(evt_duration_all(event_in_interv)) / sqrt(sum(event_in_interv)); % standard deviation
            end   
        
        end
        
        intervals_middle = intervals_start + (intervals_end-intervals_start)/2 ;
        evt_duration = tsd(intervals_middle, all_interv_duration') ;
        
    end
    
end