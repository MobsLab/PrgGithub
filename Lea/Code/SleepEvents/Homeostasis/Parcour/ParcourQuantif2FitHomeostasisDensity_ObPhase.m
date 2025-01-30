

%% ParcourQuantif2FitHomeostasisDensity_ObPhase
%
% 09/06/2020 LP
%
% Store homeostasis info of each session in a structure. 
% "Homeostasis" computed here through linear regression of local maxima 
% on event density, for all (8) types of 2-channel detected slow waves,
% for down states and differential delta waves.  Separately for slow waves
% depending on their phase in olfactory bulb.
% 
% -> global fit and 2 fits (first 3 hours vs. rest of the session) 
%
% SEE : 
% ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes


% ----------------------------------------- ACCESS DATA ----------------------------------------- :
clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
%Dir = PathForExperimentsSlowWavesLP ;

% --------------------------------------- SET PARAMETERS --------------------------------------- :


windowsize = 60 ; % duration of sliding window, in seconds
afterREM1 = false ; % true if fit only after 1st episode of REM
firstfit_duration = 3 ; % in hours


%% GET DENSITY HOMEOSTASIS FOR ALL SESSIONS


for p=1:length(Dir.path)
    
    clearvars -except Dir p  windowsize afterREM1 firstfit_duration Homeo_res_all Homeo_res_inphase Homeo_res_outphase

    
    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
    % Store Session Info :
    Homeo_res_all.path{p}   = Dir.path{p};
    Homeo_res_all.manipe{p} = Dir.manipe{p};
    Homeo_res_all.name{p}   = Dir.name{p};
    
    Homeo_res_inphase.path{p}   = Dir.path{p};
    Homeo_res_inphase.manipe{p} = Dir.manipe{p};
    Homeo_res_inphase.name{p}   = Dir.name{p};
    
    Homeo_res_outphase.path{p}   = Dir.path{p};
    Homeo_res_outphase.manipe{p} = Dir.manipe{p};
    Homeo_res_outphase.name{p}   = Dir.name{p};


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
    

    % 2-Channel Slow Waves, in phase or out of phase with OB : 
    load('SlowWaves2Channels_ObPhase_LP.mat')
        % Data : 
    all_slowwaves = {slowwave_type1.allpeaktimes,slowwave_type2.allpeaktimes,slowwave_type3.allpeaktimes,slowwave_type4.allpeaktimes,slowwave_type5.allpeaktimes,slowwave_type6.allpeaktimes,slowwave_type7.allpeaktimes,slowwave_type8.allpeaktimes} ;
    all_inphase_slowwaves = {slowwave_type1.inphasepeaktimes,slowwave_type2.inphasepeaktimes,slowwave_type3.inphasepeaktimes,slowwave_type4.inphasepeaktimes,slowwave_type5.inphasepeaktimes,slowwave_type6.inphasepeaktimes,slowwave_type7.inphasepeaktimes,slowwave_type8.inphasepeaktimes} ;
    all_outphase_slowwaves = {slowwave_type1.outphasepeaktimes,slowwave_type2.outphasepeaktimes,slowwave_type3.outphasepeaktimes,slowwave_type4.outphasepeaktimes,slowwave_type5.outphasepeaktimes,slowwave_type6.outphasepeaktimes,slowwave_type7.outphasepeaktimes,slowwave_type8.outphasepeaktimes} ;
    events_names = {'SlowWaves1', 'SlowWaves2', 'SlowWaves3', 'SlowWaves4', 'SlowWaves5', 'SlowWaves6', 'SlowWaves7', 'SlowWaves8'} ;

    

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
        end   
        
        
        
    % ------------------------------------------ Get Homeostasis Data ------------------------------------------ :
    
    allphase_events = {all_slowwaves, all_inphase_slowwaves, all_outphase_slowwaves} ;
    allphase_names = {'all','inphase','outphase'} ;
        
    % ONE HOMEO_RES structure FOR EACH GROUP of slow waves : 
    
    for ph=1:length(allphase_events)
        
        events = allphase_events{ph} ;
        
        % For each slow wave type : 
        for q = 1:length(events) 
            
            event_ts = events{q} ; 
            if isempty(Range(event_ts))
                continue % go to next events if 0 event 
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

        % ------ Extract Homeostasis Data ------ :
            [GlobalFit, TwoFit] = Homeostasis2Fit_LP(evt_density,'plot',0,'newfig',0,'ZTtime',NewtsdZT,'fit_start',fit_start,'firstfit_duration',firstfit_duration) ; % Get homeostasis data (and plot) for multiple fits


            % => Store all data in structure :
         
             % Global Fit :
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.time{p} = GlobalFit.time ;']) % timestamps of quantif
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.data{p} = GlobalFit.data;']) % data of quantif
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.idx_localmax{p} = GlobalFit.idx_localmax;']) % indices of local maxima
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.reg_coeff{p} = GlobalFit.reg_coeff;']) % Linear Reg Coefficient
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.R2{p} = GlobalFit.R2;']) % Determination Coeff

            % Multiple Fits : 
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.twofitidx_localmax{p} = TwoFit.idx_localmax;']) % indices of local maxima for each (non-global) fit
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.twofitreg_coeff{p} = TwoFit.reg_coeff;']) % Linear Reg Coefficient for each (non-global) fit
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.twofitR2{p} = TwoFit.R2;']) % Determination Coeff for each (non-global) fit 

        
            
            % ------ Extract LFP and Co-coccurrence data ------ :
    
            % Extract start times of events happening during "epoch" :
            all_events_t = Range(event_ts) ; 
            epoch_events_t = all_events_t(logical(belong(epoch,all_events_t))) ;

            [mdeep,sdeep,tdeep]=mETAverage(epoch_events_t,Range(LFPdeep),Data(LFPdeep),1,1000);
            [msup,ssup,tsup]=mETAverage(epoch_events_t,Range(LFPsup),Data(LFPsup),1,1000);
            [mOB,sOB,tOB]=mETAverage(epoch_events_t,Range(LFPOBdeep),Data(LFPOBdeep),1,1000);

            [co_evt, co_down] = EventsInIntervals_LP(ts(epoch_events_t), alldown_PFCx,'prop',1) ; % proportion of events which peak falls in a down state interval
            [co_evt2, co_delta] = EventsInIntervals_LP(ts(epoch_events_t), alldeltas_PFCx,'prop',1) ; % proportion of events which peak falls in a down state interval
            [co,cot] = EventsCooccurrence(ts(epoch_events_t),diffdelta_ts,[250 250]) ; 

            % => Store all data in structure :        
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.DownCooccurProp{p}=co_evt;']) % Proportion of co-occurrence with down states
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.DeltaCooccurProp{p}=co_evt2;']) % Proportion of co-occurrence with delta waves
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.NextToDeltaProp{p}=sum(co)/length(co)*100;']) % Proportion of slow waves with peak < 250ms from mid-delta
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.nb_events{p}=length(epoch_events_t);']) % number of events
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.meanLFPdeep{p}=mdeep;']) % mean deepPFCx LFP around events
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.meanLFPsup{p}=msup;']) % mean supPFCx LFP around events
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.meanLFPOB{p}=mOB;']) % mean deep OB LFP around events
            eval(['Homeo_res_' allphase_names{ph} '.' events_names{q} '.LFPt{p}=tsup;']) % time for mean LFP
            
        end
    end      
end



% SAVE .MAT FILE with results : 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/'])
end

description  = [] ; 
if afterREM1
    description = [description '_afterREM1'] ; 
end

eval ([' save ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_ObPhase_first' num2str(firstfit_duration) 'h_' description '.mat Homeo_res_all Homeo_res_inphase Homeo_res_outphase windowsize firstfit_duration afterREM1']) ;





