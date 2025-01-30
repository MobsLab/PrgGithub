%% ParcourCrossCorr_AllSlowWaveTypes
% 
% 28/05/2020  LP
%
% Script to get cross-correlograms between all slow wave types, for all sessions.
%
% -> stored in structures 

clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourCrossCorr_AllSlowWaveTypes.mat' ; 

% For each session :

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
    % 2-Channel Slow Waves : 
    load('SlowWaves2Channels_LP.mat')
    % Delta KJ & Down States : 
    load('DownState.mat','alldown_PFCx')
    load('DeltaWaves.mat','alldeltas_PFCx')
    alldelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; 
    alldown_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ;

    % All events :
    all_slowwaves = {alldown_ts,alldelta_ts,slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    all_slowwaves_names = {'Down','Delta','SW1', 'SW2', 'SW3','SW4', 'SW5', 'SW6','SW7', 'SW8'} ; 
    tosave = {} ; 
    
    % ------------------------------------------ Get all Cross-correlograms ------------------------------------------ :
    
    for type = 1:length(all_slowwaves) % each row of all cross-correlograms ( = observed SW )
    
        for type2 = 1:type % each corresponding column (= SW reference for crosscorr)
            
        [C,B]=CrossCorr(Range(all_slowwaves{type2}),Range(all_slowwaves{type}),10,120); % reference = row
    
        % Auto-Correlograms : 
        if type2==type
            C(B==0) = 0 ;
        end     

        eval(['CrossCorr' num2str(type) '_' num2str(type2) '.crosscorr{p} = C ;']) ;
        eval(['CrossCorr' num2str(type) '_' num2str(type2) '.crosscorr_t{p} = B ;']) ;
        eval(['CrossCorr' num2str(type) '_' num2str(type2) '.SWtypes{p} = [type,type2] ;']) ;
        
        tosave{end+1} = ['CrossCorr' num2str(type) '_' num2str(type2)] ; % to store names of all structures  
        
        end
        
    end
     
end

% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 
crosscorr_names = tosave ; 
save(FileToSave,'detection_parameters','Info_res',tosave{:}, 'crosscorr_names', 'all_slowwaves_names') ; 


