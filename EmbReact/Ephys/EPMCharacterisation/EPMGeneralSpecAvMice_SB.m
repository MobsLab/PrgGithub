clear all
Dir=PathForExperimentsEmbReact('EPM');
SpeedLim = 10;
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high


for mm = 1:length(Dir.path)
    
    cd(Dir.path{mm}{1})
    load('behavResources_SB.mat')
    
    MovEpoch = thresholdIntervals(Behav.Vtsd,SpeedLim,'Direction','Above');
    MovEpoch = mergeCloseIntervals(MovEpoch,1*1e4) - Behav.FreezeEpoch;
    NotMovEpoch = intervalSet(0,max(Range(Behav.Vtsd))) - MovEpoch;
    
    load('B_Low_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    Spec.OB{1}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch))));
    Spec.OB{2}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch))));
    Spec.OB{3}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch))));
    Spec.OB{4}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch))));
    
    
    load('H_Low_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    Spec.HPC{1}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch))));
    Spec.HPC{2}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch))));
    Spec.HPC{3}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch))));
    Spec.HPC{4}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch))));
    
    load('PFCx_Low_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    Spec.HPC{1}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch))));
    Spec.HPC{2}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch))));
    Spec.HPC{3}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch))));
    Spec.HPC{4}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch))));
    
    load('B_PFCx_Low_Coherence.mat')
    sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
    Spec.B_PFC{1}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch))));
    Spec.B_PFC{2}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch))));
    Spec.B_PFC{3}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch))));
    Spec.B_PFC{4}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch))));
    
    load('H_PFCx_Low_Coherence.mat')
    sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
    Spec.H_PFC{1}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch))));
    Spec.H_PFC{2}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch))));
    Spec.H_PFC{3}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch))));
    Spec.H_PFC{4}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch))));
    
    if exist('HeartBeatInfo.mat')>0
        load('HeartBeatInfo.mat')
        HeartRate(mm,:) = [nanmean(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{1},MovEpoch)))),...
            nanmean(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{2},MovEpoch)))),...
            nanmean(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{1},NotMovEpoch)))),...
            nanmean(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{2},NotMovEpoch))))];
        
        HeartVar(mm,:) = [nanstd(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{1},MovEpoch)))),...
            nanstd(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{2},MovEpoch)))),...
            nanstd(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{1},NotMovEpoch)))),...
            nanstd(Data(Restrict(EKG.HBRate,and(Behav.ZoneEpoch{2},NotMovEpoch))))];
    end
    
    A = {log(Data(Restrict(Behav.Vtsd,(Behav.ZoneEpoch{1})))),...
        log(Data(Restrict(Behav.Vtsd,(Behav.ZoneEpoch{2}))))};
    
    for i = 1:2
        A{i}(A{i}<-2.5) = [];
        [Y,X]= hist(A{i},[-3:0.2:5]);
        SpeeDistrib{i}(mm,:) = Y/sum(Y);
    end
    
    A = {log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{1},MovEpoch)))),...
        log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{2},MovEpoch)))),...
        log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{1},NotMovEpoch)))),...
        log(Data(Restrict(Behav.Vtsd,and(Behav.ZoneEpoch{2},NotMovEpoch))))};
    for i = 1:4
        A{i}(A{i}<-2.5) = [];
        [Y,X]= hist(A{i},[-3:0.2:5]);
        SpeeDistribSep{i}(mm,:) = Y/sum(Y);
    end
    
    if exist('LocalHPC_Low_Spectrum.mat')>0
        load('LocalHPC_Low_Spectrum.mat')
        
        sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
        Spec.LocalHPC{1}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch))));
        Spec.LocalHPC{2}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch))));
        Spec.LocalHPC{3}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch))));
        Spec.LocalHPC{4}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch))));
    end
    
    if exist('LocalOB_Low_Spectrum.mat')>0
        load('LocalOB_Low_Spectrum.mat')
        sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
        Spec.LocalOB{1}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},MovEpoch))));
        Spec.LocalOB{2}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},MovEpoch))));
        Spec.LocalOB{3}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{1},NotMovEpoch))));
        Spec.LocalOB{4}(mm,:) = nanmean(Data(Restrict(sptsd,and(Behav.ZoneEpoch{2},NotMovEpoch))));
    end
    
    try
        load('RipplesSleepThresh.mat')
        tsRipples = ts(RipplesR(:,1)*10);
        RipNum(mm,:) = [length(Range(Restrict(tsRipples,Behav.ZoneEpoch{1})))/sum(Stop(Behav.ZoneEpoch{1},'s')-Start(Behav.ZoneEpoch{1},'s')),...
            length(Range(Restrict(tsRipples,Behav.ZoneEpoch{2})))/sum(Stop(Behav.ZoneEpoch{2},'s')-Start(Behav.ZoneEpoch{2},'s'))];
    catch
            RipNum(mm,:) = [NaN,NaN];
    end
    
end



figure
AllFields = fieldnames(Spec);
Cols = {'r','b','r','b'};
LineSt = {'-','-',':',':'};
for f = 1:length(AllFields)
    subplot(3,2,f)
    
    for k =1:4
        Spec.(AllFields{f}){k}(find(sum(Spec.(AllFields{f}){k}'==0)>50),:)=NaN;
        plot(Spectro{3},nanmean(Spec.(AllFields{f}){k}),'linewidth',2,'color',Cols{k},'linestyle',LineSt{k}),hold on
        
    end
    
    legend({'OpenMov','ClosedMov','OpenSlow','ClosedSlow'})
    title(AllFields{f})
    box off
    set(gca,'linewidth',2)
    xlabel('Frequency')
    
end

AllFields = fieldnames(Spec);
Cols = {'r','b','r','b'};
LineSt = {'-','-',':',':'};
for f = 1:length(AllFields)
    subplot(3,2,f)
    
    for k =1:2
        Spec.(AllFields{f}){k}(find(sum(Spec.(AllFields{f}){k}'==0)>50),:)=NaN;
        errorbar(Spectro{3},nanmean(Spec.(AllFields{f}){k}),stdError(Spec.(AllFields{f}){k}),'linewidth',2,'color',Cols{k},'linestyle',LineSt{k}),hold on
        
    end
    
    legend({'OpenMov','ClosedMov','OpenSlow','ClosedSlow'})
    title(AllFields{f})
    box off
    set(gca,'linewidth',2)
    xlabel('Frequency')
    
end

clf
AllFields = fieldnames(Spec);
Cols = {'r','b','r','b'};
LineSt = {'-','-',':',':'};
for f = 1:length(AllFields)
    subplot(3,2,f)
    
    for k =3:4
        Spec.(AllFields{f}){k}(find(sum(Spec.(AllFields{f}){k}'==0)>50),:)=NaN;
        errorbar(Spectro{3},nanmean(Spec.(AllFields{f}){k}),stdError(Spec.(AllFields{f}){k}),'linewidth',2,'color',Cols{k},'linestyle',LineSt{k}),hold on
        
    end
    
    legend({'OpenSlow','ClosedSlow'})
    title(AllFields{f})
    box off
    set(gca,'linewidth',2)
    xlabel('Frequency')
end



HeartRate(HeartRate==0) = NaN;
HeartVar(HeartVar==0) = NaN;

figure
subplot(121)
PlotErrorBarN_KJ(HeartRate,'newfig',0)
ylim([11 14])
set(gca,'XTick',[1:4],'XTickLabel',{'OpenMov','ClosedMov','OpenSlow','ClosedSlow'})
xtickangle(45)
box off
set(gca,'linewidth',2)
ylabel('Heart rate')

subplot(122)
PlotErrorBarN_KJ(HeartVar,'newfig',0)
set(gca,'XTick',[1:4],'XTickLabel',{'OpenMov','ClosedMov','OpenSlow','ClosedSlow'})
xtickangle(45)
box off
set(gca,'linewidth',2)
ylabel('Heart rate var')

figure
for k = 1:4
plot(nanmean(SpeeDistribSep{k}),'linewidth',2,'color',Cols{k},'linestyle',LineSt{k}),hold on

end

figure
for k = 1:2
plot(nanmean(SpeeDistrib{k}),'linewidth',2,'color',Cols{k},'linestyle',LineSt{k}),hold on
end
box off
set(gca,'linewidth',2)
set(gca,'linewidth',2,'FontSize',15)
xlabel('Speed - log')
ylabel('Counts - norm')
legend({'Open','Closed'})
