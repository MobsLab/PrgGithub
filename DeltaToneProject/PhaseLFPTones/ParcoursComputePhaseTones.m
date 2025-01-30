%%ParcoursComputePhaseTones
% 06.08.2019 KJ
%
%   
%   
%
% see
%   ScriptTonesEffectPhaseLFP ParcoursComputePhaseSham
%   ParcoursTonesEffectPhaseLFP ParcoursComputePhaseFwTones
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
    
    if exist('PhaseLFP/PhaseTones.mat','file')==2
        continue
    end
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    
    %channels
    load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
    %LFP Phase Sup
    ch_sup = [];
    PhaseSup = [];
    try
        load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
        ch_sup = channel;
        if clusters(channels==ch_sup)==1
            load(fullfile('PhaseLFP',['PhaseLFP' num2str(ch_sup) '.mat']))
            PhaseSup = PhaseLFP;        
        end
    end
    
    %LFP Phase Deep
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    ch_deep = channel;
    load(fullfile('PhaseLFP',['PhaseLFP' num2str(ch_deep) '.mat']))
    PhaseDeep = PhaseLFP;
    
    
    %% Tones phases
    PhaseToneDeep = Restrict(PhaseDeep,ToneEvent);
    PhaseToneDeep = tsd(Range(ToneEvent),Data(PhaseToneDeep));
    save('PhaseLFP/PhaseTones.mat','PhaseToneDeep')
    
    if ~isempty(PhaseSup)
        PhaseToneSup  = Restrict(PhaseSup,ToneEvent);
        PhaseToneSup  = tsd(Range(ToneEvent),Data(PhaseToneSup));
        save('PhaseLFP/PhaseTones.mat','-append','PhaseToneSup')
    end
    

    
end








