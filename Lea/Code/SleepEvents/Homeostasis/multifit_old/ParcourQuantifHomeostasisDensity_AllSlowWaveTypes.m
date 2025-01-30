%% ParcourQuantifHomeostasisDensity_AllSlowWaveTypes
%
% 20/05/2020 LP
%
% Store homeostasis info of each session in a structure. 
% "Homeostasis" computed here through linear regression of local maxima 
% on event density, for all (8) types of 2-channel detected slow waves,
% for down states and differential delta waves.  
% 
% -> Global fit on whole session or multiple fits on separate sleep episodes 
% (when wake duration > wake_thresh) 
%
% SEE : 
% ParcourQuantifHomeostasisDensity
% QuantifHomeostasisDensity_AllSlowWaveTypes 
% ParcourQuantifHomeostasisDensityPlot_AllSlowWaveTypes


% ----------------------------------------- ACCESS DATA ----------------------------------------- :
clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
%Dir = PathForExperimentsSlowWavesLP ;

% --------------------------------------- SET PARAMETERS --------------------------------------- :

wake_thresh = 20 ; % wake duration (in minutes) between separate sleep episodes
merge_closewake = 1 ;% minimal sleep duration (in minutes) to consider a wake period as "interrupted", for multiple fits 
% (ie. do not take into account sleep when shorther than this duration for the detection of wake episodes) 
windowsize = 60 ; % duration of sliding window, in seconds
afterREM1 = false ; % true if fit only after 1st episode of REM
cooccur_delay1 = 100 ; % half timewindow around start of down states for detection of co-occurrence (in ms) 
cooccur_delay2 = 300 ; % half timewindow around start of down states for detection of co-occurrence (in ms) 


%% GET DENSITY HOMEOSTASIS FOR ALL SESSIONS


for p=1:length(Dir.path)
    
    clearvars -except Dir p Homeo_res  windowsize wake_thresh merge_closewake afterREM1 cooccur_delay1 cooccur_delay2

    
    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
    % Store Session Info :
    Homeo_res.path{p}   = Dir.path{p};
    Homeo_res.manipe{p} = Dir.manipe{p};
    Homeo_res.name{p}   = Dir.name{p};
    

% ------------------------------------------ Load Data ------------------------------------------ :
    
    % LFP :

    load('ChannelsToAnalyse/PFCx_deep')
    load(['LFPData/LFP',num2str(channel)])
    LFPdeep = LFP;
    ChannelDeep = channel ;

    load('ChannelsToAnalyse/PFCx_sup')
    load(['LFPData/LFP',num2str(channel)])
    LFPsup = LFP;
    ChannelSup = channel ;

    load('ChannelsToAnalyse/Bulb_deep')
    load(['LFPData/LFP',num2str(channel)])
    LFPOBdeep = LFP;
    ChannelOBdeep = channel ;
    clear LFP channel


      % EVENTS
    
    load("DownState.mat", 'alldown_PFCx')
    load("DeltaWaves.mat", 'alldeltas_PFCx')
    downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
    diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)
    

    % 2-Channel Slow Waves : 
    load('SlowWaves2Channels_LP.mat')
        % Data : 
    all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;

    


    % SUBSTAGES :
    % Clean SWS Epoch
    load('SleepSubstages.mat')
    SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
    load NoiseHomeostasisLP TotalNoiseEpoch % noise
    cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
    % REM & Wake Epochs
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
    % Zeitgeber time
    load('behavResources.mat', 'NewtsdZT')


% ------------------------------------------ Sliding timeWindows (no overlap) ------------------------------------------ :


    t = Range(LFPdeep)/(1E4) ;
    window_starts = t(1):windowsize:(t(end)-windowsize) ;
    all_timewindows = intervalSet(window_starts*1E4, (window_starts+windowsize)*1E4) ;

        % Restrict timewindows to SWS :
        epoch = cleanSWS ;
        epoch_timewindows = intersect(all_timewindows,epoch) ;
        epoch_timewindows = dropShortIntervals(epoch_timewindows,3e4) ; % drop intervals shorter than 3s

                        % To check length of timewindows :  figure, histogram(Data(length(epoch_timewindows))/(1e4),20)

        % Remove short sleep episodes in the middle of wake episodes for episodes detection (in multifit) :
        extendedWAKE = mergeCloseIntervals(WAKE,merge_closewake*60e4) ; % merge wake episodes closer than 'merge_closewake' min (ie. wake interrupted by <2min-long sleep episodes) 

        % Get starting time for fits :
        if afterREM1 
            fit_start = getfield(Start(REM),{1}) ; 
        else
            fit_start = 0 ;
        end


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
            swa_tsd = mean_bandpow ;
        end   
     
        
% ------------------------------------------ Get Homeostasis Data ------------------------------------------ :


    % -------------- All Events -------------- : 

    events = horzcat({diffdelta_ts,downstates_ts},all_slowwaves) ; % as ts events
    events_names = {'DiffDeltaWaves', 'DownStates', 'SlowWaves1', 'SlowWaves2', 'SlowWaves3', 'SlowWaves4', 'SlowWaves5', 'SlowWaves6', 'SlowWaves7', 'SlowWaves8'} ;

    
    
    
% FOR EACH TYPE OF EVENTS : 


    for q = 1:length(events) 

    % ------ Get Event Density during Epoch ------ :
        evt_density = EventsDensity_LP(events{q},epoch_timewindows, 'union', 0) ;
        % normalize event_density by mean density on entire epoch
        mean_evt_density = EventsDensity_LP(events{q},epoch_timewindows, 'union', 1) ;
        evt_density = tsd(Range(evt_density),Data(evt_density)/mean_evt_density*100) ; % expressed as a percentage of mean event density during whole epoch (SWS)

    % ------ Assign 'NaN' value out of Epoch ------ : 

        % If out of epoch is not empty : 
        if mean(length(outofepoch)) ~= 0 
            % Concatenate epoch data with out of epoch NaNs : 
            evt_density = concat_tsd(evt_density,outofepoch_tsd) ; 
        end
    
    % ------ Extract Homeostasis Data ------ :
        [GlobalFit, MultiFit] = HomeostasisMultiFit_LP(evt_density,extendedWAKE,wake_thresh,'plot',0,'newfig',0,'ZTtime',NewtsdZT,'fit_start',fit_start) ; % Get homeostasis data (and plot) for multiple fits
   

         % => Store all data in structure :
         
         % Global Fit :
        eval(['Homeo_res.' events_names{q} '.time{p} = GlobalFit.time ;']) % timestamps of quantif
        eval(['Homeo_res.' events_names{q} '.data{p} = GlobalFit.data;']) % data of quantif
        eval(['Homeo_res.' events_names{q} '.idx_localmax{p} = GlobalFit.idx_localmax;']) % indices of local maxima
        eval(['Homeo_res.' events_names{q} '.reg_coeff{p} = GlobalFit.reg_coeff;']) % Linear Reg Coefficient
        eval(['Homeo_res.' events_names{q} '.R2{p} = GlobalFit.R2;']) % Determination Coeff

        % Multiple Fits : 
        eval(['Homeo_res.' events_names{q} '.multiidx_localmax{p} = MultiFit.idx_localmax;']) % indices of local maxima for each (non-global) fit
        eval(['Homeo_res.' events_names{q} '.multireg_coeff{p} = MultiFit.reg_coeff;']) % Linear Reg Coefficient for each (non-global) fit
        eval(['Homeo_res.' events_names{q} '.multiR2{p} = MultiFit.R2;']) % Determination Coeff for each (non-global) fit 
        eval(['Homeo_res.' events_names{q} '.multiR2global{p} = MultiFit.R2global;']) % Determination Coeff for global fit restricted on each sleep episode   

        

    % ------ Extract LFP and Co-coccurrence data ------ :
    
        % Extract start times of events happening during "epoch" :
        all_events_t = Range(events{q}) ; 
        epoch_events_t = all_events_t(logical(belong(epoch,all_events_t))) ;
    
        [mdeep,sdeep,tdeep]=mETAverage(epoch_events_t,Range(LFPdeep),Data(LFPdeep),1,1000);
        [msup,ssup,tsup]=mETAverage(epoch_events_t,Range(LFPsup),Data(LFPsup),1,1000);
        [mOB,sOB,tOB]=mETAverage(epoch_events_t,Range(LFPOBdeep),Data(LFPOBdeep),1,1000);

        [co1, cot1] = EventsCooccurrence(ts(epoch_events_t),downstates_ts, [cooccur_delay1 cooccur_delay1]) ;
        nb_events = length(co1) ;
        DownCooccurProp1 = sum(co1)/length(co1) ;
        
        [co2, cot2] = EventsCooccurrence(ts(epoch_events_t),downstates_ts, [cooccur_delay2 cooccur_delay2]) ;
        DownCooccurProp2 = sum(co2)/length(co2) ;

        % => Store all data in structure :        
        eval(['Homeo_res.' events_names{q} '.DownCooccurProp1{p}=DownCooccurProp1;']) % Proportion of co-occurrence with down states
        eval(['Homeo_res.' events_names{q} '.DownCooccurProp2{p}=DownCooccurProp2;']) % Proportion of co-occurrence with down states
        eval(['Homeo_res.' events_names{q} '.nb_events{p}=nb_events;']) % number of events
        eval(['Homeo_res.' events_names{q} '.meanLFPdeep{p}=mdeep;']) % mean deepPFCx LFP around events
        eval(['Homeo_res.' events_names{q} '.meanLFPsup{p}=msup;']) % mean supPFCx LFP around events
        eval(['Homeo_res.' events_names{q} '.meanLFPOB{p}=mOB;']) % mean deep OB LFP around events
        eval(['Homeo_res.' events_names{q} '.LFPt{p}=tsup;']) % time for mean LFP
        
        
    end

    
end


try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/'])
end

if afterREM1
    eval ([' save ParcourQuantifHomeostasisDensity_AllSlowWaveTypes_multifit' num2str(wake_thresh) '_afterREM1.mat Homeo_res windowsize cooccur_delay1 cooccur_delay2 merge_closewake wake_thresh afterREM1']) ;
else
    eval ([' save ParcourQuantifHomeostasisDensity_AllSlowWaveTypes_multifit' num2str(wake_thresh) '.mat Homeo_res windowsize cooccur_delay1 cooccur_delay2 merge_closewake wake_thresh afterREM1']) ;
end