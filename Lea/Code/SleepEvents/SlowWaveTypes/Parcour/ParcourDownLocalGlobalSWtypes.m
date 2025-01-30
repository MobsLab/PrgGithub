%% ParcourDownLocalGlobalSWtypes
%
% 03/07/2020  LP 
%
% -> Script to quantify index of down state "globality" (global vs local
% down state) associated to different types of SW. Computes the mean proportion
% of tetrodes with a local down state detected during sw associated to
% global down states (during NREM only). 
%
% -> 1 structure for each SW type : ex. LocalDownSW3
%
% -> Fields = cell array with, for all sessions : 
%
%       -   AllTetrodesDetection    : logical arrays of down-state
%       co-occurrence on all sw (associated to global down during NREM),
%       one sub-cell for each tetrode
%       -   TetrodeProp   : array of the proportion of tetrodes with a
%       co-occurring local down state, on all sw (associated to global 
%       down during NREM)
%       -   MeanTetrodeProp   : mean proportion of tetrodes with a co-occurring
%       down state, across sw (associated to global down during NREM). 


clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourDownLocalGlobalSWtypes.mat' ; 


% For each session :

for p=1:length(Dir.path)
    
    clearvars -except Dir FileToSave LocalDownSW3 LocalDownSW4 LocalDownSW6 Info_res p

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
 
    load('LocalDownState.mat') % all_local_PFCx with down states detected on each tetrode separately
    load('DownState.mat')
    load('SlowWaves2Channels_LP.mat')

    all_sw = {slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type6.deep_peaktimes} ; 
    all_sw_names = {'SW3','SW4','SW6'} ; 
    n_tetrodes = length(all_local_PFCx) ; 
    
    
    % ------------------------------------------Extract Data ------------------------------------------ :
 
    localdown_prop = [] ; 
    mean_prop_tetrodes = [] ; % To store mean proportion of tetrodes on which a local down state is detected during global-down associated slow waves. 

    for type = 1:length(all_sw)
        sw_ts = all_sw{type} ; 

        for tt = 1:n_tetrodes %for each tetrode
            down_tt = all_local_PFCx{tt} ; 
            sw_ts = Restrict(sw_ts,down_PFCx) ; % restrict NREM SW to SW occurring during NREM down states only
            
            sw_inlocaldown{tt} = belong(down_tt,Range(sw_ts)) ; % true for sw occurring during down states on this tetrode, for all tetrodes
        end

        localdown_nb_tetrodes = sum(cell2mat(sw_inlocaldown),2) ; % for each sw (associated to a global down state), array with the number of tetrodes on which a down state is detected
        localdown_prop_tetrodes = localdown_nb_tetrodes / n_tetrodes ; % array with the PROPORTION of tetrodes on which a down state is detected
        mean_prop_tetrodes = mean(localdown_nb_tetrodes / n_tetrodes) ; % value, mean proportion of tetrodes with local down states detected as co-occurring with global-down associated sw.
    
        % Store in a structure :
        eval(['LocalDown' all_sw_names{type} '.AllTetrodesDetection{p} = sw_inlocaldown ;'])
        eval(['LocalDown' all_sw_names{type} '.TetrodeProp{p} = localdown_prop_tetrodes ;'])
        eval(['LocalDown' all_sw_names{type} '.MeanTetrodeProp{p} = mean_prop_tetrodes ;'])
        
        
    end
    
end


% SAVE .mat FILE with extracted data for all sessions and all slow wave types :  
save(FileToSave,'LocalDownSW3','LocalDownSW4','LocalDownSW6','Info_res') ; 

