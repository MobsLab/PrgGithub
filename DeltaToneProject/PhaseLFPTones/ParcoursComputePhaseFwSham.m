%%ParcoursComputePhaseFwSham
% 06.08.2019 KJ
%
%   
%   
%
% see
%   ScriptTonesEffectPhaseLFP ParcoursComputePhaseTones ParcoursTonesEffectPhaseLFP
%

clear
Dir = PathForExperimentsRandomShamSpikes;


for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p 

    %if already exists
    if exist('PhaseLFP/PhaseFwSham.mat','file')==2
        continue
    end
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    
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
    
    
    %% Sham phases
    PhaseFwShamDeep = Restrict(PhaseFwDeep,SHAMtime);
    PhaseFwShamDeep = tsd(Range(SHAMtime),Data(PhaseFwShamDeep));
    save('PhaseLFP/PhaseFwSham.mat','PhaseFwShamDeep')
    
    if ~isempty(PhaseFwSup)
        PhaseFwShamSup  = Restrict(PhaseFwSup,SHAMtime);
        PhaseFwShamSup  = tsd(Range(SHAMtime),Data(PhaseFwShamSup));
        save('PhaseLFP/PhaseFwSham.mat','-append','PhaseFwShamSup')
    end
    
    
end




