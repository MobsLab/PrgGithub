%% HomeostasisEventDensity_LP() function 
%
%
% 08.06.2020 LP
%
% Function : Get homeostasis on event density. For global and 2 fit.
%
% ----------------- INPUTS ----------------- :
%
%   - event_ts : ts of events
%
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value)
%
%   - windowsize : Duration (in s) of sliding windowsize on which to compute event density timecourse. 
%                   (default = 60s)
%
%   - 'epoch' : Epoch on which to restrict homeostasis quantification. 
%                   (default = clean SWS from current directory)
%   
%   - 'plot' : if = 1, plot event_ts density and the regression fit. 
%             (Default = 1)
%
%   - 'newfig' : if = 1, plot in a new fig.
%                (Default = 1)
%
%   - 'ZTtime' : tsd of ZT time, to convert time to ZT time.
%
%   - 't_session' : array where 1st and last elements are times for the fit = start and end of the session.
%               (Default = t_session taken as Range(LFPdeep) from current
%               directory)
%
%   - 'firstfit_duration' : duration of the first fit, starting at the 
%   first detected local maxima. Second fit is on the rest of the session. 
%   Unit = hours. 
%             (Default = 3)
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - GlobalFit : structure with info about global regression 
%   - TwoFit : structure with info about the 2 successive regressions
%
% Structure fields :
%       - time
%       - data
%       - idx_localmax : indices of data points in tsd corresponding to
%       local maxima used for regression
%       - reg_coeff : coefficients of linear regression (in descending
%       power, Cf. polyfit() function)
%       - R2 : determination coefficient
%
%       -> + Plot if plot = 1. 
%
%
% ----------------- Example ----------------- :
%
%      [GlobalFit, TwoFit] = HomeostasisEventDensity_LP(event_ts,'epoch',cleanSWS,'ZTtime',NewtsdZT,'windowsize',60, 'plot',1) ; 
%      




function [GlobalFit, TwoFit] = HomeostasisEventDensity_LP(event_ts,varargin)
  

% ---------------------------------- Check optional parameters ----------------------------------- :

 
    if nargin < 1 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list
    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (varargin{i})
            case 'plot'
                toplot = varargin{i+1};
                if toplot ~= 0 & toplot ~= 1 
                   error('Incorrect value for optional argument "plot" : must be 0 or 1.') 
                end  
            case 'newfig'
                newfig = varargin{i+1};    
            case 'ZTtime'
                ZTtime = varargin{i+1};
            case 'firstfit_duration'
                firstfit_duration = varargin{i+1}; 
            case 'windowsize'
                windowsize = varargin{i+1};
            case 'epoch'
                epoch = varargin{i+1};   
            case 't_session'
                t_session = varargin{i+1};                 
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    %check if exist and assign default value if not
    if ~exist('toplot','var')
        toplot = 0 ;
    end

    if ~exist('newfig','var')
        newfig = 1 ;
    end    
    
    if ~exist('firstfit_duration','var')
        firstfit_duration = 3 ;
    end

    if ~exist('windowsize','var')
        windowsize = 60 ; % in s
    end

    if ~exist('epoch','var')
        % Default = clean SWS 
        disp('Warning : Extracting SWS period from current directory!')    
        load('SleepSubstages.mat')
        SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
        try load NoiseHomeostasisLP TotalNoiseEpoch % noise
            cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
            epoch = cleanSWS ; 
        catch disp('Warning : File with noise to be removed NOT FOUND in current directory')
        end 
    end      
    
    if ~exist('t_session','var')
        try
            load('ChannelsToAnalyse/PFCx_deep') 
            disp('Warning : Extracting t_session from LFP in current directory!')
            load(['LFPData/LFP',num2str(channel)])
            t_session = Range(LFP)/(1E4) ;
        catch
            disp ('Warning : 1st and last event are taken as start and end times of fits.')
            t_session = Range(event_ts)/(1E4) ; % WARNING : not same window definition as in scripts where t = Range(LFPdeep)/(1E4) ;
        end
    end
        
    if ~exist('ZTtime','var')
        % load from directory
    disp('Warning : Extracting ZT time from current directory!')    
    load('behavResources.mat', 'NewtsdZT')
    ZTtime = 'NewtsdZT' ; 
    end     
    
    
    % -------------- Sliding timeWindows (no overlap) -------------- :
    t = t_session ; 
    window_starts = t(1):windowsize:(t(end)-windowsize) ;
    all_timewindows = intervalSet(window_starts*1E4, (window_starts+windowsize)*1E4) ;

    % Restrict timewindows to SWS :
    epoch_timewindows = intersect(all_timewindows,epoch) ;
    epoch_timewindows = dropShortIntervals(epoch_timewindows,3e4) ; % drop intervals shorter than 3s

    
    
    % --- Out of epoch intervals (to assign NaN values)--- :

    session = intervalSet(t(1)*1e4,t(end)*1e4); % whole session
    outofepoch = diff(session,epoch_timewindows);

    % If out of epoch is not empty : 
    if mean(length(outofepoch)) ~= 0 
        outofepoch_timewindows = intersect(all_timewindows,outofepoch) ; %timewindows out of epoch
        outofepoch_timewindows_middle = Start(outofepoch_timewindows) + Data(length(outofepoch_timewindows))/2 ;
        outofepoch_tsd = tsd(outofepoch_timewindows_middle,repmat(NaN,[length(Start(outofepoch_timewindows)),1])); % NaN for each timewindow out of epoch
    else
        disp('Warning : out of epoch is empty.') 
    end   

    
     % ------ Get Event Density during Epoch ------ :
       
    evt_density = EventsDensity_LP(event_ts,epoch_timewindows, 'union', 0) ;
    % normalize event_density by mean density on entire epoch
    mean_evt_density = EventsDensity_LP(event_ts,epoch_timewindows, 'union', 1) ;
    evt_density = tsd(Range(evt_density),Data(evt_density)/mean_evt_density*100) ; % expressed as a percentage of mean event density during whole epoch (SWS)

    % ------ Assign 'NaN' value out of Epoch ------ : 

    % If out of epoch is not empty : 
    if mean(length(outofepoch)) ~= 0 
        % Concatenate epoch data with out of epoch NaNs : 
        evt_density = concat_tsd(evt_density,outofepoch_tsd) ; 
    end

    
    [GlobalFit, TwoFit] = Homeostasis2Fit_LP(evt_density,'plot',toplot,'newfig',newfig,'ZTtime',ZTtime) ; % Get homeostasis data (and plot) for multiple fits
        
    if toplot
        title([ 'Event Density Homeostasis (Windowsize: ' num2str(windowsize) 's, ' sprintf('%.3e',length(Range(event_ts))) ' events)'],'FontSize',12) ;
        xlabel('ZT Time (hours)') ; ylabel('Normalized Event Density') ;
    end   
        
end
