
%% ParcourNextToDown_AllSlowWaveTypes
% 
% 06/06/2020  LP
%
% Script to get proportion of slow waves next to a down state,  for all slow wave types. 
% -> choose cooccur_delay1 & cooccur_delay2 
% -> for one session



clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourNextToDown_AllSlowWaveTypes.mat' ; 
    
cooccur_delay1 = 100 ; % in ms
cooccur_delay2 = 300 ; % in ms


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])

    disp(pwd)
    
    
    % Store Session Info :
    Info_res.path{p}   = Dir.path{p};
    Info_res.manipe{p} = Dir.manipe{p};
    Info_res.name{p}   = Dir.name{p};
    
    
    % ------------------------------------------ Load Data ------------------------------------------ :

    % LOAD EVENTS : 
    load('SlowWaves2Channels_LP.mat')
    all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    load('DownState.mat','alldown_PFCx')
    load('DeltaWaves.mat','alldeltas_PFCx')
        downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
        diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)


    % SUBSTAGES :
        % Clean SWS Epoch
        load('SleepSubstages.mat')
        SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
        load NoiseHomeostasisLP TotalNoiseEpoch % noise
        cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
        % REM & Wake Epochs
        REM = Epoch{strcmpi(NameEpoch,'REM')} ;
        WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
    epoch = cleanSWS ;


        
        
    % ------------------------------------------ Get Co-occurrence for all slow wave types ------------------------------------------ :
 
    tosave = {} ; % to store names of the structures to save
    
    % For each slow wave type : 
    
    for type = 1:length(all_slowwaves) 

        sw_ts = all_slowwaves{type} ; 


        % --- NREM ONLY --- :   
        
        NREM_sw_ts = Restrict(sw_ts,cleanSWS) ;

        % Proportion of slow waves co-occurring with down states :
    
        [co1, cot1] = EventsCooccurrence(NREM_sw_ts,downstates_ts, [cooccur_delay1 cooccur_delay1]) ;
        nb_events = length(co1) ;
        DownCooccurProp1 = sum(co1)/length(co1) *100 ;
        
        [co2, cot2] = EventsCooccurrence(NREM_sw_ts,downstates_ts, [cooccur_delay2 cooccur_delay2]) ;
        DownCooccurProp2 = sum(co2)/length(co2) *100 ;

        
        % Store Results in a Structure : 
        eval(['SlowWaves' num2str(type) '.DownCooccurProp1{p}= DownCooccurProp1 ;']) ; % proportion of slow waves (of this type) co-occurring with a down state
        eval(['SlowWaves' num2str(type) '.DownCooccurProp2{p}= DownCooccurProp2 ;']) ; % proportion of down states co-occurring with a slow wave (of this type)
        eval(['SlowWaves' num2str(type) '.cooccur_delay1{p}= cooccur_delay1 ;']) ; % proportion of down states co-occurring with a slow wave (of this type)
        eval(['SlowWaves' num2str(type) '.cooccur_delay2{p}= cooccur_delay2 ;']) ; % proportion of down states co-occurring with a slow wave (of this type)
       
        tosave{end+1} = ['SlowWaves' num2str(type)] ; % to store names of all structures
        
    end
end

% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

struct_names = tosave ;
save(FileToSave,'detection_parameters','Info_res',tosave{:},'struct_names') ; 

