%% GetSWAchannel_LP() function 
%
% 09.04.2020 LP
%
% [t_swa, y_swa, Homeo_res] = GetSWAchannel(channel, varargin)
%
% Function : Get Slow Wave Activity (SWA) timecourse (on a sliding timewindow).
%            Optional plot. SWA defined as mean spectral power (default : in the
%            1-4Hz frequency range), normalized.
%
%
% SEE : HomeostasisMultiFit_LP()  Homeostasis1Fit_LP()
%
%
% ----------------- INPUTS ----------------- :
%
%   - channel : nº of LFP channel 
%
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
%   - 'multifit_thresh' :   wake duration threshold for multiple linear fits, in min
%                           (min wake duration to separate to sleep
%                           periods).
%                           If 'none' : simple linear fit or double linear fit (cf 'twofit').
%                           (default = 'none' -> simple linear fit)
%
%   - 'twofit_duration' :   duration of the first fit when two fits, in hours.
%                           If 'none' : simple linear fit or multifit (cf. multifit_thresh'.
%                           (default = 'none') 
%
%   - 'epoch' : intervalSet - epoch on which to compute (and normalize) SWA 
%                           (default = 'all night')
%
%   - 'plot' : if = 1, plots the SWA and fits. If = 0, no plot.
%                           (default = 1)
%
%   - 'newfig' : if = 1, plot in a new figure. 
%                           (default = 1)
%
%   - 'freqband': frequency range (start and end) for SWA computation, in Hz
%                           (default = [0.5 4])
%       
%   - 'windowsize' : windowsize for mean SWA computation, in seconds
%                           (default = 60), no overlap
%
%   - 'starttime' : start time, in 1e-4 sec
%                           (default 0)
%
%   - 'endtime' : end time, in 1e-4 sec
%                           (default = last event timestamp)
%
%   - 'artefact_thresh' : value (in % of NREM SWA) above which data points
%   are considered as artefacts and therefore removed from analysis. Or
%   'none' to keep all data points.
%                           (default = 'none')
%
%   - 'merge_closewake' : max duration (in minutes) between two wake
%   episodes to be merged for detection of separate sleep episodes in
%   multiple fits
%                           (default = 1)
%
%   - 'fit_start' : start time (ts unit) for the fits (fits only after
%   fit_start time)
%                           (default = 0, ie. fits on whole recording)
%
%
% ----------------- OUTPUTS ----------------- :
%
% - t_swa           = timestamps of SWA (middle time of each timewindow),
%                     in ZT time
% - y_swa           = values of SWA (averaged value for each timewindow)
% - Homeo_res       = structure with homeostasis data 
%
%
% ----------------- Example ----------------- :
%
% [t_swa, y_swa, Homeo_res] = GetSWAchannel_LP(ChannelSup,'multifit_thresh',20,'merge_closewake',1,'epoch',SWS,'plot',1) ;
 

function [t_swa, y_swa, Homeo_res] = GetSWAchannel_LP(channel, varargin)



% ---------------------------------- Check optional parameters ----------------------------------- :

 

    if nargin < 1 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list
    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (lower(varargin{i}))
            case 'multifit_thresh'
                multifit_thresh = varargin{i+1};
                if multifit_thresh ~= 'none'
                    if multifit_thresh <=0
                        error('Incorrect value for property "multifit_thresh".');
                    end    
                end
            case 'twofit_duration'
                twofit_duration = varargin{i+1};
                if twofit_duration ~= 'none'
                    if twofit_duration <=0
                        error('Incorrect value for property "twofit_duration".');
                    end    
                end    
            case 'plot'
                SWAplot = varargin{i+1};     
            case 'newfig'
                newfig = varargin{i+1}; 
            case 'merge_closewake'
                merge_closewake = varargin{i+1};    
            case 'freqband'
                freqband = varargin{i+1};   
            case 'windowsize'
                windowsize = varargin{i+1};
                if windowsize<=0
                    error('Incorrect value for property ''windowsize''.');
                end
            case 'epoch'
                epoch = varargin{i+1};      
            case 'starttime'
                starttime = varargin{i+1};
                if starttime<0
                    error('Incorrect value for property ''starttime''.');
                end
            case 'endtime'
                endtime = varargin{i+1};
                if endtime<=0
                    error('Incorrect value for property ''endtime''.');
                end
            case 'artefact_thresh'
                artefact_thresh = varargin{i+1}; 
            case 'fit_start'
                fit_start = varargin{i+1};     
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    %check if exist and assign default value if not
    if ~exist('multifit_thresh','var')
        multifit_thresh = 'none';
    end
    
    if ~exist('twofit_duration','var')
        twofit_duration = 'none';
    end
    
    if ~exist('SWAplot','var')
        SWAplot = 1;
    end
    
    if ~exist('newfig','var')
        if SWAplot
            newfig = 1;
        else
            newfig = 0;
        end    
    end
  
    if ~exist('freqband','var')
        freqband = [0.5 4]; %Hz
    end

    if ~exist('windowsize','var')
        windowsize = 60; %60s
    end

    if ~exist('artefact_thresh','var')
        artefact_thresh = 'none' ; 
    end

    if ~exist('merge_closewake','var')
        merge_closewake = 1 ; 
    end
    
    if ~exist('fit_start','var')
        fit_start = 0 ; % 1st time in quantif_tsd, in ts unit
    end

% ---------------------------------- Load Data ----------------------------------- :

 
    % Load Spectrum
    [Sp,t,f] = LoadSpectrumML(channel,pwd,'lowkb');

    % Zeitgeber time
    load('behavResources.mat', 'NewtsdZT')
 
    % Sliding window   
    
    if ~exist('starttime','var')
        starttime = 0;
    end
    if ~exist('endtime','var')
        endtime = t(end)*1e4;
    end

    window_starts = starttime:(windowsize*1E4):(endtime-windowsize*1E4) ; % starts of timewindows, in 1e-4 seconds, no overlap
    if isempty(window_starts)
        error('No time window to compute homeostasis. Check windowsize or starttime/endtime.')
    end    
    all_timewindows = intervalSet(window_starts, window_starts+windowsize*1E4) ; % timewindows to compute mean SWA


% ---------------------------------- Get SWA ----------------------------------- :
    
    % Restrict timewindows to epoch :
    if ~exist('epoch','var')
        epoch = intervalSet(starttime,endtime);
    end
    epoch_timewindows = intersect(all_timewindows,epoch) ;
    epoch_timewindows = dropShortIntervals(epoch_timewindows,3e4) ; % drop intervals shorter than 3s
           
                    % To check length of timewindows :  figure, histogram(Data(length(epoch_timewindows))/(1e4),20)
           
   
    % mean bandpower for each timewindow :
    bandpow = mean(Sp(:,(f>freqband(1) & f<freqband(2))),2); % bandpower for frequency range
    bandpow_tsd = tsd(t*1E4,bandpow);
    mean_bandpow = intervalMean_LP(bandpow_tsd,epoch_timewindows,'union',0,'timestamps','middle'); % mean SWA in each timewindow 
            
    % Get timewindows out of Epoch and assign 'NaN' value : 
    session = intervalSet(starttime,endtime); % whole session
    outofepoch = diff(session,epoch_timewindows);
    
        % If out of epoch is not empty : 
        if mean(length(outofepoch)) ~= 0 
            outofepoch_timewindows = intersect(all_timewindows,outofepoch) ; %timewindows out of epoch
            outofepoch_timewindows_middle = Start(outofepoch_timewindows) + Data(length(outofepoch_timewindows))/2 ;
            outofepoch_tsd = tsd(outofepoch_timewindows_middle,repmat(NaN,[length(Start(outofepoch_timewindows)),1])); % NaN for each timewindow out of epoch
            % Concatenate epoch and out of epoch data : 
            swa_tsd = concat_tsd(mean_bandpow,outofepoch_tsd) ; 
    
        else
            disp('Warning : out of epoch is empty.') 
            swa_tsd = mean_bandpow ;
        end


    % Get SWA :
    t_swa = Range(swa_tsd)/3600E4 + min(Data(NewtsdZT))/3600E4 ; % Zeitgeber time (in hours) for SWA
    y_swa = Data(swa_tsd); 
    y_swa = y_swa/nanmean(y_swa)*100 ; % Normalize SWA to the mean bandpower over entire epoch
    
    % Get rid of aberrant values (> artefact_thresh %) :
    if  artefact_thresh ~= 'none' 
        artefacts = (y_swa>artefact_thresh) ; 
        t_swa = t_swa(~artefacts) ; y_swa = y_swa(~artefacts) ; 
    end
    
    swa_tsd = tsd((t_swa*3600e4)-min(Data(NewtsdZT)),y_swa) ; 
   

% ---------------------------------- Get Homeostasis info ----------------------------------- :


    % Global Fit only
    if multifit_thresh == 'none' 
        if twofit_duration == 'none'
            GlobalFit = Homeostasis1Fit_LP(swa_tsd,'plot',SWAplot,'newfig', newfig,'ZTtime',NewtsdZT) ; % Get homeostasis data (and plot) for one linear fit
            Homeo_res.GlobalFit = GlobalFit ;
        else 
            [GlobalFit, TwoFit] = Homeostasis2Fit_LP(swa_tsd,'plot',SWAplot,'newfig',newfig,'ZTtime',NewtsdZT,'fit_start',fit_start,'firstfit_duration',twofit_duration) ; % Get homeostasis data (and plot) for two linear fits
            Homeo_res.GlobalFit = GlobalFit ;
            Homeo_res.TwoFit = TwoFit ;
        end    
    
    % Global Fit & Multiple Fits    
    else    
        load('SleepSubstages.mat'), WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ; % load wake substage
        
        % Remove short sleep episodes in the middle of wake episodes for detection ?
        WAKE = mergeCloseIntervals(WAKE,merge_closewake*60e4) ; % merge wake episodes closer than 'merge_closewake' min (ie. wake interrupted by <2min-long sleep episodes) 
        
        [GlobalFit, MultiFit] = HomeostasisMultiFit_LP(swa_tsd,WAKE,multifit_thresh,'plot',SWAplot,'newfig', newfig,'ZTtime',NewtsdZT,'fit_start',fit_start) ; % Get homeostasis data (and plot) for multiple fits
        Homeo_res.GlobalFit = GlobalFit ;
        Homeo_res.MultiFit = MultiFit ;        
    end       
    
    if SWAplot
        title('Slow Wave Activity') ; xlabel('ZT Time (hours)') ; ylabel('SWA (% of NREM average)') ;  
    end
    
end


