%%ParcoursComputePhaseFwTones
% 06.08.2019 KJ
%
%   same as ParcoursComputePhaseTones, but with a forward filter
%   
%
% see
%   ParcoursComputePhaseTones ParcoursGeneratePhaseLFP
%

clear
Dir = PathForExperimentsRandomTonesSpikes;


%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    if exist('PhaseLFP/PhaseFwTones.mat','file')==2
        continue
    end
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    
    %channels
    load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
    %LFP Phase Sup
    ch_sup = [];
    PhaseFwSup = [];
    try
        load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
        ch_sup = channel;
        if clusters(channels==ch_sup)==1
            load(fullfile('PhaseLFP',['PhaseFwLFP' num2str(ch_sup) '.mat']))
            PhaseFwSup = PhaseLFP;        
        end
    end
    
    %LFP Phase Deep
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    ch_deep = channel;
    load(fullfile('PhaseLFP',['PhaseFwLFP' num2str(ch_deep) '.mat']))
    PhaseFwDeep = PhaseLFP;
    
    
    %% Tones phases
    PhaseFwToneDeep = Restrict(PhaseFwDeep,ToneEvent);
    PhaseFwToneDeep = tsd(Range(ToneEvent),Data(PhaseFwToneDeep));
    save('PhaseLFP/PhaseFwTones.mat','PhaseFwToneDeep')
    
    if ~isempty(PhaseFwSup)
        PhaseFwToneSup  = Restrict(PhaseFwSup,ToneEvent);
        PhaseFwToneSup  = tsd(Range(ToneEvent),Data(PhaseFwToneSup));
        save('PhaseLFP/PhaseFwTones.mat','-append','PhaseFwToneSup')
    end
    

    
end








