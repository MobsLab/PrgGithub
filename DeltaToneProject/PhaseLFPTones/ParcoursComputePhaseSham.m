%%ParcoursComputePhaseSham
% 06.08.2019 KJ
%
%   
%   
%
% see 
%   ScriptTonesEffectPhaseLFP ParcoursComputePhaseTones
%   ParcoursTonesEffectPhaseLFP ParcoursComputePhaseFwSham
%

clear
Dir = PathForExperimentsRandomShamSpikes;


for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    
    clearvars -except Dir p
    
%     if exist('PhaseLFP/PhaseSham.mat','file')==2
%         continue
%     end
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    
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
    PhaseShamDeep = Restrict(PhaseDeep,SHAMtime);
    PhaseShamDeep = tsd(Range(SHAMtime),Data(PhaseShamDeep));
    save('PhaseLFP/PhaseSham.mat','PhaseShamDeep')
    
    if ~isempty(PhaseSup)
        PhaseShamSup  = Restrict(PhaseSup,SHAMtime);
        PhaseShamSup  = tsd(Range(SHAMtime),Data(PhaseShamSup));
        save('PhaseLFP/PhaseSham.mat','-append','PhaseShamSup')
    end
    
end




