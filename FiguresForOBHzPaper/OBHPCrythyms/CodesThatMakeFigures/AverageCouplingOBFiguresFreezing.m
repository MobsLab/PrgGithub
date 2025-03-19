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
    load('OBPFCxPhaseCouplingOB1PFCx.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('OBPFCxPhaseCouplingOB2PFCx.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllOBnonlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
    AllOBnonlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
    
    % OB  local - PFCx
    load('OBPFCxPhaseCouplingOBLocPFCx.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    AllOBlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
    AllOBlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
    
    % OB non local - HPC
    if exist('OBHPCPhaseCouplingOB2HPC2.mat')>0
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
        AllOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
    else
        load('OBHPCPhaseCouplingOB2HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCouplingOB1HPC1.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
    end
    
    %OB local - HPC
    if exist('OBHPCPhaseCouplingOBLocHPC2.mat')>0
        load('OBHPCPhaseCouplingOBLocHPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCouplingOBLocHPC2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
    else
        load('OBHPCPhaseCouplingOBLocHPC1.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
    end
end

figure
CaxLim{1}=[];
CaxLim{2}=[];

subplot(2,2,1)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBnonlocPFCX.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
title('NonLocal OB wi PFCx')
subplot(2,2,2)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBlocPFCX.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
clim([0 max(max(CaxLim{1}))])
title('Local OB wi PFCx')
subplot(2,2,1)
CaxLim{1}=[CaxLim{1};clim];

subplot(2,2,3)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBnonlocHPC.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
title('Non Local OB wi HPC')
subplot(2,2,4)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBlocHPC.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
clim([0 max(max(CaxLim{1}))])
title('Local OB wi HPC')
subplot(2,2,3)
CaxLim{1}=[CaxLim{1};clim];


figure
CaxLim{1}=[];
CaxLim{2}=[];

subplot(2,2,1)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBnonlocPFCX.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
title('NonLocal OB wi PFCx')
subplot(2,2,2)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBlocPFCX.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
clim([0 max(max(CaxLim{1}))])
title('Local OB wi PFCx')
subplot(2,2,1)
CaxLim{1}=[CaxLim{1};clim];

subplot(2,2,3)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBnonlocHPC.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
title('Non Local OB wi HPC')
subplot(2,2,4)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllOBlocHPC.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
clim([0 max(max(CaxLim{1}))])
title('Local OB wi HPC')
subplot(2,2,3)
CaxLim{1}=[CaxLim{1};clim];
