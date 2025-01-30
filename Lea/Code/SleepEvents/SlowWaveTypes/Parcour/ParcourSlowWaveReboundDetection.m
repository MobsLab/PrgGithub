%% ParcourSlowWaveReboundDetection
%
% 02/06/2020  LP
%
% Script to get % of co-occurrence between ref and observed slow wave
% types, in order to quantify 'observed' slow waves which are pre - rebounds
% or post- rebounds of ref slow waves. 
% -> restricted to NREM !
% -> Store in a .mat file


clear

% For plotting functions :
addpath('/Users/leaprunier/Dropbox/Kteam/PrgMatlab/MatFilesMarie')

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourSlowWaveReboundDetection.mat' ; 


% -------------------------- Choose co-occurrence parameters -------------------------- :

% choose co-occurrence detection delays (pre- and post- slow wave ref, in ms) :
cooccur_delay1 = 50 ; 
cooccur_delay2 = 250 ; 
cooccur_delays = [cooccur_delay1,cooccur_delay2] ; 

% -------------------------- Get co-occurrence data for all sessions -------------------------- :

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
    
    % 'Reference' Slow Waves :
    SW_ref_union = ts(sort([Range(slowwave_type3.deep_peaktimes)',Range(slowwave_type4.deep_peaktimes)',Range(slowwave_type6.deep_peaktimes)'])) ; % ts with all ref slow waves (deep positive)
    SW_ref = {slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type6.deep_peaktimes,SW_ref_union} ;
    SW_ref_names = {'SW3','SW4','SW6','SW3_4_6'} ; 

    % 'Observed'Slow Waves, suspected to be 'rebounds' of 'reference' slow waves :
    SW_obs = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    SW_obs_names = {'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'} ; 

    % LOAD SUBSTAGES : 
    load('SleepSubstages.mat') ; 
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
    SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;
    
    % ------------------------------------------ Axtract Cooccurrence ------------------------------------------ :
    
    % --- For each obs SW --- :
    
    tosave = {} ; % to store names of the structures to save
    for obs_type = 1:length(SW_obs) 

        % --- For each ref SW --- :

        for ref_type = 1:length(SW_ref)

            % Get info about cooccurrence proportion for the 2 time delays :
            [co1, cot1] = EventsCooccurrence(Restrict(SW_obs{obs_type},SWS),Restrict(SW_ref{ref_type},SWS), [cooccur_delay1 cooccur_delay1]) ;
            co_prop1 = sum(co1)/length(co1) * 100 ; 
            [co2, cot2] = EventsCooccurrence(Restrict(SW_obs{obs_type},SWS),Restrict(SW_ref{ref_type},SWS), [cooccur_delay2 cooccur_delay2]) ;
            co_prop2 = sum(co2)/length(co2) * 100 ; 

            eval(['SlowWaves' num2str(obs_type) '.CooccurProp1_' SW_ref_names{ref_type} '{p}= co_prop1 ;']) ;
            eval(['SlowWaves' num2str(obs_type) '.CooccurProp2_' SW_ref_names{ref_type} '{p}= co_prop2 ;']) ;
        end
        
        tosave{end+1} = ['SlowWaves' num2str(obs_type)] ; % to store names of all structures
        
    end
end

% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

struct_names = tosave ;
save(FileToSave,'detection_parameters','Info_res',tosave{:},'struct_names','cooccur_delays','SW_ref_names') ; 

        
        


        
        
        