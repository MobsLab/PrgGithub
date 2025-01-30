
%% INTEREVENTSDURATION_LP function :
%
% 05/03/2020
%
% Function : Mean interevents duration
%            -->  over union of all intervals from intervalSet 
%            OR   for each intervalfrom intervalSet.
%            Can also return variance / std / sem of duration instead of mean (Cf. varargin)  
%
% ----------------- INPUTS ----------------- :
%
%   - events : IntervalSets of lasting events (ex: deltas_PFCx ), in 1E-4
%   s, or tsd / ts of point events (ex: tRipples).
%
%   - intervals : IntervalSet with time intervals in which interevent duration is
%   computed, in 1E-4 s
%
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'union' : if = 1, computes the mean duration over the union of all intervals
%   together.  if = 0, returns mean duration of interevents for each interval.
%              Default : union = 1
%
%   - 'function' : function to be computed on interevent duration. 
%       Default = 'mean'. Other possible values : 'var', 'std', 'sem'.
%
% ----------------- OUTPUTS ----------------- :
%
%   - evt_density : 
%           - if union = 0, tsd array with Data = mean interevent duration for each time interval
%                                         Range = middle time of each interval
%           - if union = 1, mean interevent duration for events from all intervals in intervalSet
% 
% /!\ in input time unit ^-1.  
%
%
%
% ----------------- Examples ----------------- :
%
% Mean inter-deltas duration during N3 : 
%                                       interevt_duration = IntereventsDuration_LP(alldeltas_PFCx, N3, 'union', 1) ; 
%
%
% Mean inter-ripples duration during REM : 
%                                       interevt_duration = IntereventsDuration_LP(tRipples, REM, 'union', 1) ; 
%
% Timecourse of mean inter-delta duration with a sliding timewindow :
%
%                                       % DEFINE : interval_start, interval_end, step, windowsize
%                                       window_starts = interval_start:step:interval_end ;
%                                       timewindows = intervalSet(window_starts,window_starts+windowsize) ;
%                                       interevt_duration = IntereventsDuration_LP( alldeltas_PFCx , timewindows,'union', 0) ;




function interevt_duration = IntereventsDuration_LP(events, intervals, varargin)


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

    
    % Check if exist and assign default value if not
    if ~exist('union','var')
        union = 1 ;
    end
    
    if ~exist('func','var')
        func = 'mean' ;
    end
    
        
% ---------------------------------- Create Interevent intervalSet ----------------------------------- :
    
    switch class(events)

        case 'tsd' % if point events
            interevents = toIntervalSet(events) ;

        case 'ts' % if point events
            interevents = toIntervalSet(events) ;

        case 'intervalSet' % if lasting events
            event_s = Start(events) ; event_e = End(events) ; 
            interevents = intervalSet(event_e(1:end-1), event_s(2:end));
                            % idem : interevents = diff(timeSpan(events),events)
        otherwise 
            error('Events must be in ts, tsd, or intervalSet format.');
    end
% ---------------------------------- Extract InterEvent Duration ----------------------------------- :


    if union 
    % Mean Inter-Event Duration over union of all intervals
    
    
        interevent_length_all = length(interevents,'ts','time','middle'); % tsd with middle time and length of all events
        
%         % IF : keep intervent durations only when FULL interevents (both start and end) belong to the interval
%         intereventstart_in_interv = logical(belong(intervals,Start(interevents))); % true when interevent starts during an interval from intervalSet
%         intereventend_in_interv = logical(belong(intervals,End(interevents))); % true when interevent ends during an interval from intervalSet
%         interevent_in_interv = and(intereventstart_in_interv, intereventend_in_interv) ; % true when entire interevent during interval (starts and ends during interval)
        
        % IF : keep intervent durations for all interevents WITH middle happening during interval (doesn't need to be entirely in interval)
        interevent_in_interv = logical(belong(intervals,Range(interevent_length_all))); 
                        
        interevt_duration_all = Data(interevent_length_all) ; % duration of all interevents
        
        switch func
            case 'mean'
                interevt_duration = mean(interevt_duration_all(interevent_in_interv)); % mean duration of all interevents happening during an interval from intervalSet
            case 'var'
                interevt_duration = var(interevt_duration_all(interevent_in_interv)); % variance
            case 'std'
                interevt_duration = std(interevt_duration_all(interevent_in_interv)); % standard deviation
            case 'sem'
                interevt_duration = std(interevt_duration_all(interevent_in_interv)) / sqrt(sum(interevent_in_interv)); % standard deviation
        end
        
        
                
    else    
     % Mean Event Duration for each interval
        interevent_length_all = length(interevents,'ts','time','middle');
        all_interv_duration = [] ;
        intervals_start = Start(intervals); intervals_end = End(intervals) ;
        
        for i=1:length(intervals_start) % for each interval in the intervalSet
            intv = intervalSet(intervals_start(i),intervals_end(i)) ;

%           % IF : keep intervent durations only when FULL interevents (both start and end) belong to the interval
%           intereventstart_in_interv = logical(belong(intv,Start(interevents))); % true when interevent starts during an interval from intervalSet
%           intereventend_in_interv = logical(belong(intv,End(interevents))); % true when interevent ends during an interval from intervalSet
%           interevent_in_interv = and(intereventstart_in_interv, intereventend_in_interv) ; % true when entire interevent during interval (starts and ends during interval)

            % IF : keep intervent durations for all interevents WITH middle happening during interval (doesn't need to be entirely in interval)
            interevent_in_interv = logical(belong(intv,Range(interevent_length_all)));             
            
            interevt_duration_all = Data(interevent_length_all) ; % duration of all events
            
            switch func
                case 'mean'
                    all_interv_duration(i) = mean(interevt_duration_all(interevent_in_interv)); % mean duration for this interval
                case 'var'
                    all_interv_duration(i) = var(interevt_duration_all(interevent_in_interv)); % variance
                case 'std'
                    all_interv_duration(i) = std(interevt_duration_all(interevent_in_interv)); % standard deviation
                case 'sem'
                    all_interv_duration(i) = std(interevt_duration_all(interevent_in_interv)) / sqrt(sum(interevent_in_interv)); % standard deviation
            end   
        
        end
        
        intervals_middle = intervals_start + (intervals_end-intervals_start)/2 ;
        interevt_duration = tsd(intervals_middle, all_interv_duration') ;
        
    end
    
end