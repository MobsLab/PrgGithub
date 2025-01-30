%%ParcoursGeneratePhaseLFP
% 23.07.2019 KJ
%
%
% see
%   MakeDeltaOnChannelsEvent
%


clear
Dir = PathForExperimentsRandomShamSpikes;
zerophase = 0; 

for p=1:length(Dir.path)  

    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p zerophase
        
    mkdir('PhaseLFP')
    
    
    %% Load

    %LFP deep
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    ch_deep = channel;
    %LFP sup
    try
        load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
        ch_sup = channel;
    catch
        load('ChannelsToAnalyse/PFCx_deltasup.mat', 'channel')
        ch_sup = channel;
    end
    %create LFP Phase
    MakePhaseLFPData(ch_deep,'zerophase',zerophase);
    MakePhaseLFPData(ch_sup,'zerophase',zerophase);
% 
%     
%     %
%     load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
%     channels_sup = channels(clusters==1);
%     for i=1:length(channels_sup)
%         MakePhaseLFPData(channels_sup(i));
%     end

    
end

