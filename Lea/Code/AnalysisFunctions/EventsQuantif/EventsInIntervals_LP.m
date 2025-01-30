%% EVENTSININTERVALS_LP function :
%
% 27/02/2020
%
% Function : Return which events occur in intervals, and vice-versa.
%       ie. determine for each event if it occurs within an interval from  
%       the intervalSet, and for each interval if (at least) one event 
%       occurs during it. 
% -> return logical array for co-occurring events, and same for
% co-occurring intervals.
%
%
% ----------------- INPUTS ----------------- :
%
%   - events_ts : ts with times of events
%   - is : intervalSet with intervals
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
%   - 'prop' : if = 1, return the proportion instead of ts and is
%   outputs. Default = 0. 
%
% ----------------- OUTPUTS ----------------- :
%
%   - co_evt = ts of events which occur during an interval from is. 
% -> if prop = 'true', return the proportion (%) instead.
%
%   - co_intv = interval set with the intervals during which an event occurs.
% -> if prop = 'true', return the proportion (%) instead.
%
% ----------------- Example ----------------- :
%
%       [co_evt, co_is] = EventsInIntervals_LP(slowwave_type3.deep_peaktimes, alldown_PFCx,'prop',1) ;


function [co_evt, co_is] = EventsInIntervals_LP(events_ts, is, varargin)


    %% CHECK INPUTS

    if nargin < 2 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list
    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (varargin{i})
            case 'prop'
                prop = varargin{i+1}; 
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end
    
    %check if exist and assign default value if not
    if ~exist('prop','var')
        prop = 0 ;
    end
    
    
    %% DETECT CO-OCCURRENCE
    
    % ------------------- Find events within intervals ------------------- :     
    
    co_evt = Restrict(events_ts,is) ; 
    
    if prop % if return proportion instead
        co_evt = length(Range(co_evt))/length(Range(events_ts)) * 100 ;
    end
    
    
    % ------------------- Find intervals with events ------------------- :  
    
%     nb_inIntv = intervalCount(events_ts,is); %nb of co-occurring events in each interval
%     co_intv_idx = find(Data(nb_inIntv)>0) ; 
%     co_is = subset(is,co_intv_idx) ; 

    
    s = Start(is) ; e = End(is) ; 
    co_intv_idx = [] ; 
    for i = 1:length(s) % for each interval of the intervalSet
        intv = intervalSet(s(i),e(i)) ; 
        in_intv = belong(intv,Range(events_ts)) ; 
        if sum(in_intv) > 0 % if at leat one event in this interval
            co_intv_idx(i) = 1 ; 
        else % if no event in this interval
            co_intv_idx(i) = 0 ; 
        end
    end
    
    co_is = subset(is,find(co_intv_idx)) ;
    
        
    if prop % if return proportion instead
        co_is = length(Start(co_is))/length(Start(is)) * 100 ;
    end
    
end

