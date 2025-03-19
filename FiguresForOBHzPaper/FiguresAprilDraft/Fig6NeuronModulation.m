% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEARMac('Fear-electrophy');
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
        Epochs{1}=FreezeEpoch;
        Epochs{2}=NoFreezeEpoch;
        % Load data
        HPCData=load('NeuronLFPCoupling/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_HPCLoc.mat');
        OBData=load('NeuronLFPCoupling/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat');
        HPCPhase=load('FilteredLFP/MiniMaxiLFPHPCLoc.mat');
        OBPhase=load('FilteredLFP/MiniMaxiLFPOB1.mat');
        load('SpikeClassification.mat')
        frtemp=1./diff(HPCPhase.AllPeaks(1:2:end,1))';
        tpstemp=HPCPhase.AllPeaks(1:2:end,1)*1E4;
        tpstemp=tpstemp(1:length(frtemp));
        FreqHPCtsd=tsd(tpstemp,frtemp');
        frtemp=1./diff(OBPhase.AllPeaks(1:2:end,1))';
        tpstemp=OBPhase.AllPeaks(1:2:end,1)*1E4;
        tpstemp=tpstemp(1:length(frtemp));
        FreqOBtsd=tsd(tpstemp,frtemp');
        
        % Get neuron names
        load('SpikeData.mat')
            numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        
        for cc=1:length(chans)
            for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
                if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                    numtt=[numtt,tt];
                end
            end
        end
        
        numNeurons=[]; % neurones du PFCx
        for i=1:length(S);
            if ismember(TT{i}(1),numtt)
                numNeurons=[numNeurons,i];
            end
        end
        
        numMUA=[];
        for k=1:length(numNeurons)
            j=numNeurons(k);
            if TT{j}(2)==1
                numMUA=[numMUA, k];
            end
        end
        numNeurons(numMUA)=[];
        load('MeanWaveform.mat')

        
        for neur=1:length(HPCData.PhasesSpikes.Real)
            Phasetsd.HPC=tsd(HPCData.Tps{neur},HPCData.PhasesSpikes.Real{neur}.Transf);
            Phasetsd.OB=tsd(OBData.Tps{neur},OBData.PhasesSpikes.Real{neur}.Transf);
            PhasetsdNT.HPC=tsd(HPCData.Tps{neur},HPCData.PhasesSpikes.Real{neur}.Nontransf);
            PhasetsdNT.OB=tsd(OBData.Tps{neur},OBData.PhasesSpikes.Real{neur}.Nontransf);
            for ep=1:2
                NumSpikesEp(ep)=length(Data(Restrict(Phasetsd.HPC,Epochs{ep})));
            end
            NewNumSpikes=min(NumSpikesEp);
            PhaseMeasures.ID(num)=WfId(neur);
            PhaseMeasures.FreqHPCFz(num)=mean(Data(Restrict(FreqHPCtsd,FreezeEpoch)));
            PhaseMeasures.FreqHPCNoFz(num)=mean(Data(Restrict(FreqHPCtsd,NoFreezeEpoch)));
            PhaseMeasures.FreqOBFz(num)=mean(Data(Restrict(FreqOBtsd,FreezeEpoch)));
            PhaseMeasures.FreqOBNoFz(num)=mean(Data(Restrict(FreqOBtsd,NoFreezeEpoch)));
            PhaseMeasures.Overall{num}=NumSpikesEp;
            PhaseMeasures.FzDur{num}=sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
            PhaseMeasures.NoFzDur{num}=sum(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'));
            PhaseMeasures.Params(num,:)=Params{numNeurons(neur)};
            PhaseMeasures.InfoMouse(num)=mm;
            PhaseMeasures.InfoNeur(num)=neur;
            if NumSpikesEp(1)<NumSpikesEp(2)
                % Freezing has less spikes so downsample no freezing
                PhaseMeasures.HPC.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{1})),0,0);
                PhaseMeasures.OB.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{1})),0,0);
                PhaseMeasures.HPC.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{2})),100,NewNumSpikes);
                PhaseMeasures.OB.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{2})),100,NewNumSpikes);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.HPC,Epochs{1})),0,0);
                [PhaseMeasures.HPC.Fz{num}.Jit,PhaseMeasures.HPC.Fz{num}.Jitdist]=TemporalJitterPhaseLocking(HPCPhase.PhaseInterpol,PhasetsdNT.HPC,Epochs{1},temp.mu,0,0);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.OB,Epochs{1})),0,0);
                [PhaseMeasures.OB.Fz{num}.Jit,PhaseMeasures.OB.Fz{num}.Jitdist]=TemporalJitterPhaseLocking(OBPhase.PhaseInterpol,PhasetsdNT.OB,Epochs{1},temp.mu,0,0);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.HPC,Epochs{2})),0,0);
                [PhaseMeasures.HPC.NoFz{num}.Jit,PhaseMeasures.HPC.NoFz{num}.Jitdist]=TemporalJitterPhaseLocking(HPCPhase.PhaseInterpol,PhasetsdNT.HPC,Epochs{2},temp.mu,100,NewNumSpikes);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.OB,Epochs{2})),0,0);
                [PhaseMeasures.OB.NoFz{num}.Jit,PhaseMeasures.OB.NoFz{num}.Jitdist]=TemporalJitterPhaseLocking(OBPhase.PhaseInterpol,PhasetsdNT.OB,Epochs{2},temp.mu,100,NewNumSpikes);
            else
                PhaseMeasures.HPC.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{1})),100,NewNumSpikes);
                PhaseMeasures.OB.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{1})),100,NewNumSpikes);
                PhaseMeasures.HPC.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{2})),0,0);
                PhaseMeasures.OB.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{2})),0,0);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.HPC,Epochs{1})),0,0);
                [PhaseMeasures.HPC.Fz{num}.Jit,PhaseMeasures.HPC.Fz{num}.Jitdist]=TemporalJitterPhaseLocking(HPCPhase.PhaseInterpol,PhasetsdNT.HPC,Epochs{1},temp.mu,100,NewNumSpikes);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.OB,Epochs{1})),0,0);
                [PhaseMeasures.OB.Fz{num}.Jit,PhaseMeasures.OB.Fz{num}.Jitdist]=TemporalJitterPhaseLocking(OBPhase.PhaseInterpol,PhasetsdNT.OB,Epochs{1},temp.mu,100,NewNumSpikes);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.HPC,Epochs{2})),0,0);
                [PhaseMeasures.HPC.NoFz{num}.Jit,PhaseMeasures.HPC.NoFz{num}.Jitdist]=TemporalJitterPhaseLocking(HPCPhase.PhaseInterpol,PhasetsdNT.HPC,Epochs{2},temp.mu,0,0);
                temp=GetPhaseStatistics(Data(Restrict(PhasetsdNT.OB,Epochs{2})),0,0);
                [PhaseMeasures.OB.NoFz{num}.Jit,PhaseMeasures.OB.NoFz{num}.Jitdist]=TemporalJitterPhaseLocking(OBPhase.PhaseInterpol,PhasetsdNT.OB,Epochs{2},temp.mu,0,0);
            end
            
%             fig=figure;
%             numBins=20;
%             subplot(221)
%             [Count,Phase]=hist(Data(Restrict(Phasetsd.OB,Epochs{1})),numBins);Count=100*Count/sum(Count);
%             bar([[2*pi/numBins:2*pi/numBins:2*pi],[2*pi/numBins:2*pi/numBins:2*pi]+2*pi]-2*pi/12,[Count,Count],'FaceColor',[0.4 0.4 0.4],'EdgeColor',[0.6 0.6 0.6])
%             xlim([0 4*pi-2*pi/numBins])
%             FR=length(Data(Restrict(Phasetsd.OB,Epochs{1})))./PhaseMeasures.FzDur{num};
%             text(0.3,max(ylim)*0.8,num2str(FR),'color','r')
%             title('OB-FZ')
%             subplot(223)
%             [Count,Phase]=hist(Data(Restrict(Phasetsd.OB,Epochs{2})),numBins);Count=100*Count/sum(Count);
%             bar([[2*pi/numBins:2*pi/numBins:2*pi],[2*pi/numBins:2*pi/numBins:2*pi]+2*pi]-2*pi/12,[Count,Count],'FaceColor',[0.4 0.4 0.4],'EdgeColor',[0.6 0.6 0.6])
%             xlim([0 4*pi-2*pi/numBins])
%             FR=length(Data(Restrict(Phasetsd.OB,Epochs{2})))./PhaseMeasures.NoFzDur{num};
%             text(0.3,max(ylim)*0.8,num2str(FR),'color','r')
%             title('OB-NoFZ')
%             subplot(222)
%             [Count,Phase]=hist(Data(Restrict(Phasetsd.HPC,Epochs{1})),numBins);Count=100*Count/sum(Count);
%             bar([[2*pi/numBins:2*pi/numBins:2*pi],[2*pi/numBins:2*pi/numBins:2*pi]+2*pi]-2*pi/12,[Count,Count],'FaceColor',[0.4 0.4 0.4],'EdgeColor',[0.6 0.6 0.6])
%             xlim([0 4*pi-2*pi/numBins])
%             FR=length(Data(Restrict(Phasetsd.HPC,Epochs{1})))./PhaseMeasures.FzDur{num};
%             text(0.3,max(ylim)*0.8,num2str(FR),'color','r')
%             title('HPC-FZ')
%             subplot(224)
%             [Count,Phase]=hist(Data(Restrict(Phasetsd.HPC,Epochs{2})),numBins);Count=100*Count/sum(Count);
%             bar([[2*pi/numBins:2*pi/numBins:2*pi],[2*pi/numBins:2*pi/numBins:2*pi]+2*pi]-2*pi/12,[Count,Count],'FaceColor',[0.4 0.4 0.4],'EdgeColor',[0.6 0.6 0.6])
%             xlim([0 4*pi-2*pi/numBins])
%             FR=length(Data(Restrict(Phasetsd.HPC,Epochs{2})))./PhaseMeasures.NoFzDur{num};
%             text(0.3,max(ylim)*0.8,num2str(FR),'color','r')
%             title('HPC-NoFZ')
%             saveas(fig,['/Volumes/My Passport/Project4Hz/ExampleFigs/Neuron',num2str(num),'.png']);
%             saveas(fig,['/Volumes/My Passport/Project4Hz/ExampleFigs/Neuron',num2str(num),'.fig']);

            num=num+1;
        end
    end
end



close all,
load(['/Users/sophiebagur/Dropbox/PrgMatlab/WaveFormLibrary.mat'])
% Add library WF Data
ClusterData=[AllData2(:,1:3);PhaseMeasures.Params];
ClusterData(:,1)=ClusterData(:,1)./(max(ClusterData(:,1))-min(ClusterData(:,1)));
ClusterData(:,2)=ClusterData(:,2)./(max(ClusterData(:,2))-min(ClusterData(:,2)));
ClusterData(:,3)=ClusterData(:,3)./(max(ClusterData(:,3))-min(ClusterData(:,3)));

AllWfId=kmeans(ClusterData(:,1:3),2);
% Identify the PN cell group as the most numerous one
NumofOnes=sum(AllWfId==1)/length(AllWfId);
if NumofOnes>0.5
    AllWfId(AllWfId==1)=1;
    AllWfId(AllWfId==2)=-1;
else
    AllWfId(AllWfId==1)=-1;
    AllWfId(AllWfId==2)=1;
end
PhaseMeasures.ID=AllWfId(end-length(PhaseMeasures.Params)+1:end);

%%%
cd('/Volumes/My Passport/Project4Hz')
load('PhaseMeasures.mat')

num=100;
for nn=1:num
    AllKappa(1,nn)=PhaseMeasures.HPC.Fz{nn}.Kappa;
    AllKappa(2,nn)=PhaseMeasures.HPC.NoFz{nn}.Kappa;
    AllKappa(3,nn)=PhaseMeasures.OB.Fz{nn}.Kappa;
    AllKappa(4,nn)=PhaseMeasures.OB.NoFz{nn}.Kappa;
    AllRmean(1,nn)=PhaseMeasures.HPC.Fz{nn}.Rmean;
    AllRmean(2,nn)=PhaseMeasures.HPC.NoFz{nn}.Rmean;
    AllRmean(3,nn)=PhaseMeasures.OB.Fz{nn}.Rmean;
    AllRmean(4,nn)=PhaseMeasures.OB.NoFz{nn}.Rmean;
    AllPwPC(1,nn)=sqrt(abs(PhaseMeasures.HPC.Fz{nn}.PwPC));
    AllPwPC(2,nn)=sqrt(abs(PhaseMeasures.HPC.NoFz{nn}.PwPC));
    AllPwPC(3,nn)=sqrt(abs(PhaseMeasures.OB.Fz{nn}.PwPC));
    AllPwPC(4,nn)=sqrt(abs(PhaseMeasures.OB.NoFz{nn}.PwPC));
    Allmu(1,nn)=PhaseMeasures.HPC.Fz{nn}.mu;
    Allmu(2,nn)=PhaseMeasures.HPC.NoFz{nn}.mu;
    Allmu(3,nn)=PhaseMeasures.OB.Fz{nn}.mu;
    Allmu(4,nn)=PhaseMeasures.OB.NoFz{nn}.mu;
    Allpval(1,nn)=PhaseMeasures.HPC.Fz{nn}.pval;
    Allpval(2,nn)=PhaseMeasures.HPC.NoFz{nn}.pval;
    Allpval(3,nn)=PhaseMeasures.OB.Fz{nn}.pval;
    Allpval(4,nn)=PhaseMeasures.OB.NoFz{nn}.pval;
    AllJit(1,nn)=PhaseMeasures.HPC.Fz{nn}.Jit*PhaseMeasures.FreqHPCFz(i);
    AllJit(2,nn)=PhaseMeasures.HPC.NoFz{nn}.Jit*PhaseMeasures.FreqHPCNoFz(i);
    AllJit(3,nn)=PhaseMeasures.OB.Fz{nn}.Jit*PhaseMeasures.FreqOBFz(i);
    AllJit(4,nn)=PhaseMeasures.OB.NoFz{nn}.Jit*PhaseMeasures.FreqOBNoFz(i);
    AllWFId(1,nn)=PhaseMeasures.ID(nn);
    AllFreq(1,nn)=PhaseMeasures.FreqHPCFz(nn);
    AllFreq(2,nn)=PhaseMeasures.FreqHPCNoFz(nn);
    AllFreq(3,nn)=PhaseMeasures.FreqOBFz(nn);
    AllFreq(4,nn)=PhaseMeasures.FreqOBNoFz(nn);
    AllSpk(1,nn)=(PhaseMeasures.Overall{nn}(1)./PhaseMeasures.FzDur{nn}-PhaseMeasures.Overall{nn}(2)./PhaseMeasures.NoFzDur{nn})./...
        (PhaseMeasures.Overall{nn}(1)./PhaseMeasures.FzDur{nn}+PhaseMeasures.Overall{nn}(2)./PhaseMeasures.NoFzDur{nn});
end

figure
subplot(241)
plot(AllKappa(1,:),AllKappa(2,:),'*'), hold on
plot(AllKappa(3,:),AllKappa(4,:),'*')
plot(AllKappa(1,:),AllKappa(1,:),'k-')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('Kappa')
subplot(245)
ModH=(AllKappa(1,:)-AllKappa(2,:))./(AllKappa(1,:)+AllKappa(2,:));
ModB=(AllKappa(3,:)-AllKappa(4,:))./(AllKappa(3,:)+AllKappa(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.2,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])
subplot(242)
plot(AllRmean(1,:),AllRmean(2,:),'*'), hold on
plot(AllRmean(3,:),AllRmean(4,:),'*')
plot(AllRmean(1,:),AllRmean(1,:),'k-')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('Rmean')
subplot(246)
ModH=(AllRmean(1,:)-AllRmean(2,:))./(AllRmean(1,:)+AllRmean(2,:));
ModB=(AllRmean(3,:)-AllRmean(4,:))./(AllRmean(3,:)+AllRmean(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.2,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])
subplot(243)
plot(AllPwPC(1,:),AllPwPC(2,:),'*'), hold on
plot(AllPwPC(3,:),AllPwPC(4,:),'*')
plot(AllPwPC(1,:),AllPwPC(1,:),'k-')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('PwPC')
subplot(247)
ModH=(AllPwPC(1,:)-AllPwPC(2,:))./(AllPwPC(1,:)+AllPwPC(2,:));
ModB=(AllPwPC(3,:)-AllPwPC(4,:))./(AllPwPC(3,:)+AllPwPC(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.2,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])
subplot(244)
plot(AllJit(1,:),AllJit(2,:),'*'), hold on
plot(AllJit(3,:),AllJit(4,:),'*')
plot(AllJit(1,:),AllJit(1,:),'k-')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('Temporal jitter')
subplot(248)
ModH=(AllJit(1,:)-AllJit(2,:))./(AllJit(1,:)+AllJit(2,:));
ModB=(AllJit(3,:)-AllJit(4,:))./(AllJit(3,:)+AllJit(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.2,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])

figure
clf
%figure
Cols2=[0,146,146;189,109,255]/263;
subplot(221)
plot(AllKappa(1,:),AllKappa(2,:),'.','color',Cols2(1,:),'MarkerSize',10), hold on
plot(AllKappa(3,:),AllKappa(4,:),'.','color',Cols2(2,:),'MarkerSize',10)
line([0 1],[0 1],'color','k')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('Kappa'),box off
xlim([0 1]),ylim([0 1])
set(gca,'FontSize',15)
subplot(223)
ModH=(AllKappa(1,:)-AllKappa(2,:))./(AllKappa(1,:)+AllKappa(2,:));
ModB=(AllKappa(3,:)-AllKappa(4,:))./(AllKappa(3,:)+AllKappa(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line([0.8 1.2],[1 1]*mean(ModH),'color','k','linewidth',2)
errorbar(1,mean(ModH),abs(mean(ModH)-prctile(ModH,5)),abs(mean(ModH)-prctile(ModH,95)),'k')
line([0.8 1.2]+1,[1 1]*mean(ModB),'color','k','linewidth',2)
errorbar(2,mean(ModB),abs(mean(ModB)-prctile(ModB,5)),abs(mean(ModB)-prctile(ModB,95)),'k')
line(xlim,[0 0],'color','k','linestyle',':')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.3,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])
set(gca,'FontSize',15)
subplot(222)
plot(AllPwPC(1,:),AllPwPC(2,:),'.','color',Cols2(1,:),'MarkerSize',10), hold on
plot(AllPwPC(3,:),AllPwPC(4,:),'.','color',Cols2(2,:),'MarkerSize',10)
line([0 0.5],[0 0.5],'color','k')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('PwPC'), box off
xlim([0 0.5]),ylim([0 0.5])
set(gca,'FontSize',15)
subplot(224)
ModH=(AllPwPC(1,:)-AllPwPC(2,:))./(AllPwPC(1,:)+AllPwPC(2,:));
ModB=(AllPwPC(3,:)-AllPwPC(4,:))./(AllPwPC(3,:)+AllPwPC(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line([0.8 1.2],[1 1]*mean(ModH),'color','k','linewidth',2)
errorbar(1,mean(ModH),abs(mean(ModH)-prctile(ModH,5)),abs(mean(ModH)-prctile(ModH,95)),'k')
line([0.8 1.2]+1,[1 1]*mean(ModB),'color','k','linewidth',2)
errorbar(2,mean(ModB),abs(mean(ModB)-prctile(ModB,5)),abs(mean(ModB)-prctile(ModB,95)),'k')
line(xlim,[0 0],'color','k','linestyle',':')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.3,1,'***','FontSize',25)
    elseif p(i)<0.01a
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])
set(gca,'FontSize',15)


figure
subplot(231)
plot(AllKappa(1,:),AllKappa(2,:),'*'), hold on
plot(AllKappa(3,:),AllKappa(4,:),'*')
plot(AllKappa(1,:),AllKappa(1,:),'k-')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('Kappa')
subplot(234)
ModH=(AllKappa(1,:)-AllKappa(2,:))./(AllKappa(1,:)+AllKappa(2,:));
ModB=(AllKappa(3,:)-AllKappa(4,:))./(AllKappa(3,:)+AllKappa(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.2,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])

subplot(232)
plot(AllRmean(1,:),AllRmean(2,:),'*'), hold on
plot(AllRmean(3,:),AllRmean(4,:),'*')
plot(AllRmean(1,:),AllRmean(1,:),'k-')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('Rmean')
subplot(235)
ModH=(AllRmean(1,:)-AllRmean(2,:))./(AllRmean(1,:)+AllRmean(2,:));
ModB=(AllRmean(3,:)-AllRmean(4,:))./(AllRmean(3,:)+AllRmean(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.2,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])

subplot(233)
plot(AllPwPC(1,:),AllPwPC(2,:),'*'), hold on
plot(AllPwPC(3,:),AllPwPC(4,:),'*')
plot(AllPwPC(1,:),AllPwPC(1,:),'k-')
legend('HPC','OB')
xlabel('Fz'),ylabel('NoFz')
title('PwPC')
subplot(236)
ModH=(AllPwPC(1,:)-AllPwPC(2,:))./(AllPwPC(1,:)+AllPwPC(2,:));
ModB=(AllPwPC(3,:)-AllPwPC(4,:))./(AllPwPC(3,:)+AllPwPC(4,:));
plotSpread({ModH,ModB},'distributionColors',[0.4 0.4 0.4],'xNames',{'HPC','OB'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
[h,p(1)]=ttest(ModH);
[h,p(2)]=ttest(ModB);
for i=1:2
    if p(i)<0.001
        text(i-0.2,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end
ylim([-1.2 1.2])

figure
col=[Cols2(2,:);(Cols2(2,:)+Cols2(1,:))/2;Cols2(1,:);[1 1 1]]
A=[sum(Allpval(1,:)>=0.05&Allpval(3,:)<0.05),...
    sum(Allpval(1,:)<0.05&Allpval(3,:)<0.05),...
    sum(Allpval(1,:)<0.05&Allpval(3,:)>=0.05),...
    sum(Allpval(1,:)>=0.05&Allpval(3,:)>=0.05)];
subplot(211)
h=pie(A,[1 1 0 0])
set(h(1), 'FaceColor', col(1,:));
set(h(3), 'FaceColor', col(2,:));
set(h(5), 'FaceColor', col(3,:));
set(h(7), 'FaceColor', 'w');
title('Fz')
B=[sum(Allpval(2,:)>=0.05&Allpval(4,:)<0.05),...
    sum(Allpval(2,:)<0.05&Allpval(4,:)<0.05),...
    sum(Allpval(2,:)<0.05&Allpval(4,:)>=0.05),...
    sum(Allpval(2,:)>=0.05&Allpval(4,:)>=0.05)];
subplot(212)
h=pie(B,[1 1 0 0])
set(h(1), 'FaceColor', col(1,:));
set(h(3), 'FaceColor', col(2,:));
set(h(5), 'FaceColor', col(3,:));
set(h(7), 'FaceColor', 'w');
title('NoFz')

X1=([Allpval(1,:)>=0.05&Allpval(3,:)<0.05]+[Allpval(1,:)<0.05&Allpval(3,:)<0.05]*2+[Allpval(1,:)<0.05&Allpval(3,:)>=0.05]*3+[Allpval(1,:)>=0.05&Allpval(3,:)>=0.05]*4);
X2=([Allpval(2,:)>=0.05&Allpval(4,:)<0.05]+[Allpval(2,:)<0.05&Allpval(4,:)<0.05]*2+[Allpval(2,:)<0.05&Allpval(4,:)>=0.05]*3+[Allpval(2,:)>=0.05&Allpval(4,:)>=0.05]*4);
[table,chi2,p] = crosstab(X1,X2);
X1=(Allpval(1,:)<0.05);
X2=(Allpval(2,:)<0.05);
[table,chi2,p] = crosstab(X1,X2);
[h,p, chi2stat,df] =prop_test([sum(X1),sum(X2)],[length(X1),length(X2)],'true');
X1=(Allpval(3,:)<0.05);
X2=(Allpval(4,:)<0.05);
[table,chi2,p] = crosstab(X1,X2);
[h,p, chi2stat,df] =prop_test([sum(X1),sum(X2)],[length(X1),length(X2)],'true');

figure
plot(AllSpk,(AllKappa(3,:)-AllKappa(4,:))./(AllKappa(3,:)+AllKappa(4,:)),'*')
xlabel('FR mod'), ylabel('Kappa Mod')
box off
set(gca,'FontSize',15)

figure
plotSpread({AllSpk},'distributionColors',[0.4 0.4 0.4],'xValues',[1])
hold on
line([0.8 1.2],[1 1]*mean(AllSpk),'color','k','linewidth',2)
errorbar(1,mean(AllSpk),abs(mean(AllSpk)-prctile(AllSpk,5)),abs(mean(AllSpk)-prctile(AllSpk,95)),'k')
line(xlim,[0 0],'color','k','linestyle',':')
[h,p(1)]=signrank(AllSpk);
for i=1
    if p(i)<0.001
        text(i,1,'***','FontSize',25)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',25)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',25)
    end
end


figure
clf
subplot(121)
alpha=0.05;
plot(Allmu(3,Allpval(4,:)<alpha & AllWFId<0),Allmu(4,Allpval(4,:)<alpha& AllWFId<0),'r*'), hold on
plot(Allmu(3,Allpval(3,:)<alpha & AllWFId<0),Allmu(4,Allpval(3,:)<alpha& AllWFId<0),'r*'), hold on
plot(Allmu(3,Allpval(4,:)<alpha & AllWFId>0),Allmu(4,Allpval(4,:)<alpha& AllWFId>0),'b*'), hold on
plot(Allmu(3,Allpval(3,:)<alpha & AllWFId>0),Allmu(4,Allpval(3,:)<alpha& AllWFId>0),'b*'), hold on
subplot(122)
alpha=0.05;
plot(AllKappa(3,Allpval(4,:)<alpha & AllWFId<0),AllKappa(4,Allpval(4,:)<alpha& AllWFId<0),'r*'), hold on
plot(AllKappa(3,Allpval(3,:)<alpha & AllWFId<0),AllKappa(4,Allpval(3,:)<alpha& AllWFId<0),'r*'), hold on
plot(AllKappa(3,Allpval(4,:)<alpha & AllWFId>0),AllKappa(4,Allpval(4,:)<alpha& AllWFId>0),'b*'), hold on
plot(AllKappa(3,Allpval(3,:)<alpha & AllWFId>0),AllKappa(4,Allpval(3,:)<alpha& AllWFId>0),'b*'), hold on

subplot(121)
ModB=(AllKappa(3,:)-AllKappa(4,:))./(AllKappa(3,:)+AllKappa(4,:));
plot(Allmu(3,Allpval(4,:)<alpha & AllWFId<0),ModB(Allpval(4,:)<alpha & AllWFId<0),'r*'), hold on
plot(Allmu(3,Allpval(3,:)<alpha & AllWFId<0),ModB(Allpval(3,:)<alpha & AllWFId<0),'r*'), hold on
plot(Allmu(3,Allpval(3,:)<alpha & AllWFId>0),ModB(Allpval(3,:)<alpha & AllWFId>0),'b*'), hold on
plot(Allmu(3,Allpval(3,:)<alpha & AllWFId>0),ModB(Allpval(3,:)<alpha & AllWFId>0),'b*'), hold on
subplot(122)
ModB=(AllKappa(3,:)-AllKappa(4,:))./(AllKappa(3,:)+AllKappa(4,:));
plot(Allmu(4,Allpval(4,:)<alpha & AllWFId<0),ModB(Allpval(4,:)<alpha & AllWFId<0),'r*'), hold on
plot(Allmu(4,Allpval(3,:)<alpha & AllWFId<0),ModB(Allpval(3,:)<alpha & AllWFId<0),'r*'), hold on
plot(Allmu(4,Allpval(3,:)<alpha & AllWFId>0),ModB(Allpval(3,:)<alpha & AllWFId>0),'b*'), hold on
plot(Allmu(4,Allpval(3,:)<alpha & AllWFId>0),ModB(Allpval(3,:)<alpha & AllWFId>0),'b*'), hold on
