clear all
nbin=30;
nmouse=1;

SpeedLim = 10;
MovLim = 0;

Dir=PathForExperimentsEmbReact('EPM');
SpeedLim = 10;
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
MouseToAvoid=[117,431,444,795]; % mice with noisy data to exclude
Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);


for mm = 1:length(Dir.path)
    
    cd(Dir.path{mm}{1})
    load('behavResources_SB.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    
    % Define epochs
    
    RemovEpoch=TotalNoiseEpoch;
    
    OpenEp=dropShortIntervals(Behav.ZoneEpoch{1},5*1e4)-RemovEpoch;
    ClosedEp=dropShortIntervals(Behav.ZoneEpoch{2},5*1e4)-RemovEpoch;
    
    if MovLim
        MovEpoch = thresholdIntervals(Behav.Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
        OpenEp = and(OpenEp,MovEpoch);
        ClosedEp = and(ClosedEp,MovEpoch);
    elseif MovLim == -1
        MovEpoch = thresholdIntervals(Behav.Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
        OpenEp = OpenEp-MovEpoch;
        ClosedEp = ClosedEp-MovEpoch;
    end
    
    DurEp.Open(nmouse,:)=sum(Stop(OpenEp,'s')-Start(OpenEp,'s'));
    DurEp.Close(nmouse,:)=sum(Stop(ClosedEp,'s')-Start(ClosedEp,'s'));
    
    
    
    %% Spectra
    load('H_Low_Spectrum.mat')
    Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanSpecH.OpenEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,OpenEp)));
    MeanSpecH.ClosedEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,ClosedEp)));
    
    load('B_Low_Spectrum.mat')
    Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanSpecB.OpenEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,OpenEp)));
    MeanSpecB.ClosedEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,ClosedEp)));
    
    load('B_PFCx_Low_Coherence.mat')
    Sptsd = tsd(Coherence{2}*1e4,(Coherence{1}));
    MeanSpecB_P.OpenEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,OpenEp)));
    MeanSpecB_P.ClosedEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,ClosedEp)));
    
    load('H_PFCx_Low_Coherence.mat')
    Sptsd = tsd(Coherence{2}*1e4,(Coherence{1}));
    MeanSpecH_P.OpenEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,OpenEp)));
    MeanSpecH_P.ClosedEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,ClosedEp)));
    
    load('PFCx_Low_Spectrum.mat')
    Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanSpecP.OpenEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,OpenEp)));
    MeanSpecP.ClosedEp(nmouse,:) = nanmean(Data(Restrict(Sptsd,ClosedEp)));
    
    load('InstFreqAndPhase_B.mat','LocalFreq')
    [Y,X] = hist(runmean(Data(Restrict(LocalFreq.PT,OpenEp)),1),[1:0.1:12]);
    DistribFreqB.OpenEp(nmouse,:) = Y/sum(Y);
    [Y,X] = hist(runmean(Data(Restrict(LocalFreq.PT,ClosedEp)),1),[1:0.1:12]);
    DistribFreqB.ClosedEp(nmouse,:) = Y/sum(Y);
    
    load('InstFreqAndPhase_H.mat','LocalFreq')
    [Y,X] = hist(runmean(Data(Restrict(LocalFreq.PT,OpenEp)),1),[1:0.1:12]);
    DistribFreqH.OpenEp(nmouse,:) = Y/sum(Y);
    [Y,X] = hist(runmean(Data(Restrict(LocalFreq.PT,ClosedEp)),1),[1:0.1:12]);
    DistribFreqH.ClosedEp(nmouse,:) = Y/sum(Y);
    
    
    nmouse=nmouse+1;
end


figure

clf
subplot(2,3,1)
SpecAway = [];
SpecTo = [];
for nmouse  = 1:7
    SpecAway = [SpecAway;MeanSpecH.ClosedEp(nmouse,:)./sum(MeanSpecH.ClosedEp(nmouse,:))];
    SpecTo = [SpecTo;MeanSpecH.OpenEp(nmouse,:)./sum(MeanSpecH.OpenEp(nmouse,:))];
end
plot(Spectro{3},nanmean(SpecAway),'color',UMazeColors('safe'),'linewidth',2),
hold on
plot(Spectro{3},nanmean(SpecAway),'color',UMazeColors('shock'),'linewidth',2),
g = shadedErrorBar(Spectro{3},nanmean(SpecAway),[stdError(SpecAway);stdError(SpecAway)]');
g.patch.FaceColor = UMazeColors('safe');
g.patch.EdgeColor = UMazeColors('safe');
g.mainLine.Color= UMazeColors('safe')*0.6; 
g.mainLine.LineWidth= 2; 
hold on
g = shadedErrorBar(Spectro{3},nanmean(SpecTo),[stdError(SpecTo);stdError(SpecTo)]');
g.patch.FaceColor = UMazeColors('shock');
g.patch.EdgeColor = UMazeColors('shock');
g.mainLine.Color= UMazeColors('shock')*0.6; 
g.mainLine.LineWidth= 2; 
title('HPC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Power - AU')
legend('Safe','Shock')

subplot(2,3,2)
SpecAway = [];
SpecTo = [];
for nmouse  = 1:7
    SpecAway = [SpecAway;MeanSpecB.ClosedEp(nmouse,:)./sum(MeanSpecB.ClosedEp(nmouse,:))];
    SpecTo = [SpecTo;MeanSpecB.OpenEp(nmouse,:)./sum(MeanSpecB.OpenEp(nmouse,:))];
end
plot(Spectro{3},nanmean(SpecAway),'color',UMazeColors('safe'),'linewidth',2),
hold on
plot(Spectro{3},nanmean(SpecAway),'color',UMazeColors('shock'),'linewidth',2),
g = shadedErrorBar(Spectro{3},nanmean(SpecAway),[stdError(SpecAway);stdError(SpecAway)]');
g.patch.FaceColor = UMazeColors('safe');
g.patch.EdgeColor = UMazeColors('safe');
g.mainLine.Color= UMazeColors('safe')*0.6; 
g.mainLine.LineWidth= 2; 
hold on
g = shadedErrorBar(Spectro{3},nanmean(SpecTo),[stdError(SpecTo);stdError(SpecTo)]');
g.patch.FaceColor = UMazeColors('shock');
g.patch.EdgeColor = UMazeColors('shock');
g.mainLine.Color= UMazeColors('shock')*0.6; 
g.mainLine.LineWidth= 2; 
title('OB')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Power - AU')

subplot(2,3,3)
SpecAway = [];
SpecTo = [];
for nmouse  = 1:7
    SpecAway = [SpecAway;MeanSpecP.ClosedEp(nmouse,:)./sum(MeanSpecP.ClosedEp(nmouse,:))];
    SpecTo = [SpecTo;MeanSpecP.OpenEp(nmouse,:)./sum(MeanSpecP.OpenEp(nmouse,:))];
end
plot(Spectro{3},nanmean(SpecAway),'color',UMazeColors('safe'),'linewidth',2),
hold on
plot(Spectro{3},nanmean(SpecAway),'color',UMazeColors('shock'),'linewidth',2),
g = shadedErrorBar(Spectro{3},nanmean(SpecAway),[stdError(SpecAway);stdError(SpecAway)]');
g.patch.FaceColor = UMazeColors('safe');
g.patch.EdgeColor = UMazeColors('safe');
g.mainLine.Color= UMazeColors('safe')*0.6; 
g.mainLine.LineWidth= 2; 
hold on
g = shadedErrorBar(Spectro{3},nanmean(SpecTo),[stdError(SpecTo);stdError(SpecTo)]');
g.patch.FaceColor = UMazeColors('shock');
g.patch.EdgeColor = UMazeColors('shock');
g.mainLine.Color= UMazeColors('shock')*0.6; 
g.mainLine.LineWidth= 2; 
title('PFC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Power - AU')

subplot(2,3,4)
plot(Spectro{3},nanmean(MeanSpecB_P.ClosedEp),'color',UMazeColors('safe'),'linewidth',2),
hold on
plot(Spectro{3},nanmean(MeanSpecB_P.ClosedEp),'color',UMazeColors('shock'),'linewidth',2),
g = shadedErrorBar(Spectro{3},nanmean(MeanSpecB_P.ClosedEp),[stdError(MeanSpecB_P.ClosedEp);stdError(MeanSpecB_P.ClosedEp)]');
g.patch.FaceColor = UMazeColors('safe');
g.patch.EdgeColor = UMazeColors('safe');
g.mainLine.Color= UMazeColors('safe')*0.6; 
g.mainLine.LineWidth= 2; 
hold on
g = shadedErrorBar(Spectro{3},nanmean(MeanSpecB_P.OpenEp),[stdError(MeanSpecB_P.OpenEp);stdError(MeanSpecB_P.OpenEp)]');
g.patch.FaceColor = UMazeColors('shock');
g.patch.EdgeColor = UMazeColors('shock');
g.mainLine.Color= UMazeColors('shock')*0.6; 
g.mainLine.LineWidth= 2; 
title('OB_PFC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Coherence')

subplot(2,3,5)
plot(Spectro{3},nanmean(MeanSpecH_P.ClosedEp),'color',UMazeColors('safe'),'linewidth',2),
hold on
plot(Spectro{3},nanmean(MeanSpecH_P.ClosedEp),'color',UMazeColors('shock'),'linewidth',2),
g = shadedErrorBar(Spectro{3},nanmean(MeanSpecH_P.ClosedEp),[stdError(MeanSpecH_P.ClosedEp);stdError(MeanSpecH_P.ClosedEp)]');
g.patch.FaceColor = UMazeColors('safe');
g.patch.EdgeColor = UMazeColors('safe');
g.mainLine.Color= UMazeColors('safe')*0.6; 
g.mainLine.LineWidth= 2; 
hold on
g = shadedErrorBar(Spectro{3},nanmean(MeanSpecH_P.OpenEp),[stdError(MeanSpecH_P.OpenEp);stdError(MeanSpecH_P.OpenEp)]');
g.patch.FaceColor = UMazeColors('shock');
g.patch.EdgeColor = UMazeColors('shock');
g.mainLine.Color= UMazeColors('shock')*0.6; 
g.mainLine.LineWidth= 2; 
title('HPC_PFC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Coherence')


figure
subplot(121)
stairs([1:0.1:12],runmean(nanmean(DistribFreqH.ClosedEp),2),'color',UMazeColors('safe'),'linewidth',2),hold on
stairs([1:0.1:12],runmean(nanmean(DistribFreqH.OpenEp),2),'color',UMazeColors('shock'),'linewidth',2),
legend('Safe','Shock')
xlabel('Frequency (Hz)'),ylabel('Counts - norm')
title('HPC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
subplot(122)
stairs([1:0.1:12],runmean(nanmean(DistribFreqB.ClosedEp),2),'color',UMazeColors('safe'),'linewidth',2),hold on
stairs([1:0.1:12],runmean(nanmean(DistribFreqB.OpenEp),2),'color',UMazeColors('shock'),'linewidth',2),
legend('Safe','Shock')
xlabel('Frequency (Hz)'),ylabel('Counts - norm')
title('OB')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
