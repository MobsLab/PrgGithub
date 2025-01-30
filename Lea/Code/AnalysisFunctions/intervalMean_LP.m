%% INTERVALMEAN_LP function :
%
% 24/03/2020 LP
%
% Function : Return mean value of tsd within each of the intervals of an
% intervalSet, or within all intervals
%
% ----------------- INPUTS ----------------- :
%
%   - tsd_object : tsd, timestamps in 1E-4 s 
%
%   - intervals : IntervalSet with each time interval in which mean value is
%   computed, in 1E-4 s
%
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'union' : if = 1, computes the mean value over time for all intervals
%   together.  if = 0, returns mean value for each interval.
%              Default : union = 0
%
%   - 'timestamps' : can be = 'start', 'middle', 'end' of the interval on
%   which the mean is computed
%              Default : timestamps = 'middle'
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - mean_value : 
%           - if union = 0, tsd array with Data = mean value of tsd for each time interval
%                                         Range = middle time of each interval
%           - if union = 1, mean value of tsd data, over union of all intervals in intervalSet
% 
% /!\ in input time unit ^-1.  
%
%
%
% ----------------- Examples ----------------- :
%
%
% Timecourse with mean value of bandpower (bandpow_tsd) in each sliding timewindow :
%
%                                       % DEFINE : interval_start, interval_end, step, windowsize
%                                       window_starts = interval_start:step:interval_end ;
%                                       all_timewindows = intervalSet(window_starts,window_starts+windowsize) ;
%                                       mean_bandpow = intervalMean_LP(bandpow_tsd,all_timewindows,'union',0);
% 
% Mean value of bandpower during N1 :
%                                      mean_bandpow_N1 = intervalMean_LP(bandpow_tsd,N1,'union',1);




function mean_value = intervalMean_LP(tsd_object, intervals, varargin)


% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if nargin < 2 || mod(length(varargin),2) ~= 0  % At least 4 required arguments, and optional arguments as pairs ('arg_name', arg)  
        error('Incorrect number of parameters.');
    end
    
    % Check type of arguments :
    if ~strcmpi(class(tsd_object),'tsd') 
        error('First argument (tsd_object) has to be a tsd')
    end
    if ~strcmpi(class(intervals),'intervalSet') 
        error('Second argument (intervals) has to be an intervalSet')
    end
        
    % Parse optional parameter list :
    for i = 1:2:length(varargin)    % for each 'arg_name'
        if ~ischar(varargin{i})     % has to be a character array
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch(lower(varargin{i}))
            case 'union'
                union = varargin{i+1}; % assign argument value
            case 'timestamps'
                timestamps = varargin{i+1}; % assign argument value
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not
    if ~exist('union','var')
        union = 0 ;
    end
    if ~exist('timestamps','var')
        timestamps = 'middle';
    end
    
% ---------------------------------- Extract Event Occupancy ----------------------------------- :

    if union 
    % Mean tsd value over union of all intervals
        mean_value = nanmean(Data(Restrict(tsd_object,intervals))) ;   
        
    else    
    % Mean tsd value for each interval
        all_mean = [] ;
        intervals_start = Start(intervals); intervals_end = End(intervals) ;
        
        for i=1:length(intervals_start) % for each interval in the intervalSet
            intv = intervalSet(intervals_start(i),intervals_end(i)) ;
           all_mean(i) = nanmean(Data(Restrict(tsd_object,intv))) ;   
        end  
        
        switch timestamps
            case 'start'
                intervals_timestamps = intervals_start ;
            case 'middle'
                intervals_timestamps = intervals_start + (intervals_end-intervals_start)/2 ;
            case 'end'
                intervals_timestamps = intervals_end ;
            otherwise
                error('Wrong value for optional argument "timestamps" : must be "start", "middle", or "end".')
        end    
        mean_value = tsd(intervals_timestamps, all_mean') ;
    end     
end











