%% Example of unit more strongly modulated by OB during freezing
clear all
cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse451/FEAR-Mouse-451-EXT-24-envB_161026_182307

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

num=15; neur=15;
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
PhaseMeasures.InfoNeur(num)=neur;
if NumSpikesEp(1)<NumSpikesEp(2)
    % Freezing has less spikes so downsample no freezing
    PhaseMeasures.HPC.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{1})),0,0);
    PhaseMeasures.OB.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{1})),0,0);
    PhaseMeasures.HPC.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{2})),100,NewNumSpikes);
    PhaseMeasures.OB.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{2})),100,NewNumSpikes);
else
    PhaseMeasures.HPC.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{1})),100,NewNumSpikes);
    PhaseMeasures.OB.Fz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{1})),100,NewNumSpikes);
    PhaseMeasures.HPC.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.HPC,Epochs{2})),0,0);
    PhaseMeasures.OB.NoFz{num}=GetPhaseStatistics(Data(Restrict(Phasetsd.OB,Epochs{2})),0,0);
end

NumBins=30;
% modif faite pour figure 03.04.2018
% OB
k=30
figure
subplot(211)
[Y,X] = hist([(Data(Restrict(Phasetsd.OB,Epochs{1})))]+pi,NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=PhaseMeasures.OB.Fz{num}.mu+pi;
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,PhaseMeasures.OB.Fz{num}.Kappa);
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

subplot(212)
[Y,X] = hist([(Data(Restrict(Phasetsd.OB,Epochs{2})))]+pi,NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on

dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=PhaseMeasures.OB.NoFz{num}.mu+pi;
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,PhaseMeasures.OB.NoFz{num}.Kappa);
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off


%HPC
k=30
figure
subplot(211)
[Y,X] = hist([(Data(Restrict(Phasetsd.HPC,Epochs{1})))]+pi,NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=PhaseMeasures.HPC.Fz{num}.mu+pi;
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,PhaseMeasures.HPC.Fz{num}.Kappa);
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

subplot(212)
[Y,X] = hist([(Data(Restrict(Phasetsd.HPC,Epochs{2})))]+pi,NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on

dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=PhaseMeasures.HPC.NoFz{num}.mu+pi;
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,PhaseMeasures.HPC.NoFz{num}.Kappa);
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

