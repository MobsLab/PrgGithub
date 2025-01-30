%% ParcourMakeSlowWavesOn2Channels_Obphase_LP
% 
% 09/06/2020  LP
%
% Script to create .mat files with slow waves for all sessions from a
% PathForExperiment. 
%
% SEE : MakeSlowWavesOn2Channels_Obphase_LP() 

% ----------------------------------------- ACCESS DATA ----------------------------------------- :
clear

Dir = PathForExperimentsBasalSleepSpike2_HardDrive ;
%Dir = PathForExperimentsBasalSleepSpike2 ;

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])
 
      
    % Load OB LFP :
    load('ChannelsToAnalyse/Bulb_deep')
    load(['LFPData/LFP',num2str(channel)])
    LFPOBdeep = LFP;
    ChannelOBdeep = channel ;
    clear LFP channel

    % Extract 2-channel slow waves and save file : 
    MakeSlowWavesOn2Channels_ObPhase_LP(LFPOBdeep,'OBfilterfreq', [3 5],'recompute',1,'filename','SlowWaves2Channels_ObPhase_LP');
    
end
