% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[249,250,297];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
FieldNames={'HPC1','HPC2','HPCLoc','PFCx'};
FreqRange=[1:12;[3:14]];
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    
    % HPC non local - PFCx
    load('LFPPhaseCoupling/FzPhaseCouplingHPC1_PFCx.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('LFPPhaseCoupling/FzPhaseCouplingHPC2_PFCx.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllHPCnonlocPFCX.Shannon(mm,:)=diag(FinalSig.Shannon);
    AllHPCnonlocPFCX.VectLength(mm,:)=diag(FinalSig.VectLength);
    
    % HPC  local - PFCx
    load('LFPPhaseCoupling/FzPhaseCouplingHPCLoc_PFCx.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    AllHPClocPFCX.Shannon(mm,:)=diag(FinalSig.Shannon);
    AllHPClocPFCX.VectLength(mm,:)=diag(FinalSig.VectLength);
    
end

figure
subplot(2,1,1), hold on
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.VectLength,FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllHPClocPFCX.VectLength,FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi PFCx')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,1,2)
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.Shannon,FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllHPClocPFCX.Shannon,FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi PFCx')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])



figure
subplot(2,1,1), hold on
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPCnonlocPFCX.VectLength),[stdError(AllHPCnonlocPFCX.VectLength);stdError(AllHPCnonlocPFCX.VectLength)]','alpha');hold on
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPClocPFCX.VectLength),[stdError(AllHPClocPFCX.VectLength);stdError(AllHPClocPFCX.VectLength)]','alpha','r');
title('Local/NonLocal HPC wi PFCx')
ylabel('Vect Length'), ylim([0 0.6]), xlim([2 13])
subplot(2,1,2)
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPCnonlocPFCX.Shannon),[stdError(AllHPCnonlocPFCX.Shannon);stdError(AllHPCnonlocPFCX.Shannon)]','alpha');hold on
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPClocPFCX.Shannon),[stdError(AllHPClocPFCX.Shannon);stdError(AllHPClocPFCX.Shannon)]','alpha','r');
title('Local/NonLocal HPC wi PFCx')
ylabel('Entropy'), ylim([0 0.1]), xlim([2 13])
