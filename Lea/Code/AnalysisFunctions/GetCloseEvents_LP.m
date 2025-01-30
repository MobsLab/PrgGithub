%% GetCloseEvents_LP()
%
% 08.06.2020 LP
%
% Function : Get events which occur next to other reference events (OR NOT), within a co-occur delay.
% -> possibility to restrict to epoch. 
%
%
% ----------------- INPUTS ----------------- :
%
%   - obs_ts : ts of 'observed' events
%
%   - ref_ts : ts of times around which to keep/reject 'observed' events
%
%   - detection_delay : duration of delay pre- and post- ref event to check
%   for observed events to keep/reject. In ms. 
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value)
%
%   - 'keep_events' : if = 1 keep only events next to ref events. if = 0,
%   keep only events which are NOT close to ref events (ie. reject close events). 
%       (default = 1) 
%
%   - 'epoch' : restrict events to epoch
%       (default = 'none') 
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - obs_ts_subset : ts of events, after keeping only events of interest.
%   - subset_ix : index of kept events in obs_ts.
%   - prop : proportion of kept events (after epoch restriction for input ts).
%
%
% ----------------- Example ----------------- :
%
%      [obs_ts_subset, subset_ix, prop] = GetCloseEvents_LP(obs_ts,ref_ts,250,'epoch',SWS,'keep_events',0) ;  
% 
% (ex ref_ts =
% ts(sort([Range(slowwave_type3.deep_peaktimes)',Range(slowwave_type4.deep_peaktimes)',Range(slowwave_type6.deep_peaktimes)'])) ; % ts with all ref slow waves (deep positive))





function [obs_ts_subset, subset_ix, prop] = GetCloseEvents_LP(obs_ts,ref_ts,detection_delay,varargin)
  

% ---------------------------------- Check optional parameters ----------------------------------- :

 
    if nargin < 3 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list
    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (varargin{i})
            case 'keep_events'
                keep_events = varargin{i+1};
                if keep_events ~= 0 & keep_events ~= 1 
                   error('Incorrect value for optional argument "keep_events" : must be 0 or 1.') 
                end  
            case 'epoch'
                epoch = varargin{i+1};
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end
    
    %check if exist and assign default value if not
    if ~exist('keep_events','var')
        keep_events = 1 ;
    end
    if ~exist('epoch','var')
        epoch = 'none' ;
    end
    
    
    % ------------- Restrict events to epoch if required ------------- : 
    
    if ~strcmpi(epoch,'none')
        obs_ts = Restrict(obs_ts,epoch) ; 
        ref_ts = Restrict(ref_ts,epoch) ; 
    end
    
    % ------------- Detect observed events which occur next to ref events ------------- : 
    
    [co, cot] = EventsCooccurrence(obs_ts,ref_ts, [detection_delay detection_delay]) ;
    obs_times = Range(obs_ts) ;
    
     if keep_events % If keep only close events : 
        close_obs_times = obs_times(co) ; 
        obs_ts_subset = ts(close_obs_times) ; 
        subset_ix = find(co) ; 
     else % If reject close events :
        far_obs_times = obs_times(~co) ;
        obs_ts_subset = ts(far_obs_times) ; 
        subset_ix = find(~co) ; 
     end  
         
     prop = length(Range(obs_ts_subset)) / length(Range(obs_ts)) ; 
end

