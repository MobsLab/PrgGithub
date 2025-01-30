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
    AllHPCnonlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
    AllHPCnonlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
    
    % HPC  local - PFCx
    load('PFCxLocHPChaseCoupling.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    AllHPClocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
    AllHPClocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
    
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
        AllHPCnonlocOB.Shannon(mm,:,:)=FinalSig.Shannon;
        AllHPCnonlocOB.VectLength(mm,:,:)=FinalSig.VectLength;
    catch
        load('OBHPCPhaseCoupling1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCoupling2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllHPCnonlocOB.Shannon(mm,:,:)=FinalSig.Shannon;
        AllHPCnonlocOB.VectLength(mm,:,:)=FinalSig.VectLength;
    end
    
    %HPC local - OB
    try
        load('OBHPCPhaseCouplingOB1HPCLoc.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('OBHPCPhaseCouplingOB2HPCLoc.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllHPClocOB.Shannon(mm,:,:)=FinalSig.Shannon;
        AllHPClocOB.VectLength(mm,:,:)=FinalSig.VectLength;
    catch
        load('OBLocHPCPhaseCoupling.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllHPClocOB.Shannon(mm,:,:)=FinalSig.Shannon;
        AllHPClocOB.VectLength(mm,:,:)=FinalSig.VectLength;
        
        
    end
end

figure
CaxLim{1}=[];
CaxLim{2}=[];

subplot(2,2,1)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPCnonlocPFCX.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
title('NonLocal HPC wi PFCx')
subplot(2,2,2)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPClocPFCX.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
clim([0 max(max(CaxLim{1}))])
title('Local HPC wi PFCx')
subplot(2,2,1)
CaxLim{1}=[CaxLim{1};clim];

subplot(2,2,3)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPCnonlocOB.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
title('Non Local HPC wi OB')
subplot(2,2,4)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPClocOB.VectLength,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
clim([0 max(max(CaxLim{1}))])
title('Local HPC wi OB')
subplot(2,2,3)
CaxLim{1}=[CaxLim{1};clim];


figure
CaxLim{1}=[];
CaxLim{2}=[];

subplot(2,2,1)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPCnonlocPFCX.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
title('NonLocal HPC wi PFCx')
subplot(2,2,2)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPClocPFCX.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{1}=[CaxLim{1};clim];
clim([0 max(max(CaxLim{1}))])
title('Local HPC wi PFCx')
subplot(2,2,1)
CaxLim{1}=[CaxLim{1};clim];

subplot(2,2,3)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPCnonlocOB.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
title('Non Local HPC wi OB')
subplot(2,2,4)
[C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),squeeze(mean(AllHPClocOB.Shannon,1))); axis xy
for q=1:length(h)
    set(h(q),'LineStyle','none');
end
CaxLim{2}=[CaxLim{2};clim];
clim([0 max(max(CaxLim{1}))])
title('Local HPC wi OB')
subplot(2,2,3)
CaxLim{1}=[CaxLim{1};clim];
