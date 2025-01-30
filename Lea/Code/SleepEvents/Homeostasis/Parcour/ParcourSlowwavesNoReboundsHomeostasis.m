%% ParcourSlowwavesNoReboundsHomeostasis
%
% 08/06/2020
%
% Script to get info for LFP profile and event density homeostasis for slow waves
% 1/2/5 which do not occur close to SW 3/4/6 events



% ----------------------------------------- ACCESS DATA ----------------------------------------- :
clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
%Dir = PathForExperimentsSlowWavesLP ;

% --------------------------------------- SET PARAMETERS --------------------------------------- :

% Choose detection delay : 
detection_delay = 250 ; % in ms
windowsize = 60 ; % duration of sliding window, in seconds
firstfit_duration = 3 ; % in hours



%% GET DENSITY HOMEOSTASIS & LFP FOR ALL SESSIONS


for p=1:length(Dir.path)
    
    clearvars -except Dir p Homeo_res  windowsize afterREM1 firstfit_duration detection_delay

    
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
    all_sw = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type5.deep_peaktimes} ;
    all_sw_names = {'SW1','SW2','SW5'} ; 
    ref_sw = ts(sort([Range(slowwave_type3.deep_peaktimes)',Range(slowwave_type4.deep_peaktimes)',Range(slowwave_type6.deep_peaktimes)'])) ;
    ref_sw_names = {'SW3','SW4','SW6'} ; 

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


    
%% Keep SW 1/2/5 which are NOT rebounds of ref SW (3/4/6) : 

    norebound_prop = [] ; 

    for i=1:length(all_sw)
        [obs_ts_subset, subset_ix, prop] = GetCloseEvents_LP(all_sw{i},ref_sw,detection_delay,'epoch',cleanSWS,'keep_events',0) ;
        norebound_sw{i} = obs_ts_subset ; 
        norebound_prop(i) = prop ; 
    end 
    
    
    % Extract Homeostasis Info : 
    
    
    for i=1:length(norebound_sw)
        
        % For all events : 
        [GlobalFit, TwoFit] = HomeostasisEventDensity_LP(all_sw{i},'ZTtime',NewtsdZT,'windowsize',60, 'plot',0,'newfig',0,'epoch',cleanSWS) ;
        
            % => Store all data in structure :
                % Global Fit :
            eval(['Homeo_res.all' all_sw_names{i} '.time{p} = GlobalFit.time ;']) % timestamps of quantif
            eval(['Homeo_res.all' all_sw_names{i} '.data{p} = GlobalFit.data;']) % data of quantif
            eval(['Homeo_res.all' all_sw_names{i} '.idx_localmax{p} = GlobalFit.idx_localmax;']) % indices of local maxima
            eval(['Homeo_res.all' all_sw_names{i} '.reg_coeff{p} = GlobalFit.reg_coeff;']) % Linear Reg Coefficient
            eval(['Homeo_res.all' all_sw_names{i} '.R2{p} = GlobalFit.R2;']) % Determination Coeff
                % Multiple Fits : 
            eval(['Homeo_res.all' all_sw_names{i} '.twofitidx_localmax{p} = TwoFit.idx_localmax;']) % indices of local maxima for each (non-global) fit
            eval(['Homeo_res.all' all_sw_names{i} '.twofitreg_coeff{p} = TwoFit.reg_coeff;']) % Linear Reg Coefficient for each (non-global) fit
            eval(['Homeo_res.all' all_sw_names{i} '.twofitR2{p} = TwoFit.R2;']) % Determination Coeff for each (non-global) fit 

            
        % For events without rebounds : 
        [GlobalFit, TwoFit] = HomeostasisEventDensity_LP(norebound_sw{i},'ZTtime',NewtsdZT,'windowsize',60, 'plot',0,'newfig',0,'epoch',cleanSWS) ;
        
            % => Store all data in structure :
                % Global Fit :
            eval(['Homeo_res.norebound' all_sw_names{i} '.time{p} = GlobalFit.time ;']) % timestamps of quantif
            eval(['Homeo_res.norebound' all_sw_names{i} '.data{p} = GlobalFit.data;']) % data of quantif
            eval(['Homeo_res.norebound' all_sw_names{i} '.idx_localmax{p} = GlobalFit.idx_localmax;']) % indices of local maxima
            eval(['Homeo_res.norebound' all_sw_names{i} '.reg_coeff{p} = GlobalFit.reg_coeff;']) % Linear Reg Coefficient
            eval(['Homeo_res.norebound' all_sw_names{i} '.R2{p} = GlobalFit.R2;']) % Determination Coeff
                % Multiple Fits : 
            eval(['Homeo_res.norebound' all_sw_names{i} '.twofitidx_localmax{p} = TwoFit.idx_localmax;']) % indices of local maxima for each (non-global) fit
            eval(['Homeo_res.norebound' all_sw_names{i} '.twofitreg_coeff{p} = TwoFit.reg_coeff;']) % Linear Reg Coefficient for each (non-global) fit
            eval(['Homeo_res.norebound' all_sw_names{i} '.twofitR2{p} = TwoFit.R2;']) % Determination Coeff for each (non-global) fit 


        
    end
    
    
    
    % Extract LFP profiles : 
    
    
    for i=1:length(norebound_sw)
        
        % For all events : 
        epoch_events_t = Range(all_sw{i}) ; 

        [mdeep,sdeep,tdeep]=mETAverage(epoch_events_t,Range(LFPdeep),Data(LFPdeep),1,1000);
        [msup,ssup,tsup]=mETAverage(epoch_events_t,Range(LFPsup),Data(LFPsup),1,1000);
        [mOB,sOB,tOB]=mETAverage(epoch_events_t,Range(LFPOBdeep),Data(LFPOBdeep),1,1000);
        eval(['Homeo_res.all' all_sw_names{i} '.meanLFPdeep{p}=mdeep;']) % mean deepPFCx LFP around events
        eval(['Homeo_res.all' all_sw_names{i} '.meanLFPsup{p}=msup;']) % mean supPFCx LFP around events
        eval(['Homeo_res.all' all_sw_names{i} '.meanLFPOB{p}=mOB;']) % mean deep OB LFP around events
        eval(['Homeo_res.all' all_sw_names{i} '.LFPt{p}=tsup;']) % time for mean LFP

        % For events without rebounds : 
        epoch_events_t = Range(norebound_sw{i}) ; 

        [mdeep,sdeep,tdeep]=mETAverage(epoch_events_t,Range(LFPdeep),Data(LFPdeep),1,1000);
        [msup,ssup,tsup]=mETAverage(epoch_events_t,Range(LFPsup),Data(LFPsup),1,1000);
        [mOB,sOB,tOB]=mETAverage(epoch_events_t,Range(LFPOBdeep),Data(LFPOBdeep),1,1000);
        eval(['Homeo_res.norebound' all_sw_names{i} '.meanLFPdeep{p}=mdeep;']) % mean deepPFCx LFP around events
        eval(['Homeo_res.norebound' all_sw_names{i} '.meanLFPsup{p}=msup;']) % mean supPFCx LFP around events
        eval(['Homeo_res.norebound' all_sw_names{i} '.meanLFPOB{p}=mOB;']) % mean deep OB LFP around events
        eval(['Homeo_res.norebound' all_sw_names{i} '.LFPt{p}=tsup;']) % time for mean LFP

        
    end
   
    

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/'])
end


description  = [num2str(detection_delay)] ; 

eval ([' save ParcourSlowwavesNoRebounds'  description '.mat Homeo_res windowsize firstfit_duration detection_delay ref_sw_names']) ;



    
    
end
    
    
    