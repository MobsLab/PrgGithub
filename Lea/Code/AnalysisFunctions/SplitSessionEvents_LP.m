%% SPLITSESSIONEVENTS_LP() function :
%
% 17/06/2020
%
% Function : Get events (ts or intervalset) separately for successive
% periods of time (whole session defined by 'epoch', divided in 'nb_periods'
% periods).
%
%
% ----------------- INPUTS ----------------- :
%
%   - events :      ts with times of events OR intervalSet with intervals of events
%   - nb_periods :  nb of same length periods in which to divide the session
%   - epoch :  interval(s) of the session (ex. SWS), for the total time length to be divided in nb_periods
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
% ----------------- OUTPUTS ----------------- :
%
%   - split_events : cell array, with ts or intervalSet for each of the
%   periods (number of elements = nb_periods)
%
%   - periods_is : intervalSet of the periods
%
% ----------------- Example ----------------- :
%
%       [split_events, periods_is] = SplitSessionEvents_LP(slowwave_type3.deep_peaktimes,3,SWS) ;
%                   (to get a cell array with 3 ts, containing slow waves
%                   from begin, middle, and end of the session)



function [split_events,periods_is] = SplitSessionEvents_LP(events,nb_periods,epoch)


    %% CHECK INPUTS
% 
%     if nargin < 3 || mod(length(varargin),2) ~= 0
%       error('Incorrect number of parameters.');
%     end
% 
%     % Parse parameter list
%     for i = 1:2:length(varargin)
%         if ~ischar(varargin{i})
%             error(['Parameter ' num2str(i+2) ' is not a property.']);
%         end
%         switch (varargin{i})
%             case 'arg'
%                 arg = varargin{i+1}; 
%             otherwise
%                 error(['Unknown property ''' num2str(varargin{i}) '''.']);
%         end
%     end
%     
%     %check if exist and assign default value if not
%     if ~exist('arg','var')
%         arg = 0 ;
%     end
%     
%     

    %% SPLIT SESSION
    
    % Get start and end times of the session
    s = Start(epoch) ; e = End(epoch) ;
    start_t = s(1)  ; end_t = e(end) ;
    
    % Divide session in nb_periods intervals
    period_length = (end_t - start_t)/nb_periods ; 
    periods_is = intervalSet(start_t:period_length:(end_t-period_length),(start_t+period_length):period_length:end_t);
    
    % Extract events for each period : 
    for i = 1:nb_periods
        period = subset(periods_is,i) ;  
        if strcmpi(class(events),'ts')  % if events = ts
                period_evts = Restrict(events,period) ; 
        elseif strcmpi(class(events),'intervalSet') % if events = intervalSet
                period_evts = intersect(events,period) ;
        else 
            error('Wrong class for argument "events". Must be "ts" or "intervalSet.')
        end
        split_events{i} = period_evts ;
    end
    
end

    
