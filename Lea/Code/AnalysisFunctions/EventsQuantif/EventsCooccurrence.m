%% EVENTSCOOCCURRENCE function :
%
% 27/02/2020  LP
%
% Function : Co-occurrence of events1 with events2, 
%       ie. determine for each event of events1 if it occurs within a timewindow 
%       centered around any event from events2.
%
%
% ----------------- INPUTS ----------------- :
%
%   - events1 : ts with times of events1
%   - events2 : ts with times of events2
%   - timewindow : 1x2 array with duration pre-event2 and post-event2, in
%   ms. ex. [200 100] = from 200ms before event2 to 100ms after event2.
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
% ----------------- OUTPUTS ----------------- :
%
%   - cooccur = boolean vector. For each event of events1, true if event
%   co-occurs with an event from events2 (within a timewindow centered around
%   event 2).
%
%   - cooccur_times = ts of times of events1 co-occurring with events2.
%
%
% ----------------- Example ----------------- :
%
%       [cooccur, cooccur_times] = EventsCooccurrence(ts(Start(alldeltas_PFCx)),ts(Start(alldown_PFCx)), [150 150]) ;


function [cooccur, cooccur_times] = EventsCooccurrence(events1, events2, timewindow, varargin)


    %% CHECK INPUTS

    if nargin < 3 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    %% DETECT CO-OCCURRENCE
    
    % ------------------- Create intervals around events2 ------------------- : 
    
    % Remove potential overlaps by merging windows :
    events2 = Range(events2) ;
    timewindow = timewindow * 10 ; %convert to same time unit (1E-4 s)
    start = events2-timewindow(1) ;
    stop = events2+timewindow(2) ;
    overlap = start(2:end) < stop(1:end-1) ; % true if an interval begins before the previous interval ended
    overlap_idx = find(overlap);
    
    start(overlap_idx + 1) = [] ;
    stop(overlap_idx) = [] ;
    
    % Create intervals between starts and stops :
    intervals = intervalSet(start, stop);
    
    % ------------------- Find events1 within intervals ------------------- :     
    
    cooccur = logical(belong(intervals, Range(events1)));
    cooccur_times = Range(events1); cooccur_times = ts(cooccur_times(cooccur)) ;
    
    
    
end

