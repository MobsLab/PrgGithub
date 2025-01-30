close all
% Look at mice with both Local
figure
cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-24-envBraye_161020_155350
 %cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015
 load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'r','linewidth',3), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC1.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC2.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'r','linewidth',3), hold on
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,Yl/2,'n*PFCx:1*HPC')
text(8,Yl/2,'n*HPC:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend({'non local combinations','local'})
ylabel('VectStrength')

figure
load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'r','linewidth',3), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC1.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC2.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'color',[0.6 0.6 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPCLoc.mat')
IndexRand=TransformIndRand(IndexRand,MNRatio');
FinalSigMiniMaxi=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
plot([1:11],FinalSigMiniMaxi.VectLength,'r','linewidth',3), hold on
legend({'non local combinations','local'})
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,Yl/2,'n*PFCx:1*HPC')
text(8,Yl/2,'n*HPC:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend({'non local combinations','local'})
ylabel('VectStrength')


figure
FreqRange=[1:12;[3:14]];
load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC1.mat')
FinalSigAllFreq=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
plot(mean(FreqRange),FinalSigAllFreq.VectLength,'color',[0.6 1 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPCLoc.mat')
FinalSigAllFreq=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
plot(mean(FreqRange),FinalSigAllFreq.VectLength,'color',[0.6 0.6 1],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPCLoc.mat')
FinalSigAllFreq=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
plot(mean(FreqRange),FinalSigAllFreq.VectLength,'r','linewidth',3), hold on
load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC2.mat')
FinalSigAllFreq=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
plot(mean(FreqRange),FinalSigAllFreq.VectLength,'color',[0.6 1 0.6],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPCLoc.mat')
FinalSigAllFreq=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
plot(mean(FreqRange),FinalSigAllFreq.VectLength,'color',[0.6 0.6 1],'linewidth',2), hold on
load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPCLoc.mat')
FinalSigAllFreq=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
plot(mean(FreqRange),FinalSigAllFreq.VectLength,'r','linewidth',3), hold on
legend({'HPC non local','OB non local','local'})

