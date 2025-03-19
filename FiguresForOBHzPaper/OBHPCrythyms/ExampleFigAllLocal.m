% Loo at local/local results

clear all
CtrlEphysInvOB=[253,395,248];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvOB);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered spectro
FreqRange=[1:12;[3:14]];
for mm=1
    mm
    CaxLim{1}=[];
    CaxLim{2}=[];
    
    cd(Dir.path{mm})
    load('behavResources.mat')
    
    % Get OB LFP
    clear LFP, load('LFPData/LocalOBActivity.mat')
    LFPAll.LocOB=LFP;clear LFP
    load(['LFPData/LFP',num2str(OBChannels(1)),'.mat'])
    LFPAll.OB1=LFP;clear LFP
    load(['LFPData/LFP',num2str(OBChannels(2)),'.mat'])
    LFPAll.OB2=LFP;clear LFP
    
    clear LFP, load('LFPData/LocalHPCActivity.mat')
    LFPAll.LocHPC=LFP;clear LFP
    load(['LFPData/LFP',num2str(HPCChannels(1)),'.mat'])
    LFPAll.HPC1=LFP;clear LFP
    load(['LFPData/LFP',num2str(HPCChannels(2)),'.mat'])
    LFPAll.HPC2=LFP;clear LFP
    
    figure
    subplot(211)
    plot(Range(LFPAll.HPC1,'s'),Data(LFPAll.HPC1)-2000,'k')
    hold on
    plot(Range(LFPAll.HPC1,'s'),Data(LFPAll.HPC2)+2000,'k')
    plot(Range(LFPAll.HPC1,'s'),-Data(LFPAll.LocHPC),'r')
    hold on,line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]' ,[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+5000,'color','b','linewidth',2)
    subplot(212)
    plot(Range(LFPAll.OB1,'s'),Data(LFPAll.OB1)-2000,'k')
    hold on
    plot(Range(LFPAll.OB1,'s'),Data(LFPAll.OB2)+2000,'k')
    plot(Range(LFPAll.OB1,'s'),-Data(LFPAll.LocOB),'r')
    hold on,line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]' ,[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+5000,'color','b','linewidth',2)
    
    figure,
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
    subplot(2,4,1)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    CaxLim{1}=[CaxLim{1};clim];
    
    ylabel('Vector Length')
    title('OB-HPC')
    subplot(2,4,5)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    CaxLim{2}=[CaxLim{2};clim];
    ylabel('Norm Entropy of distrib')
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    
    load('OBHPCPhaseCouplingOB2HPCLoc.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('OBHPCPhaseCouplingOB1HPCLoc.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    subplot(2,4,2)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    CaxLim{1}=[CaxLim{1};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    title('OB-HPCLocal')
    subplot(2,4,6)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    CaxLim{2}=[CaxLim{2};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    
    load('OBHPCPhaseCouplingOBLocHPC2.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('OBHPCPhaseCouplingOBLocHPC1.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    subplot(2,4,3)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    CaxLim{1}=[CaxLim{1};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    title('OBLocal-HPC')
    subplot(2,4,7)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    
    load('OBHPCPhaseCouplingOBLocHPCLoc.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    subplot(2,4,4)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    CaxLim{1}=[CaxLim{1};clim];
    title('OBLocal-HPCLocal')
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    subplot(2,4,8)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    CaxLim{2}=[CaxLim{2};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    for k=1:4
        subplot(2,4,k)
        clim([0 max(max(CaxLim{1}))])
        subplot(2,4,k+4)
        clim([0 max(max(CaxLim{2}))])
    end
    
    % example
    load('OBHPCPhaseCouplingOB2HPC2.mat')
    figure
    AllPhaseDiff=[];
    f=2;ff=2;
    NumBins=40;Smax=log(NumBins);
    for p=1:size(Phase{1},1)
        AllPhaseDiff=[AllPhaseDiff;(mod(Phase{1}{p,f}-Phase{2}{p,ff},2*pi))];
    end
    [Y1,X1]=hist(AllPhaseDiff,NumBins);
    Y1=Y1/sum(Y1);
    subplot(121)
    bar([X1,X1+2*pi],[Y1,Y1],'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6]), hold on
    xlim([0 4*pi])
    box off
    subplot(222)
    [Y1,X1]=hist(IndexRand.Shannon{f,ff},100), hold on
    Y1=Y1/sum(Y1);
    bar(X1,Y1,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6]), hold on
    line([1 1]*prctile(IndexRand.Shannon{f,ff},99.5),ylim,'linewidth',2,'color','k')
    plot(Index.Shannon(f,ff),0.04,'k*')
    box off
    title('Norm Entropy of distribution')
    subplot(224)
    [Y1,X1]=hist(IndexRand.VectLength{f,ff},100), hold on
    Y1=Y1/sum(Y1);
    bar(X1,Y1,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6]), hold on
    line([1 1]*prctile(IndexRand.VectLength{f,ff},99.5),ylim,'linewidth',2,'color','k')
    plot(Index.VectLength(f,ff),0.03,'k*')
    box off
    title('VectLength')
    
    load('OBHPCPhaseCouplingOBLocHPCLoc.mat')
    figure
    AllPhaseDiff=[];
    f=2;ff=2;
    NumBins=40;Smax=log(NumBins);
    for p=1:size(Phase{1},1)
        AllPhaseDiff=[AllPhaseDiff;(mod(Phase{1}{p,f}-Phase{2}{p,ff},2*pi))];
    end
    [Y1,X1]=hist(AllPhaseDiff,NumBins);
    Y1=Y1/sum(Y1);
    subplot(121)
    bar([X1,X1+2*pi],[Y1,Y1],'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6]), hold on
    xlim([0 4*pi])
    box off
    subplot(222)
    [Y1,X1]=hist(IndexRand.Shannon{f,ff},100), hold on
    Y1=Y1/sum(Y1);
    bar(X1,Y1,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6]), hold on
    line([1 1]*prctile(IndexRand.Shannon{f,ff},99.5),ylim,'linewidth',2,'color','k')
    plot(Index.Shannon(f,ff),0.04,'k*')
    box off
    title('Norm Entropy of distribution')
    subplot(224)
    [Y1,X1]=hist(IndexRand.VectLength{f,ff},100), hold on
    Y1=Y1/sum(Y1);
    bar(X1,Y1,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6]), hold on
    line([1 1]*prctile(IndexRand.VectLength{f,ff},99.5),ylim,'linewidth',2,'color','k')
    plot(Index.VectLength(f,ff),0.03,'k*')
    title('VectLength')
    box off
    
    % PFCx figure
    CaxLim{1}=[];
    CaxLim{2}=[];
    
    figure
    load('PFCxHPCPhaseCoupling1.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('PFCxHPCPhaseCoupling2.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    subplot(2,4,1)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    CaxLim{1}=[CaxLim{1};clim];
    title('PFCx-HPC')
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    subplot(2,4,5)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    CaxLim{2}=[CaxLim{2};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    
    load('PFCxLocHPChaseCoupling.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    subplot(2,4,2)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    CaxLim{1}=[CaxLim{1};clim];
    title('PFCx-HPCLocal')
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    subplot(2,4,6)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    CaxLim{2}=[CaxLim{2};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    
    
    
    load('OBPFCxPhaseCouplingOB1PFCx.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('OBPFCxPhaseCouplingOB2PFCx.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    subplot(2,4,3)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    CaxLim{1}=[CaxLim{1};clim];
    title('PFCx-OB')
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    subplot(2,4,7)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    CaxLim{2}=[CaxLim{2};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    
    load('OBPFCxPhaseCouplingOBLocPFCx.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    subplot(2,4,4)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.VectLength); axis xy
    CaxLim{1}=[CaxLim{1};clim];
    title('PFCx-OBLocal')
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    subplot(2,4,8)
    [C,h,CF]=contourf(mean(FreqRange),mean(FreqRange),FinalSig.Shannon);axis xy
    CaxLim{2}=[CaxLim{2};clim];
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    
    for k=1:4
        subplot(2,4,k)
        clim([0 max(max(CaxLim{1}))])
        subplot(2,4,k+4)
        clim([0 max(max(CaxLim{2}))])
    end
    
    figure,
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
subplot(1,2,1)
plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
xlim([2 13]), box off, hold on
ylabel('Vector Length')

subplot(1,2,2)
plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
xlim([2 13]), box off, hold on

load('OBHPCPhaseCouplingOB2HPCLoc.mat')
FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
load('OBHPCPhaseCouplingOB1HPCLoc.mat')
FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
subplot(1,2,1)
plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
xlim([2 13]), box off
ylabel('Vector Length')

subplot(1,2,2)
plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
xlim([2 13]), box off

load('OBHPCPhaseCouplingOBLocHPC2.mat')
FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
load('OBHPCPhaseCouplingOBLocHPC1.mat')
FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
subplot(1,2,1)
plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
xlim([2 13]), box off
ylabel('Vector Length')

subplot(1,2,2)
plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
xlim([2 13]), box off

load('OBHPCPhaseCouplingOBLocHPCLoc.mat')
FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
subplot(1,2,1)
plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
xlim([2 13]), box off
ylabel('Vector Length')

subplot(1,2,2)
plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
xlim([2 13]), box off

subplot(1,2,1)
ylabel('Vect Length')
legend({'OB-HPC','OB-HPCLocal','OBLocal-HPC','OBLocal-HPCLocal'})
xlabel('Frequency - Hz')
subplot(1,2,2)
ylabel('Entropy')
legend({'OB-HPC','OB-HPCLocal','OBLocal-HPC','OBLocal-HPCLocal'})
xlabel('Frequency - Hz')





%%%%%%%%%%
 % PFCx figure
 
 
 figure
 load('PFCxHPCPhaseCoupling1.mat')
 FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
 load('PFCxHPCPhaseCoupling2.mat')
 FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
 FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
 FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
 subplot(1,2,1)
 plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
 xlim([2 13]), box off, hold on
 ylabel('Vector Length')
 
 subplot(1,2,2)
 plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
 xlim([2 13]), box off, hold on
 
 
 load('PFCxLocHPChaseCoupling.mat')
 FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
 subplot(1,2,1)
 plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
 xlim([2 13]), box off, hold on
 ylabel('Vector Length')
 
 subplot(1,2,2)
 plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
 xlim([2 13]), box off, hold on
 
 
 load('OBPFCxPhaseCouplingOB1PFCx.mat')
 FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
 load('OBPFCxPhaseCouplingOB2PFCx.mat')
 FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
 FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
 FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
 subplot(1,2,1)
 plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
 xlim([2 13]), box off, hold on
 ylabel('Vector Length')
 
 subplot(1,2,2)
 plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
 xlim([2 13]), box off, hold on
 
 
 load('OBPFCxPhaseCouplingOBLocPFCx.mat')
 FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
 subplot(1,2,1)
 plot(mean(FreqRange),diag(FinalSig.VectLength),'linewidth',2)
 xlim([2 13]), box off, hold on
 ylabel('Vector Length')
 
 subplot(1,2,2)
 plot(mean(FreqRange),diag(FinalSig.Shannon),'linewidth',2)
 xlim([2 13]), box off, hold on
 subplot(1,2,1)
 ylabel('Vect Length')
 legend({'PFCx-HPC','PFCx-HPCLocal','PFCx-OB','PFCx-OBLocal'})
 xlabel('Frequency - Hz')
 subplot(1,2,2)
 ylabel('Entropy')
 legend({'PFCx-HPC','PFCx-HPCLocal','PFCx-OB','PFCx-OBLocal'})
 xlabel('Frequency - Hz')
 
 
 

end