clear all
Dir=PathForExperimentFEAR('Fear-electrophy-opto-for-paper');


FolderName='FilteredLFP';
OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 12];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;


for dd = 1 : 3 : length(Dir.path)
    
    cd(Dir.path{dd})
    disp(Dir.path{dd})
    load('ExpeInfo.mat')
    
    MouseGroup{((dd-1)/3)+1} = ExpeInfo.group;
    
%         mkdir(FolderName)
%         % Belluscio methd
%         load('ChannelsToAnalyse/Bulb_deep.mat')
%         load(['LFPData/LFP',num2str(channel),'.mat'])
%         % MiniMaxi
%         Signal=LFP;
%         AllPeaks=FindPeaksForFrequency(Signal,OptionsMiniMaxi,0);
%         AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
%         Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(Signal,'s'));
%         if AllPeaks(1,2)==1
%             PhaseInterpol=tsd(Range(Signal),mod(Y,2*pi));
%         else
%             PhaseInterpol=tsd(Range(Signal),mod(Y+pi,2*pi));
%         end
%         save([FolderName,'/MiniMaxiLFP_Bulb_deep.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
%         clear AllPeaks PhaseInterpol LFP Signal channel
    
    LaserChans = find(strcmp(ExpeInfo.DigID,'Laser'));
    
    StimTimes = [];
    for ll = 1:length(LaserChans)
        
        load(['LFPData/DigInfo',num2str(LaserChans(ll)),'.mat'],'DigTSD')
        Stims = thresholdIntervals(DigTSD,0.9,'Direction','Above');
        StimTimes = [StimTimes;Start(Stims)];
        
    end
    StimTimes = sort(StimTimes);
    StimTimes(StimTimes<100*1e4) = [];
    StimTimes(StimTimes>700*1e4) = [];
    length(StimTimes)
%     
%     clear MovAcctsd
%     load('behavResources.mat')
%     
%     [M,T] = PlotRipRaw(MovAcctsd,StimTimes/1e4,60000,0,0);
%     AcceleroResp(((dd-1)/3)+1,:) = M(:,2)';
%     TimeAcc = M(:,1);
%     
%     load('LFPData/LFP32.mat')
%     [M,T] = PlotRipRaw(LFP,StimTimes/1e4,60000,0,0);
%     LaserResp(((dd-1)/3)+1,:) = M(:,2)';
%     
%     load('B_Low_Spectrum.mat')
%     is = intervalSet(StimTimes-20*1e4, StimTimes+60*1e4);
%     sweeps = intervalSplit(tsd(Spectro{2}*1e4,log(Spectro{1})), is, 'OffsetStart', Start(is)*0);
%     ToAv = Data(sweeps{1});
%     for st = 2:length(StimTimes)-1
%         ToAv = ToAv+Data(sweeps{st});
%     end
%     AllSpec{((dd-1)/3)+1} = ToAv/length(StimTimes);
%     
%     StimEpoch = intervalSet(StimTimes,(StimTimes+45*1e4));
%     MeanSpec_Stim(((dd-1)/3)+1,:) = nanmean((Data(Restrict(tsd(Spectro{2}*1e4,log(Spectro{1})),StimEpoch))));
%     NoStimEpoch = intervalSet(StimTimes-25*1e4,(StimTimes-1*1e4));
%     MeanSpec_NoStim(((dd-1)/3)+1,:) = nanmean((Data(Restrict(tsd(Spectro{2}*1e4,log(Spectro{1})),NoStimEpoch))));
%     
%     
%     load([FolderName,'/MiniMaxiLFP_Bulb_deep.mat']')
%     %         keyboard
%     PeakDiff = tsd(AllPeaks(:,1)*1e4,0.5*[0;1./diff(AllPeaks(:,1))]);
%     for pres = 1:7
%     MeanFreq_Stim(((dd-1)/3)+1,pres,:) = hist(Data(Restrict(PeakDiff,subset(StimEpoch,pres))),[0:0.3:15]);
%     MeanFreq_NoStim(((dd-1)/3)+1,pres,:) = hist(Data(Restrict(PeakDiff,subset(NoStimEpoch,pres))),[0:0.3:15]);
%     end
%       
%      StimEpoch = intervalSet(StimTimes(1),(StimTimes(1)+45*1e4));
%     MeanSpec_StimFirst(((dd-1)/3)+1,:) = nanmean((Data(Restrict(tsd(Spectro{2}*1e4,log(Spectro{1})),StimEpoch))));
%     NoStimEpoch = intervalSet(StimTimes(1)-25*1e4,(StimTimes(1)-1*1e4));
%     MeanSpec_NoStimmFirst(((dd-1)/3)+1,:) = nanmean((Data(Restrict(tsd(Spectro{2}*1e4,log(Spectro{1})),NoStimEpoch))));
%     
% 
%     PeakDiff = tsd(Range(LFP),interp1(Range(PeakDiff),Data(PeakDiff),Range(LFP)));
%     [M,T] = PlotRipRaw(PeakDiff,StimTimes/1e4,60000,0,0);
%     MeanFreqTriggered(((dd-1)/3)+1,:) = M(:,2);
%     
    
end

%% Check no movement reaction
figure
[hl,hp]=boundedline(TimeAcc,runmean(nanmean(AcceleroResp(1:7,:)),10),[stdError(AcceleroResp(1:7,:));stdError(AcceleroResp(1:7,:))]','alpha'),hold on
set(hl,'Color',[0.4 1 0.4]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 1 0.4])
hold on
[hl,hp]=boundedline(TimeAcc,runmean(nanmean(AcceleroResp(8:end,:)),10),[stdError(AcceleroResp(8:end,:));stdError(AcceleroResp(8:end,:))]','alpha'),hold on
set(hl,'Color',[0.4 0.4 1]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 0.4 1])
ylim([1 18]*1e7)
line([0 0],ylim,'color','k','linewidth',3)
line([0 45],[16 16]*1e7,'color','c','linewidth',5)
xlabel('Time to laser on (s)')
ylabel('Accelerometer activity (AU)')
set(gca,'FontSize',14,'LineWidth',1.5)
line(xlim,[2.2 2.2]*1e7,'color',[0.6 0.6 0.6],'linestyle',':','linewidth',2)
line(xlim,[8.6 8.6]*1e7,'color',[0.6 0.6 0.6],'linestyle',':','linewidth',2)

figure
GFP_Stim = nanmean(AcceleroResp(1:7,3000:end)')
CHR2_Stim = nanmean(AcceleroResp(8:end,3000:end)')

a=iosr.statistics.boxPlot(1,(GFP_Stim)','boxColor',[0.4 1 0.4],'lineColor',[0.4 1 0.4]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;
hold on
a=iosr.statistics.boxPlot(2,(CHR2_Stim)','boxColor',[0.4 0.4 1],'lineColor',[0.4 0.4 1]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;


xlim([0 3])

handlesplot=plotSpread(GFP_Stim','distributionColors','k','xValues',1,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(GFP_Stim','distributionColors',[0.6,1,0.6]*0.5,'xValues',1,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)
handlesplot=plotSpread(CHR2_Stim','distributionColors','k','xValues',2,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(CHR2_Stim','distributionColors',[0.6,0.6,1]*0.5,'xValues',2,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)

set(gca,'XTick',[1 2],'XTickLabel',{'GFP','CHR2'},'FontSize',15,'linewidth',1.5)
ylabel('Inst Acceleration')



figure
for k = 1:14
    subplot(2,7,k)
    imagesc(1:400,Spectro{3},AllSpec{k}'), axis xy
    title(MouseGroup{k})
    xlabel('Time to laser on (s)')
end

clear AllSpecNorm_CHR2
for k = 8:14
    AllSpecNorm_CHR2(k-7,:,:) = AllSpec{k}./(repmat(nanmean(AllSpec{k}(1:20,:),1),100,1));
end



    
clear AllSpecNorm_GFP
for k = 1:7
    AllSpecNorm_GFP(k,:,:) = AllSpec{k}./(repmat(nanmean(AllSpec{k}(1:20,:),1),100,1));
end
% AllSpecNorm_GFP = AllSpecNorm_GFP([2,4,5,6,7],:,:);
figure
subplot(211)
imagesc(TimeAcc,Spectro{3},squeeze(nanmean(AllSpecNorm_CHR2))')
axis xy
clim([0.96 1.12])
title('CHR2')
xlabel('Time to laser on (s)')
ylabel('Frequency (Hz)')
set(gca,'FontSize',14,'LineWidth',1.5)
box off
subplot(212)
imagesc(TimeAcc,Spectro{3},squeeze(nanmean(AllSpecNorm_GFP))')
axis xy
clim([0.96 1.12])
title('GFP')
xlabel('Time to laser on (s)')
ylabel('Frequency (Hz)')
set(gca,'FontSize',14,'LineWidth',1.5)
box off


figure
subplot(121)
plot([-1 0],[-1 0],'color',[0.4 1 0.4],'linewidth',3)
hold on
plot([-1 0],[-1 0],'color',[0.4 0.4 1],'linewidth',3)
X = ((MeanSpec_StimFirst([2,4:7],:))) - ((MeanSpec_NoStimmFirst([2,4:7],:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 1 0.4]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 1 0.4])
hold on
X = ((MeanSpec_StimFirst(8:end,:))) - ((MeanSpec_NoStimmFirst(8:end,:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 0.4 1]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 0.4 1])
xlabel('Frequency (Hz)')
ylabel('Spec Stim - Spec No Stim')
set(gca,'FontSize',14,'LineWidth',1.5)
box off
title('only first stim')
legend('GFP','CHR2')
xlim([0 20])

subplot(122)
X = ((MeanSpec_Stim([2,4:7],:))) - ((MeanSpec_NoStim([2,4:7],:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 1 0.4]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 1 0.4])
hold on
X = ((MeanSpec_Stim(8:end,:))) - ((MeanSpec_NoStim(8:end,:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 0.4 1]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 0.4 1])
xlabel('Frequency (Hz)')
ylabel('Spec Stim - Spec No Stim')
set(gca,'FontSize',14,'LineWidth',1.5)
box off
title('all stims')



% Make a bar plot with this
GFP_Stim = nanmean(((MeanSpec_Stim([1:7],find(Spectro{3}<9,1,'last'):find(Spectro{3}<11,1,'last'))))')./nanmean(nanmean(nanmean(((MeanSpec_Stim([1:7]))))));
GFP_NoStim = nanmean(((MeanSpec_NoStim([1:7],find(Spectro{3}<9,1,'last'):find(Spectro{3}<11,1,'last'))))')./nanmean(nanmean(nanmean(((MeanSpec_NoStim([1:7]))))));

CHR2_Stim = nanmean(((MeanSpec_Stim(8:end,find(Spectro{3}<9,1,'last'):find(Spectro{3}<11,1,'last'))))')./nanmean(nanmean(nanmean(((MeanSpec_Stim(8:end))))));
CHR2_NoStim = nanmean(((MeanSpec_NoStim(8:end,find(Spectro{3}<9,1,'last'):find(Spectro{3}<11,1,'last'))))')./nanmean(nanmean(nanmean(((MeanSpec_NoStim(8:end))))));


a=iosr.statistics.boxPlot(1,(GFP_NoStim)','boxColor',[0.4 1 0.4],'lineColor',[0.4 1 0.4]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;
hold on
a=iosr.statistics.boxPlot(2,(CHR2_NoStim)','boxColor',[0.4 0.4 1],'lineColor',[0.4 0.4 1]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;
hold on
a=iosr.statistics.boxPlot(4,(GFP_Stim)','boxColor',[0.4 1 0.4],'lineColor',[0.4 1 0.4]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;
hold on
a=iosr.statistics.boxPlot(5,(CHR2_Stim)','boxColor',[0.4 0.4 1],'lineColor',[0.4 0.4 1]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;


xlim([0 6])

handlesplot=plotSpread(GFP_NoStim','distributionColors','k','xValues',1,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(GFP_NoStim','distributionColors',[0.6,1,0.6]*0.5,'xValues',1,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)
handlesplot=plotSpread(CHR2_NoStim','distributionColors','k','xValues',2,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(CHR2_NoStim','distributionColors',[0.6,0.6,1]*0.5,'xValues',2,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)

handlesplot=plotSpread(GFP_Stim','distributionColors','k','xValues',4,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(GFP_Stim','distributionColors',[0.6,1,0.6]*0.5,'xValues',4,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)
handlesplot=plotSpread(CHR2_Stim','distributionColors','k','xValues',5,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(CHR2_Stim','distributionColors',[0.6,0.6,1]*0.5,'xValues',5,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)

set(gca,'XTick',[1.5,4.5],'XTickLabel',{'No Stim','Stim'},'FontSize',15,'linewidth',1.5)
ylabel('Power in 9-11Hz band')


%% Look at histogram of breath times
MeanFreq_StimNorm = MeanFreq_Stim./repmat(nansum(MeanFreq_Stim')',1,51);
MeanFreq_NoStimNorm = MeanFreq_NoStim./repmat(nansum(MeanFreq_NoStim')',1,51);

subplot(211)
[hl,hp]=boundedline([0:0.3:15],nanmean(MeanFreq_NoStimNorm(1:7,:)),[stdError(MeanFreq_NoStimNorm(1:7,:));stdError(MeanFreq_NoStimNorm(1:7,:))]','alpha'),hold on
set(hl,'Color',[0.4 1 0.4]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 1 0.4])
hold on
[hl,hp]=boundedline([0:0.3:15],nanmean(MeanFreq_NoStimNorm(8:end,:)),[stdError(MeanFreq_NoStimNorm(8:end,:));stdError(MeanFreq_NoStimNorm(8:end,:))]','alpha'),hold on
set(hl,'Color',[0.4 0.4 1]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 0.4 1])
xlabel('Sniff frequency')
ylabel('Prop')
title('No Stim')

subplot(212)
[hl,hp]=boundedline([0:0.3:15],nanmean(MeanFreq_StimNorm(1:7,:)),[stdError(MeanFreq_StimNorm(1:7,:));stdError(MeanFreq_StimNorm(1:7,:))]','alpha'),hold on
set(hl,'Color',[0.4 1 0.4]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 1 0.4])
hold on
[hl,hp]=boundedline([0:0.3:15],nanmean(MeanFreq_StimNorm(8:end,:)),[stdError(MeanFreq_StimNorm(8:end,:));stdError(MeanFreq_StimNorm(8:end,:))]','alpha'),hold on
set(hl,'Color',[0.4 0.4 1]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 0.4 1])
set(gca,'FontSize',15,'linewidth',1.5)
xlabel('Sniff frequency')
ylabel('Prop')
title('')


figure
StartBand =find([0:0.3:15]>9,1,'first');
StopBand =find([0:0.3:15]>11,1,'first');

GFP_NoStim = nanmean(MeanFreq_NoStimNorm(1:7,StartBand:StopBand));
CHR2_NoStim = nanmean(MeanFreq_NoStimNorm(8:end,StartBand:StopBand));


GFP_Stim = nanmean(MeanFreq_StimNorm(1:7,StartBand:StopBand));
CHR2_Stim = nanmean(MeanFreq_StimNorm(8:end,StartBand:StopBand));

a=iosr.statistics.boxPlot(1,(GFP_NoStim)','boxColor',[0.4 1 0.4],'lineColor',[0.4 1 0.4]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;
hold on
a=iosr.statistics.boxPlot(2,(CHR2_NoStim)','boxColor',[0.4 0.4 1],'lineColor',[0.4 0.4 1]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;
hold on
a=iosr.statistics.boxPlot(4,(GFP_Stim)','boxColor',[0.4 1 0.4],'lineColor',[0.4 1 0.4]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;
hold on
a=iosr.statistics.boxPlot(5,(CHR2_Stim)','boxColor',[0.4 0.4 1],'lineColor',[0.4 0.4 1]*0.8,'medianColor','k','boxWidth',0.5)
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;


xlim([0 6])

handlesplot=plotSpread(GFP_NoStim','distributionColors','k','xValues',1,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(GFP_NoStim','distributionColors',[0.6,1,0.6]*0.5,'xValues',1,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)
handlesplot=plotSpread(CHR2_NoStim','distributionColors','k','xValues',2,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(CHR2_NoStim','distributionColors',[0.6,0.6,1]*0.5,'xValues',2,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)

handlesplot=plotSpread(GFP_Stim','distributionColors','k','xValues',4,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(GFP_Stim','distributionColors',[0.6,1,0.6]*0.5,'xValues',4,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)
handlesplot=plotSpread(CHR2_Stim','distributionColors','k','xValues',5,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(CHR2_Stim','distributionColors',[0.6,0.6,1]*0.5,'xValues',5,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)

set(gca,'XTick',[1.5,4.5],'XTickLabel',{'No Stim','Stim'},'FontSize',15,'linewidth',1.5)
ylabel('Prop of breaths in sniffing range')

[p1,h] = ranksum(GFP_NoStim,CHR2_NoStim);
[p2,h] = ranksum(GFP_Stim,CHR2_Stim);
sigstar({[1,2],[4,5]},[p1,p2])

figure
subplot(121)
plot([-1 0],[-1 0],'color',[0.4 1 0.4],'linewidth',3)
hold on
plot([-1 0],[-1 0],'color',[0.4 0.4 1],'linewidth',3)
X = ((MeanSpec_NoStim([2,4:7],:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 1 0.4]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 1 0.4])
hold on
X = ((MeanSpec_NoStim(8:end,:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 0.4 1]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 0.4 1])
xlabel('Frequency (Hz)')
ylabel('Spec Stim - Spec No Stim')
set(gca,'FontSize',14,'LineWidth',1.5)
box off
title('Before stim')
xlim([0 20])
legend('GFP','CHR2')

subplot(122)
X = ((MeanSpec_Stim([2,4:7],:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 1 0.4]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 1 0.4])
hold on
X = ((MeanSpec_Stim(8:end,:)));
[hl,hp]=boundedline(Spectro{3},nanmean(X),[stdError(X);stdError(X)]','alpha'),hold on
set(hl,'Color',[0.4 0.4 1]*0.8,'linewidth',0.2)
set(hp,'FaceColor',[0.4 0.4 1])
xlabel('Frequency (Hz)')
ylabel('Spec Stim - Spec No Stim')
set(gca,'FontSize',14,'LineWidth',1.5)
box off
title('During stim')



figure
subplot(211)
errorbar([0:0.3:15],nanmean((MeanFreq_NoStim(1:6,:))),stdError((MeanFreq_NoStim(1:6,:))))
hold on
errorbar([0:0.3:15],nanmean((MeanFreq_NoStim(8:end,:))),stdError((MeanFreq_NoStim(8:end,:))))

subplot(212)
errorbar([0:0.3:15],nanmean((MeanFreq_Stim(1:6,:))),stdError((MeanFreq_Stim(1:6,:))))
hold on
errorbar([0:0.3:15],nanmean((MeanFreq_Stim(8:end,:))),stdError((MeanFreq_Stim(8:end,:))))

figure
subplot(211)
errorbar(M(:,1),nanmean((MeanFreq_NoStim(1:6,:))),stdError((MeanFreq_NoStim(1:6,:))))
hold on
errorbar(M(:,1),nanmean((MeanFreq_NoStim(8:end,:))),stdError((MeanFreq_NoStim(8:end,:))))

subplot(212)
errorbar(M(:,1),nanmean((MeanFreqTriggered(1:6,:))),stdError((MeanFreqTriggered(1:6,:))))
hold on
errorbar(M(:,1),nanmean((MeanFreqTriggered(8:end,:))),stdError((MeanFreqTriggered(8:end,:))))
