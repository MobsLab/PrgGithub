%% RESPONSE-SORTED EVENTS function :
%
% 26/02/2020
%
% Function : Sort events according to the post-event response in the LFP
% signal(s), to extract the events with highest/lowest response, in up to
% two signals successively.
%
%
% ----------------- EXAMPLE ----------------- : 
%
% [SortedEvents_t, SortedEvents_idx, T_sorted, Timeaxis] = RespSortedEvents(tRipples, {LFPdeep, LFPsup}, {'high','low'}, [0 200])
%
% = times of ripple events, for only the 25% events with lowest SupLFP
%   among the 25% with highest DeepLFP (in the 200ms post-ripple).
%
%
% ----------------- INPUTS ----------------- :
%
%   - Events_t : ts with times of events (ex. tRipples, ...)
%
%   - LFP_signals : Cell array with tsd of LFP/signal which event-triggered
%   response is used to sort the events. One or two signals used for
%   sorting. If two signals, used successively in the provided order for
%   the sorting.
%   Ex. {LFPsup, LFPdeep}
%
%   - LFP_responses : Cell array, same length as LFP_signals, with 'high'
%   or 'low' for each signal, to specify the type of response used for the
%   sorting. 
%   Ex. {'low','high'} 
%
%   - sort_window : time window post-event used to sort the responses, 
%   defined as start and end of window, in milliseconds post-event.
%   Default = [0 50]
%
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'sort_proportion' : proportion of all events with highest or lowest
%   responses to keep. 
%   Default = 1/4
%
%   - 'halfplot_window' : half timewindow of the LFP data centered on ripples event, in ms
%   Default = 500
%
%   - 'mean_plot' : if =1, plots the event-triggered average of the LFP_signals
%   for the sorted/selected events.
%   Default = 0 (no plot)
%
%   - 'new_fig' : if =1, plots the mean_plot on a new figure
%   Default = 1.
%
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - SortedEvents_t : ts with times of sorted/selected events only
%
%   - SortedEvents_idx : double with indices of selected events among
%     Events_t times
%
%   - T_sorted : CellArray with Event-Triggered Average (matrix) for each of the LFP_signals, around selected events only. 
%
%   - Timeaxis : double with times related to event (in s), to plot T_sorted 
%
%


function [SortedEvents_t, SortedEvents_idx, T_sorted, Timeaxis] = RespSortedEvents(Events_t, LFP_signals, LFP_responses, sort_window, varargin)


% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if nargin < 4 || mod(length(varargin),2) ~= 0  % At least 4 required arguments, and optional arguments as pairs ('arg_name', arg)  
      error('Incorrect number of parameters.');
    end

    % Check validity of arguments :
    if ~iscell(LFP_signals) || ~iscell(LFP_responses) || length(LFP_signals) > 2 || length(LFP_signals)~= length(LFP_responses)
      error('LFP_signals and LFP_responses must be cell arrays with 1 or 2 elements both (same number of elements for both). ');  
    end    
    
    % Parse optional parameter list :
    for i = 1:2:length(varargin)    % for each 'arg_name'
        if ~ischar(varargin{i})     % has to be a character array
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch(lower(varargin{i}))
            case 'sort_proportion'
                sort_proportion = varargin{i+1}; % assign argument value
                if sort_proportion<=0 || sort_proportion>1
                    error('Incorrect value for property ''sort_proportion''.');
                end
            case 'halfplot_window'
                halfplot_window = varargin{i+1};
            case 'mean_plot'
                mean_plot = varargin{i+1};
            case 'new_fig'
                new_fig = varargin{i+1};
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not
    if ~exist('sort_proportion','var')
        sort_proportion=1/4;
    end
    if ~exist('halfplot_window','var')
        halfplot_window=500;
    end
    if ~exist('mean_plot','var')
        mean_plot=0; % no plot
    end
    if ~exist('new_fig','var')
        new_fig=1;
    end    
    
    
     % --------------------------- --- Get event-triggered LFP -------------------- ---------- :

    events = Range(Events_t) ;
    [M1,T1]=PlotRipRaw(LFP_signals{1},events/(1E4),halfplot_window,0,0,0); % Get event-triggered average of first (or only) LFP signal.
    
    
    % -------------- Get timewindow and proportion of events to sort LFP values -------------- :
    
    nbTimePoints = size(T1,2) ; sort_timepoints = round(sort_window*nbTimePoints/(halfplot_window*2)) ; event_timepoint = round(nbTimePoints/2) ;
    sort_timepoints = (event_timepoint+sort_timepoints(1)) : (event_timepoint+sort_timepoints(2)) ; % convert to a timepoint window
    
    n_sortingEvents = round(length(events) * sort_proportion) ; % number of events to select, with highest or lowest response in first (or only) LFP signal
    n_sortingEvents2 = round(n_sortingEvents * sort_proportion) ; % if two LFP signals : among pre-selected events, number of events with highest 
                                                                                         % or lowest response in 2nd LFP signals to keep  
    
                                                                                         
                                                                                         
    % -------------- Get sorted event-triggered LFP, for first (or only) LFP signal -------------- :
    
    
    [BE,id1]=sort(mean(T1(:,sort_timepoints),2)); % get order of events with ascending responses within timewindow, for first (or only) LFP signal. 
    
    
    % Extract LFP responses with lower or higher post-event responses, for 1st LFP signal :
    
    switch lower(LFP_responses{1}) 
        case 'low'
            sorted_idx = id1(1:n_sortingEvents) ;        
        case 'high'
            sorted_idx = id1(end-n_sortingEvents:end) ;
        otherwise 
            error('Unknown sorting criteria in LFP_responses. Has to be "high" or "low".') ;
    end 
    T1_sorted  =  T1(sorted_idx,:); % keep only the (sort_proportion ex.25% ) event-triggered LFP, with highest/lowest post-event response in the 1st LFP signal
    sorted_times = events(sorted_idx);

    

    % If ONLY ONE LFP SIGNAL to sort the events :

    
    if length(LFP_signals) == 1
        
        % Output :  
        SortedEvents_idx = sorted_idx ;
        SortedEvents_t = ts(sort(sorted_times)) ; 
        T_sorted = {T1_sorted} ;
        Timeaxis = M1(:,1)' ;    
         
    % If TWO LFP SIGNALS to sort the events :
    
    % -------------- Get completely sorted event-triggered LFP, for first and 2nd LFP signal -------------- :
    
    elseif length(LFP_signals) == 2    
        
        [M2,T2]=PlotRipRaw(LFP_signals{2},events/(1E4),halfplot_window,0,0,0); % Get event-triggered average of 2nd LFP signal.
        T2_sorted = T2(sorted_idx,:); % Keep only responses of 2nd signal for events with previously selected response on the 1st signal
        
        [BE,id2]=sort(mean(T2_sorted(:,sort_timepoints),2)); % get order of events with ascending responses within timewindow, 
                                                      % for 2nd (previously selected) LFP signals. 
        
        switch lower(LFP_responses{2}) 
            case 'low'
                sorted_idx2 = id2(1:n_sortingEvents2) ;
            case 'high'
                sorted_idx2 = id2(end-n_sortingEvents2:end) ;    
            otherwise 
                error('Unknown sorting criteria in LFP_responses. Has to be "high" or "low".') ;
        end    
               
        T1_sorted2  =  T1_sorted(sorted_idx2,:);
        T2_sorted2  =  T2_sorted(sorted_idx2,:);
        sorted_times2 = sorted_times(sorted_idx2);

        % Output :        
        SortedEvents_idx = sorted_idx(sorted_idx2) ;
        SortedEvents_t = ts(sort(sorted_times2)) ; 
        T_sorted = {T1_sorted2, T2_sorted2} ;
        Timeaxis = M1(:,1)' ; 
        
    end
    
    
    % --------------------------------------- Mean Plot (if plot = 1) -------------------------------------- :
    mean_plot = logical(mean_plot) ;
    if mean_plot
        
        if new_fig
           figure, 
        end
        
        if length(LFP_signals) == 1
            
            mT1_sorted = mean(T1_sorted);
            plot(Timeaxis, mT1_sorted,'color',[0 0.25 0.65]), xline(0,'k--');
            title(['Event-triggered Average for ' LFP_responses{1} 'est LFP']), xlabel('time from event (s)');
    
        elseif  length(LFP_signals) == 2
                
            mT1_sorted2 = mean(T1_sorted2);
            mT2_sorted2 = mean(T2_sorted2);
            
            hold on , plot(Timeaxis, mT1_sorted2,'color',[0 0.25 0.65]), plot(Timeaxis,mT2_sorted2,'color',[0.25 0.7 0.9]), xline(0,'k--');
            legend({'LFP n°1','LFP n°2'},'Location','southwest') ;
            title(['Event-triggered Average for ' LFP_responses{1} 'est LFP n°1, ' LFP_responses{2} 'est LFP n°2' ]), xlabel('time from event (s)');
        end
            
    end    
      

end





