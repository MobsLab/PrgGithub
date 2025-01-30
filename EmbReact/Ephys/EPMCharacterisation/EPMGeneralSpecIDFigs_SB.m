clear all
Dir=PathForExperimentsEmbReact('EPM');
SpeedLim = 10;


for mm = 1:length(Dir.path)
    
    cd(Dir.path{mm}{1})
    load('behavResources_SB.mat')
    
    MovEpoch = thresholdIntervals(Behav.Vtsd,SpeedLim,'Direction','Above');
    MovEpoch = mergeCloseIntervals(MovEpoch,1*1e4) - Behav.FreezeEpoch;
    NotMovEpoch = intervalSet(0,max(Range(Behav.Vtsd))) - MovEpoch;
        
    load('B_Low_Spectrum.mat')
    subplot(231)
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    hold on
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch)))),'r','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch)))),'b','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch)))),'r','linewidth',3,'linestyle',':')
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch)))),'b','linewidth',3,'linestyle',':')
    legend('Open','Closed')
    title('OB')
    xlabel('Frequency(Hz)')
    ylabel('Power')
    legend({'OpenMov','ClosedMov','OpenSlow','ClosedSlow'})
    
    load('H_Low_Spectrum.mat')
    subplot(232)
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    hold on
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch)))),'r','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch)))),'b','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch)))),'r','linewidth',3,'linestyle',':')
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch)))),'b','linewidth',3,'linestyle',':')
    title('HPC')
    xlabel('Frequency(Hz)')
    ylabel('Power')
    
    load('PFCx_Low_Spectrum.mat')
    subplot(233)
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    hold on
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch)))),'r','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch)))),'b','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch)))),'r','linewidth',3,'linestyle',':')
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch)))),'b','linewidth',3,'linestyle',':')
    title('PFC')
    xlabel('Frequency(Hz)')
    ylabel('Power')
    
    load('B_PFCx_Low_Coherence.mat')
    subplot(245)
    sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
    hold on
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch)))),'r','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch)))),'b','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch)))),'r','linewidth',3,'linestyle',':')
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch)))),'b','linewidth',3,'linestyle',':')
    title('Bulb-PFC')
    xlabel('Frequency(Hz)')
    ylabel('Coherence')
    
    load('H_PFCx_Low_Coherence.mat')
    subplot(246)
    sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
    hold on
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch)))),'r','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch)))),'b','linewidth',3)
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch)))),'r','linewidth',3,'linestyle',':')
    plot(Spectro{3},nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch)))),'b','linewidth',3,'linestyle',':')
    title('HPC-PFC')
    xlabel('Frequency(Hz)')
    ylabel('Coherence')
    
    if exist('HeartBeatInfo.mat')>0
    load('HeartBeatInfo.mat')
    A = {(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{1},MovEpoch)))),...
        (Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{2},MovEpoch)))),...
        (Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{1},NotMovEpoch)))),...
        (Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{2},NotMovEpoch))))};
    subplot(247)
    violin(A)
    set(gca,'XTick',[1:4],'XTickLabel',{'OpenMov','ClosedMov','OpenSlow','ClosedSlow'})
    ylabel('Heart rate /s')
    end
    
    A = {log(Data(Restrict(Behav.Vtsd,(Behav.ZoneEpoch{1})))),...
        log(Data(Restrict(Behav.Vtsd,(Behav.ZoneEpoch{2}))))};
    
    for i = 1:2
        A{i}(A{i}<-2.5) = [];
    end
    
    subplot(4,4,12)
    nhist(A)
    legend({'Open','Closed'})
    
    
    A = {log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{1},MovEpoch)))),...
        log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{2},MovEpoch)))),...
        log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{1},NotMovEpoch)))),...
        log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{2},NotMovEpoch))))};
    for i = 1:4
        A{i}(A{i}<-2.5) = [];
    end
    subplot(4,4,16)
    nhist(A)
    legend({'OpenMov','ClosedMov','OpenSlow','ClosedSlow'})
    
    saveas(1,['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/EPM/EPM_fiche_id',num2str(Dir.ExpeInfo{mm}{1}.nmouse),'.png'])
    clf
    
end

