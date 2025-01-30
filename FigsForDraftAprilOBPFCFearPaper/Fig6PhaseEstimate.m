clear all,
CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
numNeurons=[];
num=1;
StrucNames={'OB' 'HPC'}
KeepFirstSessionOnly=[1,5:length(Dir.path)];
Ep={'Fz','NoFz'};
FieldNames={'OB1','HPCLoc'};
nbin=30;

for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    clear FreezeEpoch MovAcctsd
    if exist('NeuronLFPCoupling/FzNeuronModFreqMiniMaxiPhaseCorrected_HPCLoc.mat')>0
        
        % Get Freeze and NoFreeze Epochs of equal length
        load('behavResources.mat')
        DurFz=sum(Stop(FreezeEpoch)-Start(FreezeEpoch));
        if exist('MovAcctsd')
            MovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),100));
        else
            MovAcctsd=Movtsd;
        end
        for i=1:100
            PrcVal=prctile(Data(MovAcctsd),i);
            LitEp=thresholdIntervals(MovAcctsd,PrcVal,'Direction','Above',PrcVal);
            LitEp=LitEp-FreezeEpoch;
            LitEp=dropShortIntervals(LitEp,3*1E4);
            DurNFztemp(i)=sum(Stop(LitEp)-Start(LitEp));
        end
        [vall,ind]=min(abs((DurNFztemp-DurFz)));
        PrcVal=prctile(Data(MovAcctsd),ind);
        NoFreezeEpoch=thresholdIntervals(MovAcctsd,PrcVal,'Direction','Above',PrcVal);
        NoFreezeEpoch=NoFreezeEpoch-FreezeEpoch;
        NoFreezeEpoch=dropShortIntervals(NoFreezeEpoch,3*1E4);
        MovEpoch=NoFreezeEpoch;
        
%         load('FilteredLFP/MiniMaxiLFPHPC1.mat')
%         load(['LFPData/LFP',num2str(channel),'.mat'])

        load('FilteredLFP/MiniMaxiLFPHPCLoc.mat')
        load(['LFPData/LocalHPCActivity.mat'])
        FilLFPP=FilterLFP(LFP,[1 15],1024);
        dat=Data(FilLFPP);
        tps=Range(LFP);
        Amp=interp1(AllPeaks(:,1),dat(ceil(AllPeaks(:,1)*1250)),Range(LFP,'s'));
        tps(isnan(Amp))=[];
        dat(isnan(Amp))=[];
        Amp(isnan(Amp))=[];
        Err=sqrt((Amp-dat).^2./(Amp+dat).^2);
        Errtsd=tsd(tps,Err);
        TotErr(num,1)=mean(Data(Restrict(Errtsd,MovEpoch)));
        TotErr(num,2)=mean(Data(Restrict(Errtsd,FreezeEpoch)));
        clear Err MovEpoch FreezeEpoch dat Amp tps
        
        load('FilteredLFP/MiniMaxiLFPOB1.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        close all
        load('behavResources.mat')
        load('StateEpochSB.mat','TotalNoiseEpoch')
        FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
        TotEpoch=intervalSet(0,max(Range(Movtsd)));
        MovEpoch=TotEpoch-FreezeEpoch;
        MovEpoch=MovEpoch-TotalNoiseEpoch;
        MovEpoch=dropShortIntervals(MovEpoch,3*1e4);
        FilLFPP=FilterLFP(LFP,[1 15],1024);
        dat=Data(FilLFPP);
        tps=Range(LFP);
        Amp=interp1(AllPeaks(:,1),dat(ceil(AllPeaks(:,1)*1250)),Range(LFP,'s'));
        tps(isnan(Amp))=[];
        dat(isnan(Amp))=[];
        Amp(isnan(Amp))=[];
        Err=sqrt((Amp-dat).^2./(Amp+dat).^2);
        Errtsd=tsd(tps,Err);
        TotErr(num,3)=mean(Data(Restrict(Errtsd,MovEpoch)));
        TotErr(num,4)=mean(Data(Restrict(Errtsd,FreezeEpoch)));
        num=num+1;
    end
end

figure
Cols1=[0,109,219;146,0,0]/263;
g=bar([1:4],mean(TotErr)); hold on
set(g,'FaceColor','w','EdgeColor','w')
plotSpread(TotErr,'distributionColors',{Cols1(2,:),Cols1(1,:),Cols1(2,:),Cols1(1,:)},'showMM',0)
[p(1),h,stats(1)]=signrank(TotErr(:,1),TotErr(:,2));
[p(2),h,stats(2)]=signrank(TotErr(:,3),TotErr(:,4));
sigstar({{1,2},{3,4}},p)
set(gca,'Layer','top','XTickLabel',{'Act','Fz','Act','Fz'},'Fontsize',15)
box off
ylabel('Mean square err')

cd /media/DataMOBS67/Project4Hz/Mouse402/FEAR-Mouse-402-EXT-24-envB_raye_161026_164106
figure
load('B_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
% clim([-0 6.5])
ylim([1 20])
load('FilteredLFP/MiniMaxiLFPOB1.mat')

frtemp=1./diff(AllPeaks(1:2:end,1))';
tpstemp=AllPeaks(1:2:end,1)*1E4;
tpstemp=tpstemp(1:length(frtemp));
FreqOBtsd=tsd(tpstemp,frtemp');
hold on,plot(Range(FreqOBtsd,'s'),runmean(Data(FreqOBtsd),5),'k')
xlim([630 750])
box off
set(gca,'XTick',[],'FontSize',20)

figure
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
clim([-0 6.5])
ylim([1 20])
load('FilteredLFP/MiniMaxiLFPOB1.mat')

frtemp=1./diff(AllPeaks(1:2:end,1))';
tpstemp=AllPeaks(1:2:end,1)*1E4;
tpstemp=tpstemp(1:length(frtemp));
FreqOBtsd=tsd(tpstemp,frtemp');
hold on,plot(Range(FreqOBtsd,'s'),runmean(Data(FreqOBtsd),5),'k')
xlim([0 800])
box off
set(gca,'XTick',[],'FontSize',20)



%% New Example
 % Get Freeze and NoFreeze Epochs of equal length
 clear all
 cd /media/DataMOBS67/Project4Hz/Mouse299/20151217-EXT-24h-envC
 load('behavResources.mat')
 DurFz=sum(Stop(FreezeEpoch)-Start(FreezeEpoch));
 if exist('MovAcctsd')
     MovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),100));
 else
     MovAcctsd=Movtsd;
 end
 for i=1:100
     PrcVal=prctile(Data(MovAcctsd),i);
     LitEp=thresholdIntervals(MovAcctsd,PrcVal,'Direction','Above',PrcVal);
     LitEp=LitEp-FreezeEpoch;
     LitEp=dropShortIntervals(LitEp,3*1E4);
     DurNFztemp(i)=sum(Stop(LitEp)-Start(LitEp));
 end
 [vall,ind]=min(abs((DurNFztemp-DurFz)));
 PrcVal=prctile(Data(MovAcctsd),ind);
 NoFreezeEpoch=thresholdIntervals(MovAcctsd,PrcVal,'Direction','Above',PrcVal);
 NoFreezeEpoch=NoFreezeEpoch-FreezeEpoch;
 NoFreezeEpoch=dropShortIntervals(NoFreezeEpoch,3*1E4);
 MovEpoch=NoFreezeEpoch;
        
 figure
load('B_Low_Spectrum.mat')
subplot(211)
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
ylim([1 20])
load('FilteredLFP/MiniMaxiLFPOB1.mat')
frtemp=1./diff(AllPeaks(1:2:end,1))';
tpstemp=AllPeaks(1:2:end,1)*1E4;
tpstemp=tpstemp(1:length(frtemp));
FreqOBtsd=tsd(tpstemp,frtemp');
hold on,plot(Range(FreqOBtsd,'s'),runmean(Data(FreqOBtsd),5),'k')
line([0 1500],[15 15],'linewidth',10,'color','w')
movstart=Start(MovEpoch);
movstop=Stop(MovEpoch);
for k=1:length(movstart)
    line([movstart(k)/1e4 movstop(k)/1e4],[15 15],'color','r','linewidth',5);
end

freezestart=Start(FreezeEpoch);
freezestop=Stop(FreezeEpoch);
for k=1:length(freezestart)
    line([freezestart(k)/1e4 freezestop(k)/1e4],[15 15],'color','b','linewidth',5);
end
xlim([300 800])
box off
set(gca,'XTick',[],'FontSize',20)

subplot(212)
plot(Range(MovAcctsd,'s'),Data(MovAcctsd),'k','linewidth',2), hold on
% for s=1:length(Start(MovEpoch))
% plot(Range(Restrict(MovAcctsd,subset(MovEpoch,s)),'s'),Data(Restrict(MovAcctsd,subset(MovEpoch,s))),'r','linewidth',3)
% end
% for s=1:length(Start(FreezeEpoch))
% plot(Range(Restrict(MovAcctsd,subset(FreezeEpoch,s)),'s'),Data(Restrict(MovAcctsd,subset(FreezeEpoch,s))),'b','linewidth',3)
% end
line([0 1500],[15 15],'linewidth',10,'color','w')
movstart=Start(MovEpoch);
movstop=Stop(MovEpoch);
for k=1:length(movstart)
    line([movstart(k)/1e4 movstop(k)/1e4],[1.8 1.8]*1e8,'color','r','linewidth',5);
end

freezestart=Start(FreezeEpoch);
freezestop=Stop(FreezeEpoch);
for k=1:length(freezestart)
    line([freezestart(k)/1e4 freezestop(k)/1e4],[1.8 1.8]*1e8,'color','b','linewidth',5);
end
line(xlim,[PrcVal PrcVal],'color','r','linestyle',':','linewidth',2)
line(xlim,[th_immob_Acc th_immob_Acc],'color','b','linestyle',':','linewidth',2)

xlim([300 800])
box off
set(gca,'XTick',[],'FontSize',20)


%%
figure
X = TotErr(:,3);
a=iosr.statistics.boxPlot(1,X,'boxColor',[1 0.9 0.9],'lineColor',[1 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',1,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread(X,'distributionColors',[1,0.6,0.6],'xValues',1,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',15)

X = TotErr(:,4);
a=iosr.statistics.boxPlot(2,X,'boxColor',[0.9 0.9 1],'lineColor',[0.9 0.9 1],'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',2,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,1],'xValues',2,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',15)
xlim([0.5 2.5])
ylim([0 6])
set(gca,'FontSize',18,'XTick',[1,2],'linewidth',1.5,'XTickLabel',{'Act','Fz'})
ylabel('Mean square error')
box off