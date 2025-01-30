%%CRH
Dir_sal_mCherry_CRH = PathForExperiments_DREADD_AD('mCherry_CRH_VLPO_SalineInjection_10am');
Dir_sal_DREADDinhib_CRH = PathForExperiments_DREADD_AD('inhibDREADD_CRH_VLPO_SalineInjection_10am');
Dir = MergePathForExperiment(Dir_sal_mCherry_CRH,Dir_sal_DREADDinhib_CRH);

%%


for i=1:length(Dir.path)
    clear LFP alldeltas_PFCx deltas_PFCx deltas_PFCx_info
    cd(Dir.path{i}{1});
    
    load(['ChannelsToAnalyse/PFCx_deep' ''],'channel');
    load(['LFPData/LFP',num2str(channel)]);
    LFPd = LFP;
    clear LFP channel
    
    load(['ChannelsToAnalyse/PFCx_sup' ''],'channel');
    load(['LFPData/LFP',num2str(channel)]);
    LFPs = LFP;
    clear LFP channel
    
    load('DeltaWaves.mat')
    
    
    [m,s,t]=mETAverage(Start(deltas_PFCx),Range(LFPd),Data(LFPd),1,2000);
    [m2,s2,t2]=mETAverage(Start(deltas_PFCx),Range(LFPs),Data(LFPs),1,2000);
    
    figure('color',[1 1 1]),
    subplot(2,2,1:2),
    plot(Range(LFPd),Data(LFPd))
    hold on, plot(Start(deltas_PFCx),ones(length(Start(deltas_PFCx)),1),'ro')
    subplot(2,2,3), plot(t,m)
    hold on, plot(t2,m2,'r')
    line([0 0],ylim,'color','k','linestyle','--')
    subplot(2,2,4), plot(t,zscore(m))
    hold on, plot(t2,zscore(m2),'r')
    line([0 0],ylim,'color','k','linestyle','--')
    
    
    [M(i,:),T{i}]=PlotRipRaw(LFPd, Start(deltas_PFCx)/1E4, [-1000 1000]);
    [M(i,:),T{i}]=PlotRipRaw(LFPd, End(deltas_PFCx)/1E4, [-1000 1000]);
    [M2(i,:),T2{i}]=PlotRipRaw(LFPs, Start(deltas_PFCx)/1E4, [-1000 1000]);
    [M2(i,:),T2{i}]=PlotRipRaw(LFPs, End(deltas_PFCx)/1E4, [-1000 1000]);
    %%add save all variable
end
    
    

