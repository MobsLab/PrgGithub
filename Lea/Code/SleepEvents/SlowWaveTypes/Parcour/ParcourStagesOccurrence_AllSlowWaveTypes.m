%% ParcourStagesOccurrence_AllSlowWaveTypes
% 
% 27/05/2020  LP
%
% Script to get stage occurence + associated LFP profiles and down states crosscorr/co-occurrence, 
% for all slow wave types.
% -> for all sessions, stored in structures. 
% -> 1 structure per slow wave type (8 types in total)
%
%
% 11 Output Structures :
%   - Info_res, SlowWaves1, SlowWaves2, ..., SlowWaves8, DownStates, DiffDelta, saved in FileToSave


clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourStagesOccurrence_AllSlowWaveTypes.mat' ; 
cooccur_delay = 300 ; % for down state cooccurrence, in ms


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
    Info_res.down_cooccur_delay{p} = cooccur_delay ; 
    
    
    % ------------------------------------------ Load Data ------------------------------------------ :
    
    
    % LOAD EVENTS :
    load('SlowWaves2Channels_LP.mat')
    load('DownState.mat','alldown_PFCx')
    downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
    load('DeltaWaves.mat','alldeltas_PFCx')
    diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)

    all_events_list = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes, diffdelta_ts, downstates_ts} ; 
    all_events_names_list = {'SlowWaves1','SlowWaves2','SlowWaves3','SlowWaves4','SlowWaves5','SlowWaves6','SlowWaves7','SlowWaves8','DiffDelta','DownStates'} ;
    
    % LOAD SUBSTAGES : 
    load('SleepSubstages.mat') ; 
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
    SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;
    substages_list = {WAKE,SWS,REM} ; 
    substages_names = {'Wake', 'NREM', 'REM'} ;

    % LOAD LFP : 
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
    LFPob = LFP;
    ChannelOb = channel ;
    clear LFP channel
    
    
    
    %% For each SLOW WAVE TYPE : 

    for type = 1:length(all_events_list) % for each slow wave type
    
        events_ts = all_events_list{type} ; 
        all_events_times = Range(events_ts) ;
        
        for k = 1:length(substages_list)
            
            stage_events = belong(substages_list{k},all_events_times) ; % logical array of SW in stage nº'k'
            stage_prop = sum(stage_events) / length(stage_events) *100 ; % proportion of all SW in this stage
            
            % Get mean LFP around events : 
            nb_events = sum(stage_events) ; 
            stage_events_times = all_events_times(stage_events) ; % times of SW in stage nº'k'
            [mdeep,s,t]=mETAverage(stage_events_times,Range(LFPdeep),Data(LFPdeep),1,1000);
            [msup,s,t]=mETAverage(stage_events_times,Range(LFPsup),Data(LFPsup),1,1000);
            [mob,s,t]=mETAverage(stage_events_times,Range(LFPob),Data(LFPob),1,1000);
             
            % Get cross-corr and co-occurrence proportion with Down States :
            [C,B]=CrossCorr(stage_events_times,Range(downstates_ts),10,100); 
            [co, cot] = EventsCooccurrence(ts(stage_events_times),downstates_ts, [cooccur_delay cooccur_delay]) ; 
            prop_co_down = sum(co)/length(co) ; % proportion of slow waves of this type and stage which co-occur with down states
            
            % Store results in a structure : 
            eval([all_events_names_list{type} '.' substages_names{k} '.nb_events{p} = nb_events ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.stage_prop{p} = stage_prop ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.LFPdeep{p} = mdeep ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.LFPsup{p} = msup ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.LFPob{p} = mob ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.LFP_t{p} = t ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.DownCrossCorr{p} = C ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.DownCrossCorr_t{p} = B ; ']);
            eval([all_events_names_list{type} '.' substages_names{k} '.DownCooccurProp{p} = prop_co_down ; ']);
            
        end  
        
        % Get co-occurrence proportion with Down States for all SW of this type :
        [co, cot] = EventsCooccurrence(ts(all_events_times),downstates_ts, [cooccur_delay cooccur_delay]) ; % proportion of down state co-occurrence for all stages
        prop_co_down = sum(co)/length(co) ;
        eval([all_events_names_list{type} '.all.DownCooccurProp{p} = prop_co_down ; ']);
        
    end
end


% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

save(FileToSave,'detection_parameters','Info_res','SlowWaves1','SlowWaves2','SlowWaves3','SlowWaves4','SlowWaves5','SlowWaves6','SlowWaves7','SlowWaves8','DiffDelta','DownStates') ; 


