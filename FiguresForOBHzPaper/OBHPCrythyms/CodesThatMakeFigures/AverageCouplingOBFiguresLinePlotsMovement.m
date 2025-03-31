% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvOB=[253,395,248];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvOB);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered spectro
FreqRange=[1:12;[3:14]];
for mm=1:3
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    
    % OB non local - PFCx
    load('MovPhaseCouplingOB1_PFCx.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('MovPhaseCouplingOB2_PFCx.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllOBnonlocPFCX.Shannon(mm,:)=diag(FinalSig.Shannon);
    AllOBnonlocPFCX.VectLength(mm,:)=diag(FinalSig.VectLength);
    
    % OB  local - PFCx
    load('MovPhaseCouplingOBLoc_PFCx.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    AllOBlocPFCX.Shannon(mm,:)=diag(FinalSig.Shannon);
    AllOBlocPFCX.VectLength(mm,:)=diag(FinalSig.VectLength);
    
    % OB non local - HPC
    if exist('MovPhaseCouplingOB2_HPC2.mat')>0
        load('MovPhaseCouplingOB2_HPC2.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('MovPhaseCouplingOB2_HPC1.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('MovPhaseCouplingOB1_HPC1.mat')
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('MovPhaseCouplingOB1_HPC2.mat')
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllOBnonlocHPC.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllOBnonlocHPC.VectLength(mm,:)=diag(FinalSig.VectLength);
    else
        load('MovPhaseCouplingOB1_HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('MovPhaseCouplingOB2_HPC1.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllOBnonlocHPC.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllOBnonlocHPC.VectLength(mm,:)=diag(FinalSig.VectLength);
    end
    
    %OB local - HPC
    if exist('MovPhaseCouplingOBLoc_HPC2.mat')>0
        load('MovPhaseCouplingOBLoc_HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('MovPhaseCouplingOBLoc_HPC2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllOBlocHPC.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllOBlocHPC.VectLength(mm,:)=diag(FinalSig.VectLength);
    else
        load('MovPhaseCouplingOBLoc_HPC1.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllOBlocHPC.Shannon(mm,:)=diag(FinalSig.Shannon);
        AllOBlocHPC.VectLength(mm,:)=diag(FinalSig.VectLength);
    end
end


figure
subplot(2,2,1), hold on
AvCouplingAndSignifPlot(AllOBnonlocPFCX.VectLength,FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllOBlocPFCX.VectLength,FreqRange,[0 0 1],0.75,0.02)
title('Local/NonLocal OB wi PFCx')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,2)
AvCouplingAndSignifPlot(AllOBnonlocHPC.VectLength,FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllOBlocHPC.VectLength,FreqRange,[0 0 1],0.75,0.02)
title('Local/NonLocal OB wi HPC')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,3)
AvCouplingAndSignifPlot(AllOBnonlocPFCX.Shannon,FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllOBlocPFCX.Shannon,FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal OB wi PFCx')
ylabel('Entropy'), ylim([0 0.3]), xlim([2 13])
subplot(2,2,4)
AvCouplingAndSignifPlot(AllOBnonlocHPC.Shannon,FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllOBlocHPC.Shannon,FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal OB wi HPC')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])
