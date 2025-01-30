
%% ParcourDeltaCooccur_AllSlowWaveTypes
% 
% 29/05/2020  LP
%
% Script to get delta waves co-occurrence for all slow wave types, all sessions. 
% -> Cooccurrence Detection = when slow wave peak falls in delta wave interval ! 
% -> store structures in a .mat file.


clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourDeltaCooccur_AllSlowWaveTypes.mat' ; 


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
    load('DeltaWaves.mat','alldeltas_PFCx')


    % LOAD SUBSTAGES : 
    load('SleepSubstages.mat') ; 
        REM = Epoch{strcmpi(NameEpoch,'REM')} ;
        WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
        SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;
        
        
    % ------------------------------------------ Get Co-occurrence for all slow wave types ------------------------------------------ :
 
    tosave = {} ; % to store names of the structures to save
    
    % For each slow wave type : 
    
    for type = 1:length(all_slowwaves) 

        sw_ts = all_slowwaves{type} ; 

        % --- WHOLE SESSION --- : 

        % Proportion of slow waves co-occurring with delta states :
        sw_codelta_ts = Restrict(sw_ts,alldeltas_PFCx) ; 
        sw_codelta_prop = length(Range(sw_codelta_ts))/length(Range(sw_ts)) * 100 ; 
        % Proportion of delta states wich cooccur with these slow waves : 
        delta_cosw_tsd = intervalCount(sw_ts,alldeltas_PFCx);
        delta_cosw_prop = sum(Data(delta_cosw_tsd)>0) / length(Range(delta_cosw_tsd)) * 100 ; 

        % Store Results in a Structure : 
        eval(['SlowWaves' num2str(type) '.allsw_codelta_prop{p}= sw_codelta_prop ;']) ; % proportion of slow waves (of this type) co-occurring with a delta state
        eval(['SlowWaves' num2str(type) '.alldelta_cosw_prop{p}= delta_cosw_prop ;']) ; % proportion of delta waves co-occurring with a slow wave (of this type)

        % --- NREM ONLY --- :   

        NREM_sw_ts = Restrict(sw_ts,SWS) ;
        NREM_delta = intersect(alldeltas_PFCx,SWS) ;
        % Proportion of slow waves co-occurring with delta states :
        sw_codelta_ts = Restrict(NREM_sw_ts,NREM_delta) ; 
        sw_codelta_prop = length(Range(sw_codelta_ts))/length(Range(NREM_sw_ts)) * 100 ; 
        % Proportion of delta states wich cooccur with these slow waves : 
        delta_cosw_tsd = intervalCount(NREM_sw_ts,NREM_delta);
        delta_cosw_prop = sum(Data(delta_cosw_tsd)>0) / length(Range(delta_cosw_tsd)) * 100 ; 
        
        % Store Results in a Structure : 
        eval(['SlowWaves' num2str(type) '.NREMsw_codelta_prop{p}= sw_codelta_prop ;']) ; % proportion of slow waves (of this type) co-occurring with a delta state
        eval(['SlowWaves' num2str(type) '.NREMdelta_cosw_prop{p}= delta_cosw_prop ;']) ; % proportion of delta states co-occurring with a slow wave (of this type)
   
        
        tosave{end+1} = ['SlowWaves' num2str(type)] ; % to store names of all structures
        
    end
end

% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

struct_names = tosave ;
save(FileToSave,'detection_parameters','Info_res',tosave{:},'struct_names') ; 

