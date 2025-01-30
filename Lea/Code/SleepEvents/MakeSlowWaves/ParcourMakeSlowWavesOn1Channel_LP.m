%% ParcourMakeSlowWavesOn1Channel_LP
% 
% 11/05/2020  LP
%
% Script to create .mat files with slow waves for all sessions from a
% PathForExperiment. 
%
% SEE : MakeSlowWavesOn1Channel_LP() 

% ----------------------------------------- ACCESS DATA ----------------------------------------- :
clear

Dir = PathForExperimentsBasalSleepSpike2_HardDrive ;
%Dir = PathForExperimentsBasalSleepSpike2 ;


% --------------------------------------- SET PARAMETERS --------------------------------------- :
filterfreq = [1 5] ; 
epoch = 'all' ; 


%% EXTRACT SLOW WAVES and MAKE .mat FILE, for all sessions : 


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    
    %mex /Users/leaprunier/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/FindInInterval.c
    
    disp(' -> extracting slow waves...') 
    

% ------------------------------------------ Load Data ------------------------------------------ :
    
    % Load LFP channels :

    load('ChannelsToAnalyse/PFCx_deep')
    ChannelDeep = channel ;
    load('ChannelsToAnalyse/PFCx_sup')
    ChannelSup = channel ;
    clear channel

    % Extract slow waves and save files : 
    % Sup Slow Waves : 
    MakeSlowWavesOn1Channel_LP(ChannelSup,'epoch',epoch,'filterfreq',filterfreq,'filename','SlowWavesChannels_LP','recompute',1);
    % Deep Slow Waves : 
    MakeSlowWavesOn1Channel_LP(ChannelDeep,'epoch',epoch,'filterfreq',filterfreq,'filename','SlowWavesChannels_LP','recompute',1); 
    
end