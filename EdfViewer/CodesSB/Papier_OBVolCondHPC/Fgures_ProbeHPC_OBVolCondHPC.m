TriggeredHPC.ThetaRun = HPCTrigTheta_Run;
TriggeredHPC.ThetaFreeze = HPCTrigTheta_Freeze;
TriggeredHPC.BreathRun = HPCTrigBreath_Run;
TriggeredHPC.BreathFreeze = HPCTrigBreath_Freeze;

Types = fieldnames(TriggeredHPC);

for ty = 1:length(Types)
    
    DataToUse = TriggeredHPC.(Types{ty});
    clear M
    M(:,1) = 1:size(DataToUse,2);
    
    subplot(4,3,1+(ty-1)*3)
    hold on
    for k=1:size(DataToUse,1)
        plot(M(:,1),DataToUse(k,:)-k*900,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    
    subplot(4,3,2+(ty-1)*3)
    imagesc(M(:,1),[1:size(DataToUse,1)],DataToUse),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    caxis([-600 600])
    
    subplot(4,3,3+(ty-1)*3)
    HPCTrigBreathCSD=interp2(diff(diff(DataToUse)),3);
    imagesc(M(:,1),[1:size(HPCTrigBreathCSD,1)],HPCTrigBreathCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
    caxis([-200 200])
    
end

for ty = 1:length(Types)
    
    DataToUse = TriggeredHPC.(Types{ty});
    clear M
    M(:,1) = 1:size(DataToUse,2);
    
    
    DatMat=zscore(DataToUse')';
    [EigVect,EigVals]=PerformPCA(DatMat);
    [val,ind]=max(abs(EigVect(:,1)));EigVect(:,1)=EigVect(:,1)*sign(EigVect(ind,1));
    [val,ind]=max(abs(EigVect(:,2)));EigVect(:,2)=EigVect(:,2)*sign(EigVect(ind,2));
    
    subplot(4,4,1+(ty-1)*4)
    hold on
    plot(EigVect(:,1),-[1:size(DataToUse,1)],'linewidth',2)
    plot(EigVect(:,2),-[1:size(DataToUse,1)],'r','linewidth',2)
    ylim([-16 1])
    
    subplot(4,4,2+(ty-1)*4)
    hold on
    plot(M(:,1),EigVect(:,1)'*DatMat,'linewidth',2)
    plot(M(:,1),EigVect(:,2)'*DatMat,'r','linewidth',2)
    
    subplot(4,4,3+(ty-1)*4)
    All=[];
    for k=1:size(DataToUse,1)
        All=[All;EigVect(:,1)'*DatMat*EigVect(k,1)];
    end
    imagesc(M(:,1),[1:size(DataToUse,1)-1],interp2(diff(diff(All)),3)), hold on,axis xy
    for k=1:size(DataToUse,1)
        plot(M(:,1),EigVect(:,1)'*DatMat*EigVect(k,1)*0.4+(k-1),'color','k','linewidth',2)
    end
    ylim([-1 size(DataToUse,1)])
    
    subplot(4,4,4+(ty-1)*4)
    All=[];
    for k=1:size(DataToUse,1)
        All=[All;EigVect(:,1)'*DatMat*EigVect(k,2)];
    end
    imagesc(M(:,1),[1:size(DataToUse,1)-1],interp2(diff(diff(All)),3)), hold on,axis xy
    for k=1:size(DataToUse,1)
        plot(M(:,1),EigVect(:,1)'*DatMat*EigVect(k,2)*0.4+(k-1),'color','k','linewidth',2)
    end
    ylim([-1 size(DataToUse,1)])
    
end


for i=1:LookAtRipProfile
    WindowSz=200;
    load(['LFPData/LFP',num2str(41),'.mat'])
    [Ripples_tmp,usedEpoch]=FindRipplesKarimSB(LFP,intervalSet(0,max(Range(LFP))),[5 8],[30 30 100]);
    clear AllRip
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        [M,T]=PlotRipRaw(LFP,Ripples_tmp(:,2),WindowSz,0,0);
        AllRip(c,:)=M(:,2);
    end
    cols=parula(18);
    figure
    subplot(131)
    hold on
    for k=1:length(HPCOrderChans)
        plot(M(:,1),AllRip(k,:)-k*3000,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(132)
    imagesc(M(:,1),[1:size(AllRip,1)],AllRip),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(133)
    AllRipCSD=interp2(diff(diff(AllRip)),3);
    imagesc(M(:,1),[1:size(AllRipCSD,1)],AllRipCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
end

load('Epochs.mat')
HPCOrderChans=[123 109 110 111 119 120 106 107 108 116 121 103 104 105 117 ];
for c=1:length(HPCOrderChans)
    chan2=HPCOrderChans(c);
    load(['Cohgram_OB_HPC',num2str(chan2),'.mat'])
    Sptsd=tsd(t*1E4,C);
    AllCohOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
    AllCohOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
    
end


for c=1:length(HPCOrderChans)-1
    load(['Cohgram_OB_HPCDiff',num2str(c),'.mat'])
    Sptsd=tsd(t*1E4,C);
    AllCohDiffOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
    AllCohDiffOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
end

for c=1:length(HPCOrderChans)-2
    load(['Cohgram_OB_HPCCSD',num2str(c),'.mat'])
    Sptsd=tsd(t*1E4,C);
    AllCohCSDOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
    AllCohCSDOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
end

figure
subplot(231)
imagesc(f,[1:size(AllCohOBMov,1)],AllCohOBMov),clim([0.4 0.6])
title('Coh LFP HPC / LFP OB')
xlabel('Frequency (Hz)')
subplot(232)
imagesc(f,[1:size(AllCohDiffOBMov,1)],AllCohDiffOBMov),clim([0.4 0.7])
title('Coh CSD HPC / LFP OB')
xlabel('Frequency (Hz)')
subplot(233)
imagesc(f,[1:size(AllCohCSDOBMov,1)],AllCohCSDOBMov),clim([0.4 0.7])
title('Coh CSD HPC / LFP OB')
xlabel('Frequency (Hz)')

subplot(234)
imagesc(f,[1:size(AllCohOB,1)],AllCohOB),clim([0.4 0.6])
title('Coh LFP HPC / LFP OB')
xlabel('Frequency (Hz)')
subplot(235)
imagesc(f,[1:size(AllCohDiffOB,1)],AllCohDiffOB),clim([0.4 0.7])
title('Coh CSD HPC / LFP OB')
xlabel('Frequency (Hz)')
subplot(236)
imagesc(f,[1:size(AllCohCSDOB,1)],AllCohCSDOB),clim([0.4 0.7])
title('Coh CSD HPC / LFP OB')
xlabel('Frequency (Hz)')



figure
Band4=[find(f<3,1,'last'):find(f<5,1,'last')];
Band7=[find(f<5,1,'last'):find(f<8,1,'last')];
subplot(411)
plot([1:16],mean(AllCohOB(:,Band4)'),'linewidth',3), hold on
plot([1.5:15.5],mean(AllCohDiffOB(:,Band4)'),'linewidth',3)
plot([2:15],mean(AllCohCSDOB(:,Band4)'),'linewidth',3)
box off, ylim([0.4 0.75]), xlim([1 16])
title('OB coherence - 4Hz')
legend('Voltage','Current','Source/Sink')
subplot(412)
plot([1:16],mean(AllCohOB(:,Band7)'),'linewidth',3), hold on
plot([1.5:15.5],mean(AllCohDiffOB(:,Band7)'),'linewidth',3)
plot([2:15],mean(AllCohCSDOB(:,Band7)'),'linewidth',3)
box off, ylim([0.4 0.75]), xlim([1 16])
title('OB coherence - 6Hz')
subplot(413)
plot([1:16],mean(AllCohPFCx(:,Band4)'),'linewidth',3), hold on
plot([1.5:15.5],mean(AllCohDiffPFCx(:,Band4)'),'linewidth',3)
plot([2:15],mean(AllCohCSDPFCx(:,Band4)'),'linewidth',3)
box off, ylim([0.4 0.75]), xlim([1 16])
title('PFCx coherence - 4Hz')
subplot(414)
plot([1:16],mean(AllCohPFCx(:,Band7)'),'linewidth',3), hold on
plot([1.5:15.5],mean(AllCohDiffPFCx(:,Band7)'),'linewidth',3)
plot([2:15],mean(AllCohCSDPFCx(:,Band7)'),'linewidth',3)
box off, ylim([0.4 0.75]), xlim([1 16])
title('PFCx coherence - 6Hz')



