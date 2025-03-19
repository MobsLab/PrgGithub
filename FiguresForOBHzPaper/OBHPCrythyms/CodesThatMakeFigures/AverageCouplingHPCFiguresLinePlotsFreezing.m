% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[253,258,299,395,403,451];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered spectro
FreqRange=[1:12;[3:14]];
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    
    % HPC non local - PFCx
    load('PFCxHPCPhaseCoupling1.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('PFCxHPCPhaseCoupling2.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllHPCnonlocPFCX.Shannon(mm,:)=diag(FinalSig.Shannon);
    AllHPCnonlocPFCX.VectLength(mm,:)=diag(FinalSig.VectLength);
    
    % HPC  local - PFCx
    load('PFCxLocHPChaseCoupling.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    AllHPClocPFCX.Shannon(mm,:)=diag(FinalSig.Shannon);
    AllHPClocPFCX.VectLength(mm,:)=diag(FinalSig.VectLength);
    
    % HPC non local - OB
    try
        load('OBHPCPhaseCouplingOB2HPC2.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCouplingOB1HPC2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCouplingOB2HPC1.mat')
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCouplingOB1HPC1.mat')
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllHPCnonlocOB.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllHPCnonlocOB.VectLength(mm,:)=diag(FinalSig.VectLength);
    catch
        load('OBHPCPhaseCoupling1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCoupling2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllHPCnonlocOB.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllHPCnonlocOB.VectLength(mm,:)=diag(FinalSig.VectLength);
    end
    
    %HPC local - OB
    try
        load('OBHPCPhaseCouplingOB1HPCLoc.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCouplingOB2HPCLoc.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllHPClocOB.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllHPClocOB.VectLength(mm,:)=diag(FinalSig.VectLength);
    catch
        load('OBLocHPCPhaseCoupling.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllHPClocOB.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllHPClocOB.VectLength(mm,:)=diag(FinalSig.VectLength);
        
        
    end
end

figure
subplot(2,2,1), hold on
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.VectLength,FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllHPClocPFCX.VectLength,FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi PFCx')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,2)
AvCouplingAndSignifPlot(AllHPCnonlocOB.VectLength,FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllHPClocOB.VectLength,FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi OB')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,3)
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.Shannon,FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllHPClocPFCX.Shannon,FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi PFCx')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])
subplot(2,2,4)
AvCouplingAndSignifPlot(AllHPCnonlocOB.Shannon,FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllHPClocOB.Shannon,FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi OB')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])


figure
subplot(2,2,1)
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPCnonlocPFCX.VectLength),[stdError(AllHPCnonlocPFCX.VectLength);stdError(AllHPCnonlocPFCX.VectLength)]','alpha');hold on
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPClocPFCX.VectLength),[stdError(AllHPClocPFCX.VectLength);stdError(AllHPClocPFCX.VectLength)]','alpha','r');
title('Local/NonLocal HPC wi PFCx')
ylabel('Vect Length'), ylim([0 0.6]), xlim([2 13])
subplot(2,2,2)
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPCnonlocOB.VectLength),[stdError(AllHPCnonlocOB.VectLength);stdError(AllHPCnonlocOB.VectLength)]','alpha');hold on
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPClocOB.VectLength),[stdError(AllHPClocOB.VectLength);stdError(AllHPClocOB.VectLength)]','alpha','r');
title('Local/NonLocal HPC wi OB')
ylabel('Vect Length'), ylim([0 0.6]), xlim([2 13])
subplot(2,2,3)
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPCnonlocPFCX.Shannon),[stdError(AllHPCnonlocPFCX.Shannon);stdError(AllHPCnonlocPFCX.Shannon)]','alpha');hold on
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPClocPFCX.Shannon),[stdError(AllHPClocPFCX.Shannon);stdError(AllHPClocPFCX.Shannon)]','alpha','r');
title('Local/NonLocal HPC wi PFCx')
ylabel('Entropy'), ylim([0 0.1]), xlim([2 13])
subplot(2,2,4)
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPCnonlocOB.Shannon),[stdError(AllHPCnonlocOB.Shannon);stdError(AllHPCnonlocOB.Shannon)]','alpha');hold on
[hl,hp]=boundedline(mean(FreqRange),nanmean(AllHPClocOB.Shannon),[stdError(AllHPClocOB.Shannon);stdError(AllHPClocOB.Shannon)]','alpha','r');
title('Local/NonLocal HPC wi OB')
ylabel('Entropy'), ylim([0 0.1]), xlim([2 13])
