figure
for sp=1:20
load('SpikeData.mat')
NBins=40;
SmooFact=2;
ShuffleTimes=100;
load('NeuronLFPCoupling/FzNeuronModFreqMiniMaxiPhaseCorrected_HPC1.mat')
PhasesSpikesHPC1=PhasesSpikes;
load('NeuronLFPCoupling/FzNeuronModFreqMiniMaxiPhaseCorrected_HPC2.mat')
PhasesSpikesHPC2=PhasesSpikes;
load('NeuronLFPCoupling/FzNeuronModFreqMiniMaxiPhaseCorrected_HPCLoc.mat')
PhasesSpikesHPCLoc=PhasesSpikes;
load('NeuronLFPCoupling/FzNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
PhasesSpikesOB1=PhasesSpikes;

load('FilteredLFP/MiniMaxiLFPHPC1.mat')
HPC1Phase=PhaseInterpol;
load('FilteredLFP/MiniMaxiLFPHPC2.mat')
HPC2Phase=PhaseInterpol;
load('FilteredLFP/MiniMaxiLFPHPCLoc.mat')
HPCLocPhase=PhaseInterpol;
load('FilteredLFP/MiniMaxiLFPOB1.mat')
OB1LocPhase=PhaseInterpol;


Phase1=PhasesSpikesHPC1.Real{sp}.Transf;
Phase2=PhasesSpikesOB1.Real{sp}.Transf;
SubPlotCoord=[4,3,1;4,3,4;4,3,7];
[nnphase,xx,yy]=hist2(Data(Restrict(HPC1Phase,FreezeEpoch)),Data(Restrict(OB1LocPhase,FreezeEpoch)),NBins,NBins);
nnphase=nnphase./sum(sum(nnphase));
MakePlotsNeuronCoModualation(Phase1,Phase2,SubPlotCoord,NBins,SmooFact,ShuffleTimes)
subplot(4,3,10)
[Y,X]=hist(Phase1,NBins/2);
stairs(X,Y,'linewidth',2);hold on
[Y,X]=hist(Phase2,NBins/2);
stairs(X,Y,'linewidth',2);hold on
xlim([-pi pi])
Phase1=PhasesSpikesHPC2.Real{sp}.Transf;
Phase2=PhasesSpikesOB1.Real{sp}.Transf;
SubPlotCoord=[4,3,2;4,3,5;4,3,8];
[nnphase,xx,yy]=hist2(Data(Restrict(HPC2Phase,FreezeEpoch)),Data(Restrict(OB1LocPhase,FreezeEpoch)),NBins,NBins);
nnphase=nnphase./sum(sum(nnphase));
MakePlotsNeuronCoModualation(Phase1,Phase2,SubPlotCoord,NBins,SmooFact,ShuffleTimes)
subplot(4,3,11)
[Y,X]=hist(Phase1,NBins/2);
stairs(X,Y,'linewidth',2);hold on
[Y,X]=hist(Phase2,NBins/2);
stairs(X,Y,'linewidth',2);hold on
xlim([-pi pi])
Phase1=PhasesSpikesHPCLoc.Real{sp}.Transf;
Phase2=PhasesSpikesOB1.Real{sp}.Transf;
SubPlotCoord=[4,3,3;4,3,6;4,3,9];
[nnphase,xx,yy]=hist2(Data(Restrict(HPCLocPhase,FreezeEpoch)),Data(Restrict(OB1LocPhase,FreezeEpoch)),NBins,NBins);
nnphase=nnphase./sum(sum(nnphase));
MakePlotsNeuronCoModualation(Phase1,Phase2,SubPlotCoord,NBins,SmooFact,ShuffleTimes)
subplot(4,3,12)
[Y,X]=hist(Phase1,NBins/2);
stairs(X,Y,'linewidth',2);hold on
[Y,X]=hist(Phase2,NBins/2);
stairs(X,Y,'linewidth',2);hold on
xlim([-pi pi])
keyboard
clf
end

