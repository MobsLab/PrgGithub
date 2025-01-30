%%Input Dir

%%C57
% Dir_sal_mCherry_C57 = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
% Dir_sal_noDREADD_C57 = PathForExperiments_DREADD_MC('noDREADD_SalineInjection_10am');
% Dir = MergePathForExperiment(Dir_sal_mCherry_C57,Dir_sal_noDREADD_C57);

%%CRH
Dir_sal_mCherry_CRH = PathForExperiments_DREADD_AD('mCherry_CRH_VLPO_SalineInjection_10am');
Dir_sal_DREADDinhib_CRH = PathForExperiments_DREADD_AD('inhibDREADD_CRH_VLPO_SalineInjection_10am');
Dir = MergePathForExperiment(Dir_sal_mCherry_CRH,Dir_sal_DREADDinhib_CRH);

%%

for i=1:length(Dir.path)
    clear LFP alldeltas_PFCx deltas_PFCx deltas_PFCx_info LFP
    cd(Dir.path{i}{1});
    
    load(['ChannelsToAnalyse/PFCx_deep' ''],'channel');
    load(['LFPData/LFP',num2str(channel)]);
    load('DeltaWaves.mat')
    
    PFCdelta=LFP;
    Info.channel = channel;
    clear LFP channel
    
    [M(i,:),T{i}]=PlotRipRaw(PFCdelta, delta*1e4, [-1000 1000]);
    
end

