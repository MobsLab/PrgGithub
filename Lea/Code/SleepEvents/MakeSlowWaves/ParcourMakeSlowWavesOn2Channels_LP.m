%% ParcourMakeSlowWavesOn2Channels_LP
% 
% 11/05/2020  LP
%
% Script to create .mat files with slow waves for all sessions from a
% PathForExperiment. 
%
% SEE : MakeSlowWavesOn2Channels_LP() 

% ----------------------------------------- ACCESS DATA ----------------------------------------- :
clear

Dir = PathForExperimentsBasalSleepSpike2_HardDrive ;
%Dir = PathForExperimentsBasalSleepSpike2 ;

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    
    %mex /Users/leaprunier/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/FindInInterval.c
 
      
    % Load LFP channels :

    load('ChannelsToAnalyse/PFCx_deep')
    ChannelDeep = channel ;
    load('ChannelsToAnalyse/PFCx_sup')
    ChannelSup = channel ;
    clear channel

    % Extract 2-channel slow waves and save file : 
    
    MakeSlowWavesOn2Channels_LP(ChannelDeep, ChannelSup, 'epoch', 'all','filterfreq', [1 5],'filename','SlowWaves2Channels_LP','recompute',1);
  
end
