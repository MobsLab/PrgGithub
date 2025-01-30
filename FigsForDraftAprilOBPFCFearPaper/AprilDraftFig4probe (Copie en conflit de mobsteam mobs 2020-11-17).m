% This code generates pannels used in april draft
% It generates Fig4C,D,E
% This code hasn't been adapted for use with the information on the server
% in Paris yet and only works on harddrives in Montreal
clear all, 
%close all
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/M514_170322')
%cd('/Volumes/My Passport/M514_170322')
%cd /Users/sophiebagur/Desktop/M514_170323
%HPCOrderChans=[38,41,33,46,34,45,35,44,32,47,36,43,37,42,39,40];
HPCOrderChans=[38,41,33,46,34,45,35,44,32,47,36];
DoCoh=0;
DoDiff=0;
LookAtRipProfile=1;
MakeCohFigs=1;
DoRandCoh=0;
DoRandCohCSD=0;
TriggerOnBreathing=0;
TriggerOnTheta=1;
GetOBPhase=0;
DoRandCohDiff=0;
DoRandCohFigs=0;
DoMNCoupling=0;
DoMNCouplingBelluscioMethod=0;
TriggerOnBreathingMov=0;
cols=parula(18);
% Get FreezeEpoch
load('behavResources.mat')
MovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),100));
FreezeEpoch=thresholdIntervals(MovAcctsd,1.5*1E7,'Direction','Below');
FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1E4);
RunEpoch=thresholdIntervals(MovAcctsd,2*1E7,'Direction','Above');
RunEpoch=dropShortIntervals(RunEpoch,3*1E4);

for i=1:DoCoh
    disp('calculating coherence and spectra')
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOB=LFP;
    load('ChannelsToAnalyse/PFCx_deep.mat')
    PFCxChan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPPFC=LFP;
    filenameSp='/Users/sophiebagur/Desktop/M514_170322/LowSpectrum/';
    [params,movingwin,suffix]=SpectrumParametersML('low');
    for c=1:length(HPCOrderChans)
        %LowSpectrumSB(filenameSp,HPCOrderChans(c),['HPCProbe' num2str(HPCOrderChans(c))],0)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPOB),Data(LFP),movingwin,params);
        chan1=OBchan;
        chan2=HPCOrderChans(c);
        save(['CohgramcDataL/Cohgram_OB_HPC',num2str(chan2),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPPFC),Data(LFP),movingwin,params);
        chan1=PFCxChan;
        chan2=HPCOrderChans(c);
        save(['CohgramcDataL/Cohgram_PFCx_HPC',num2str(chan2),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        AllChans(c,:)=Data(LFP);
        
        
    end
    lfp=[Range(LFP),AllChans'];
    csd = CSD(lfp);
    csd=csd(:,2:end);
    for el=1:size(csd,2)
        ctsd=tsd(Range(LFP),csd(:,el));
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPPFC),Data(ctsd),movingwin,params);
        chan1=PFCxChan;
        chan2=el;
        save(['CohgramcDataL/Cohgram_PFCx_HPCCSD',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPOB),Data(ctsd),movingwin,params);
        chan1=OBchan;
        chan2=el;
        save(['CohgramcDataL/Cohgram_OB_HPCCSD',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
    end
end

for i=1:GetOBPhase
    % LFP --> tsd with LFP on which to search of peaks and troughs
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    Options.Fs=1250; % sampling rate of LFP
    Options.FilBand=[1 20]
    Options.std=[0.5 0.2]; % std limits for first and second round of peak
    % finding
    Options.TimeLim=0.08; % in second, minimum distance between two minima or
    % two maxima, 1./TimeLim gives max detecte freq
    plo=1;
    AllPeaks=FindPeaksForFrequency(LFP,Options,plo);
    AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
    OptionsMiniMaxi=Options;
    Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFP,'s'));
    if AllPeaks(1,2)==1
        PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
    else
        PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
    end
    save(['MiniMaxiLFP','Bulb','.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
    clear AllPeaks PhaseInterpol
end

for i=1:TriggerOnBreathing
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOB=LFP;
    LFPOB=FilterLFP(LFPOB,[2 6],1024);
    LFPOBHil=hilbert(Data(LFPOB));
    LFPOBPhase=angle(LFPOBHil);
    Phasetsd=tsd(Range(LFPOB),LFPOBPhase);
    Phasetsd=Restrict(Phasetsd,FreezeEpoch);
    TopBreath=thresholdIntervals(Phasetsd,3.1,'Direction','Above');
    clear HPCTrigBreath
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        [M,T]=PlotRipRaw(LFP,Start(TopBreath,'s'),500,0,0);
        HPCTrigBreath(c,:)=M(:,2);
    end
    
    figure
    subplot(131)
    hold on
    for k=1:length(HPCOrderChans)
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(132)
    imagesc(M(:,1),[1:size(HPCTrigBreath,1)],HPCTrigBreath),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(133)
    HPCTrigBreathCSD=interp2(diff(diff(HPCTrigBreath)),3);
    imagesc(M(:,1),[1:size(HPCTrigBreathCSD,1)],HPCTrigBreathCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
    
    figure
    DatMat=zscore(HPCTrigBreath')';
    [EigVect,EigVals]=PerformPCA(DatMat);
    [val,ind]=max(abs(EigVect(:,1)));EigVect(:,1)=EigVect(:,1)*sign(EigVect(ind,1));
    [val,ind]=max(abs(EigVect(:,2)));EigVect(:,2)=EigVect(:,2)*sign(EigVect(ind,2));
    
    subplot(2,2,1), hold on
    plot(EigVect(:,1),-[0:15],'linewidth',2)
    plot(EigVect(:,2),-[0:15],'r','linewidth',2)
    ylim([-16 1])
    
    subplot(2,2,2)
    hold on
    plot(M(:,1),EigVect(:,1)'*DatMat,'linewidth',2)
    plot(M(:,1),EigVect(:,2)'*DatMat,'r','linewidth',2)
    
    subplot(2,2,3)
    All=[];
    for k=1:length(HPCOrderChans)
        All=[All;EigVect(:,1)'*DatMat*EigVect(k,1)];
    end
    imagesc(M(:,1),[1:length(HPCOrderChans)-1],interp2(diff(diff(All)),3)), hold on,axis xy
    for k=1:length(HPCOrderChans)
        plot(M(:,1),EigVect(:,1)'*DatMat*EigVect(k,1)*0.4+(k-1),'color','k','linewidth',2)
    end
    ylim([-1 length(HPCOrderChans)])
    
    subplot(2,2,4)
    All=[];
    for k=1:length(HPCOrderChans)
        All=[All;EigVect(:,2)'*DatMat*EigVect(k,2)];
    end
    imagesc(M(:,1),[1:length(HPCOrderChans)-2],interp2(diff(diff(All)),3)), hold on,axis xy
    for k=1:16
        plot(M(:,1),EigVect(:,2)'*DatMat*EigVect(k,2)*0.4+(k-1),'color','k','linewidth',2)
    end
    ylim([-1 length(HPCOrderChans)])
    
    figure
    for i=1:2
        subplot(2,3,1+(i-1)*3)
        All=[];
        for k=1:length(HPCOrderChans)
            plot(M(:,1),EigVect(:,i)'*DatMat*EigVect(k,i)+(k-1),'color',cols(k+1,:),'linewidth',2); hold on
            All=[All;EigVect(:,i)'*DatMat*EigVect(k,i)];
        end
        ylim([-2 17]),line([0 0],ylim,'color','k','linewidth',3)
        title('LFP')
        subplot(2,3,2+(i-1)*3)
        Deriv1=diff(All);
        for k=1:length(HPCOrderChans)-2
            plot(M(:,1),Deriv1(k,:)+(k-1)+0.5,'color',cols(k+1,:),'linewidth',2); hold on
        end
        ylim([-2 length(HPCOrderChans)+1]),line([0 0],ylim,'color','k','linewidth',3)
        title('Deriv1')
        subplot(2,3,3+(i-1)*3)
        Deriv2=diff(diff(All));
        for k=1:length(HPCOrderChans)-2
            plot(M(:,1),Deriv2(k,:)+(k-1)+1,'color',cols(k+1,:),'linewidth',2); hold on
        end
        ylim([-2 length(HPCOrderChans)+1]),line([0 0],ylim,'color','k','linewidth',3)
        title('Deriv2')
    end
    
    figure
    subplot(131)
    hold on
    for k=1:length(HPCOrderChans)
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(132)
    hold on
    Deriv1=diff(HPCTrigBreath);
    for k=1:length(HPCOrderChans)-1
        plot(M(:,1),Deriv1(k,:)-k*400-200,'color',cols(k+1,:),'linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('Deriv 1')
    subplot(133)
    hold on
    Deriv2=diff(diff(HPCTrigBreath));
    for k=1:length(HPCOrderChans)-2
        plot(M(:,1),Deriv2(k,:)-k*400-400,'color',cols(k+1,:),'linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('Deriv 2')
end

for i=1:TriggerOnTheta
    MovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),100));
    RunEpoch=thresholdIntervals(MovAcctsd,6*1E7,'Direction','Above');
    RunEpoch=dropShortIntervals(RunEpoch,1*1E4);
    RunEpoch=FreezeEpoch;
    load(['LFPData/LFP',num2str(HPCOrderChans(7)),'.mat'])
    LFPHPC=LFP;
    LFPHPC=FilterLFP(LFPHPC,[4 12],1024);
    LFPHPCHil=hilbert(Data(LFPHPC));
    LFPHPCPhase=angle(LFPHPCHil);
    Phasetsd=tsd(Range(LFPHPC),LFPHPCPhase);
    Phasetsd=Restrict(Phasetsd,RunEpoch);
    TopBreath=thresholdIntervals(Phasetsd,3.1,'Direction','Above');
    clear HPCTrigBreath
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        [M,T]=PlotRipRaw(LFP,Start(TopBreath,'s'),300,0,0);
        HPCTrigBreath(c,:)=M(:,2);
    end
    figure
    subplot(131)
    hold on
    for k=1:length(HPCOrderChans)
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(132)
    imagesc(M(:,1),[1:size(HPCTrigBreath,1)],HPCTrigBreath),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(133)
    HPCTrigBreathCSD=interp2(diff(diff(HPCTrigBreath)),3);
    imagesc(M(:,1),[1:size(HPCTrigBreathCSD,1)],HPCTrigBreathCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
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


for i=1:MakeCohFigs
    for c=1:length(HPCOrderChans)
        chan2=HPCOrderChans(c);
        load(['LowSpectrum/HPCProbe',num2str(HPCOrderChans(c)),'_Low_Spectrum.mat'])
        Sptsd=tsd(Spectro{2}*1E4,Spectro{1});
        AllSpec(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllSpecMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        load(['CohgramcDataL/Cohgram_OB_HPC',num2str(chan2),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        load(['CohgramcDataL/Cohgram_PFCx_HPC',num2str(chan2),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohPFCx(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohPFCxMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
    end
    
    
    for c=1:length(HPCOrderChans)-1
        load(['CohgramcDataL/Cohgram_OB_HPCDiff',num2str(c),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohDiffOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohDiffOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        load(['CohgramcDataL/Cohgram_PFCx_HPCDiff',num2str(c),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohDiffPFCx(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohDiffPFCxMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
    end
    
    for c=1:length(HPCOrderChans)-2
        load(['CohgramcDataL/Cohgram_OB_HPCCSD',num2str(c),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohCSDOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohCSDOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        load(['CohgramcDataL/Cohgram_PFCx_HPCCSD',num2str(c),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohCSDPFCx(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohCSDPFCxMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
    end
    
    figure
    subplot(231)
    imagesc(f,[1:size(AllCohPFCx,1)],AllCohPFCx),clim([0.4 0.7])
    line([8 8],ylim,'linewidth',3,'color','w')
    title('Coh LFP HPC / LFP PFCx')
    xlabel('Frequency (Hz)')
    subplot(232)
    imagesc(f,[1:size(AllCohDiffPFCx,1)],AllCohDiffPFCx),clim([0.4 0.7])
    title('Coh Diff HPC / LFP PFCx')
    xlabel('Frequency (Hz)')
    line([8 8],ylim,'linewidth',3,'color','w')
    subplot(233)
    imagesc(f,[1:size(AllCohCSDPFCx,1)],AllCohCSDPFCx),clim([0.4 0.7])
    title('Coh CSD HPC / LFP PFCx')
    xlabel('Frequency (Hz)')
    line([8 8],ylim,'linewidth',3,'color','w')
    
    subplot(234)
    imagesc(f,[1:size(AllCohOB,1)],AllCohOB),clim([0.4 0.7])
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
    subplot(231)
    imagesc(f,[1:size(AllCohPFCxMov,1)],AllCohPFCxMov),clim([0.4 0.7])
    title('Coh LFP HPC / LFP PFCx')
    xlabel('Frequency (Hz)')
    line([8 8],ylim,'linewidth',3,'color','w')
    subplot(232)
    imagesc(f,[1:size(AllCohDiffPFCxMov,1)],AllCohDiffPFCxMov),clim([0.4 0.7])
    title('Coh Diff HPC / LFP PFCx')
    xlabel('Frequency (Hz)')
    line([8 8],ylim,'linewidth',3,'color','w')
    subplot(233)
    imagesc(f,[1:size(AllCohCSDPFCxMov,1)],AllCohCSDPFCxMov),clim([0.4 0.7])
    title('Coh CSD HPC / LFP PFCx')
    xlabel('Frequency (Hz)')
    line([8 8],ylim,'linewidth',3,'color','w')
    
    subplot(234)
    imagesc(f,[1:size(AllCohOBMov,1)],AllCohOBMov),clim([0.4 0.7])
    title('Coh LFP HPC / LFP OB')
    xlabel('Frequency (Hz)')
    subplot(235)
    imagesc(f,[1:size(AllCohDiffOBMov,1)],AllCohDiffOBMov),clim([0.4 0.7])
    title('Coh CSD HPC / LFP OB')
    xlabel('Frequency (Hz)')
    subplot(236)
    imagesc(f,[1:size(AllCohCSDOBMov,1)],AllCohCSDOBMov),clim([0.4 0.7])
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
end
%%
for i=1:DoRandCoh
    disp('DoRandCoh')
    NumPerm=100;
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOB=LFP;
    load('ChannelsToAnalyse/PFCx_deep.mat')
    PFCxChan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPPFC=LFP;
    [params,movingwin,suffix]=SpectrumParametersML('low');
    params.fpass=[0.1 10];
    datOB=Data(Restrict(LFPOB,FreezeEpoch));
    datPFC=Data(Restrict(LFPPFC,FreezeEpoch));
    for c=1:length(HPCOrderChans)
        c
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        datHPC=Data(Restrict(LFP,FreezeEpoch));
        for randnum=1:NumPerm
            randnum
            if randnum==1
                dat1=datHPC;
            else
                snip=max([floor(size(datHPC,1)*rand),1]);
                dat1=datHPC([snip+1:end,1:snip]);
            end
            % OB
            [C,phi,S12,S1,S2,~,f,confC,phistd]=cohgramc(dat1,datOB,movingwin,params);
            ShuffCohOB{randnum}(c,:)=mean(C);
            clear C
            % PFC
            [C,phi,S12,S1,S2,~ ,f,confC,phistd]=cohgramc(dat1,datPFC,movingwin,params);
            ShuffCohPFC{randnum}(c,:)=mean(C);
            clear dat1 dat2 C
        end
    end
    save('RandomCoherenceLFPs.mat','ShuffCohOB','ShuffCohPFC')
end

for i=1:DoRandCohCSD
    disp('DoRandCohCSD')
    NumPerm=100;
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOB=LFP;
    load('ChannelsToAnalyse/PFCx_deep.mat')
    PFCxChan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPPFC=LFP;
    [params,movingwin,suffix]=SpectrumParametersML('low');
    params.fpass=[0.1 10];
    datOB=Data(Restrict(LFPOB,FreezeEpoch));
    datPFC=Data(Restrict(LFPPFC,FreezeEpoch));
    
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        AllChans(c,:)=Data(LFP);
    end
    lfp=[Range(LFP),AllChans'];
    csd = CSD(lfp);
    csd=csd(:,2:end);
    
    for el=1:size(csd,2)
        ctsd=tsd(Range(LFP),csd(:,el));
        datHPC=Data(Restrict(ctsd,FreezeEpoch));
        for randnum=1:NumPerm
            randnum
            if randnum==1
                dat1=datHPC;
            else
                snip=max([floor(size(datHPC,1)*rand),1]);
                dat1=datHPC([snip+1:end,1:snip]);
            end
            % OB
            [C,phi,S12,S1,S2,~,f,confC,phistd]=cohgramc(dat1,datOB,movingwin,params);
            ShuffCohCSDOB{randnum}(el,:)=mean(C);
            clear C
            % PFC
            [C,phi,S12,S1,S2,~ ,f,confC,phistd]=cohgramc(dat1,datPFC,movingwin,params);
            ShuffCohCSDPFC{randnum}(el,:)=mean(C);
            clear dat1 dat2 C
        end
    end
    save('RandomCoherenceCSDs.mat','ShuffCohCSDPFC','ShuffCohCSDOB')
end

for i=1:DoRandCohDiff
    disp('DoRandCohDiff')
    NumPerm=100;
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOB=LFP;
    load('ChannelsToAnalyse/PFCx_deep.mat')
    PFCxChan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPPFC=LFP;
    [params,movingwin,suffix]=SpectrumParametersML('low');
    params.fpass=[0.1 10];
    datOB=Data(Restrict(LFPOB,FreezeEpoch));
    datPFC=Data(Restrict(LFPPFC,FreezeEpoch));
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        AllChans(c,:)=Data(LFP);
    end
    csd=diff(AllChans)';
    
    for el=1:size(csd,2)
        ctsd=tsd(Range(LFP),csd(:,el));
        datHPC=Data(Restrict(ctsd,FreezeEpoch));
        for randnum=1:NumPerm
            randnum
            if randnum==1
                dat1=datHPC;
            else
                snip=max([floor(size(datHPC,1)*rand),1]);
                dat1=datHPC([snip+1:end,1:snip]);
            end
            % OB
            [C,phi,S12,S1,S2,~,f,confC,phistd]=cohgramc(dat1,datOB,movingwin,params);
            ShuffCohOBDiff{randnum}(el,:)=mean(C);
            clear C
            % PFC
            [C,phi,S12,S1,S2,~ ,f,confC,phistd]=cohgramc(dat1,datPFC,movingwin,params);
            ShuffCohPFCDiff{randnum}(el,:)=mean(C);
            clear dat1 dat2 C
        end
    end
    save('RandomCoherenceDiffs.mat','ShuffCohPFCDiff','ShuffCohOBDiff')
end

for i=1:DoDiff
    disp('calculating coherence on diff of wires')
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOB=LFP;
    load('ChannelsToAnalyse/PFCx_deep.mat')
    PFCxChan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPPFC=LFP;
    filenameSp='/Users/sophiebagur/Desktop/M514_170322/LowSpectrum/';
    [params,movingwin,suffix]=SpectrumParametersML('low');
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        AllChans(c,:)=Data(LFP);
    end
    csd=diff(AllChans)';
    for el=1:size(csd,2)
        ctsd=tsd(Range(LFP),csd(:,el));
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPPFC),Data(ctsd),movingwin,params);
        chan1=PFCxChan;
        chan2=el;
        save(['CohgramcDataL/Cohgram_PFCx_HPCDiff',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPOB),Data(ctsd),movingwin,params);
        chan1=OBchan;
        chan2=el;
        save(['CohgramcDataL/Cohgram_OB_HPCDiff',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
    end
end

for i=1:DoRandCohFigs
    Band4=[find(f<3,1,'last'):find(f<5,1,'last')];
    Band7=[find(f<5,1,'last'):find(f<8,1,'last')];
    FacftSTD=-Inf;
    clear RealDataSig
    load('RandomCoherenceLFPs.mat')
    for el=1:size(ShuffCohOB{1},1)
        RealData=ShuffCohOB{1}(el,:);
        RandData=[];
        for i=2:size(ShuffCohOB,2)
            RandData=[RandData;ShuffCohOB{i}(el,:)];
        end
        Limtemp=mean(RandData)+FactSTD*std(RandData);
        RealData(RealData<Limtemp)=NaN;
        RealDataSig(el,:)=RealData;
        Lim.OB.F4Hz.STD(el)=std(mean(RandData(:,Band4)'));
        Lim.OB.F4Hz.MEAN(el)=mean(mean(RandData(:,Band4)'));
        Lim.OB.F7Hz.STD(el)=std(mean(RandData(:,Band7)'));
        Lim.OB.F7Hz.MEAN(el)=mean(mean(RandData(:,Band7)'));
    end
    subplot(231)
    imagesc([1:length(RealDataSig)],f,RealDataSig), clim([0.4 0.7])
    clear RealDataSig
    load('RandomCoherenceDiffs.mat')
    for el=1:size(ShuffCohOBDiff{1},1)
        RealData=ShuffCohOBDiff{1}(el,:);
        RandData=[];
        for i=2:size(ShuffCohOBDiff,2)
            RandData=[RandData;ShuffCohOBDiff{i}(el,:)];
        end
        LimTemp=mean(RandData)+FactSTD*std(RandData);
        RealData(RealData<LimTemp)=NaN;
        RealDataSig(el,:)=RealData;
        Lim.OBDiff.F4Hz.STD(el)=std(mean(RandData(:,Band4)'));
        Lim.OBDiff.F4Hz.MEAN(el)=mean(mean(RandData(:,Band4)'));
        Lim.OBDiff.F7Hz.STD(el)=std(mean(RandData(:,Band7)'));
        Lim.OBDiff.F7Hz.MEAN(el)=mean(mean(RandData(:,Band7)'));
    end
    subplot(232)
    imagesc(f,[1:size(RealDataSig,1)],RealDataSig), clim([0.4 0.7])
    load('RandomCoherenceCSDs.mat')
    clear RealDataSig
    for el=1:size(ShuffCohCSDOB{1},1)
        RealData=ShuffCohCSDOB{1}(el,:);
        RandData=[];
        for i=2:size(ShuffCohCSDOB,2)
            RandData=[RandData;ShuffCohCSDOB{i}(el,:)];
        end
        LimTemp=mean(RandData)+FactSTD*std(RandData);
        RealData(RealData<LimTemp)=NaN;
        RealDataSig(el,:)=RealData;
        Lim.OBCSD.F4Hz.STD(el)=std(mean(RandData(:,Band4)'));
        Lim.OBCSD.F4Hz.MEAN(el)=mean(mean(RandData(:,Band4)'));
        Lim.OBCSD.F7Hz.STD(el)=std(mean(RandData(:,Band7)'));
        Lim.OBCSD.F7Hz.MEAN(el)=mean(mean(RandData(:,Band7)'));
    end
    subplot(233)
    imagesc(f,[1:size(RealDataSig,1)],RealDataSig), clim([0.4 0.7])
    
    clear RealDataSig
    load('RandomCoherenceLFPs.mat')
    for el=1:size(ShuffCohPFC{1},1)
        RealData=ShuffCohPFC{1}(el,:);
        RandData=[];
        for i=2:size(ShuffCohPFC,2)
            RandData=[RandData;ShuffCohPFC{i}(el,:)];
        end
        LimTemp=mean(RandData)+FactSTD*std(RandData);
        RealData(RealData<LimTemp)=NaN;
        RealDataSig(el,:)=RealData;
        Lim.PFC.F4Hz.STD(el)=std(mean(RandData(:,Band4)'));
        Lim.PFC.F4Hz.MEAN(el)=mean(mean(RandData(:,Band4)'));
        Lim.PFC.F7Hz.STD(el)=std(mean(RandData(:,Band7)'));
        Lim.PFC.F7Hz.MEAN(el)=mean(mean(RandData(:,Band7)'));
    end
    subplot(234)
    imagesc(f,[1:size(RealDataSig,1)],RealDataSig), clim([0.4 0.7])
    clear RealDataSig
    load('RandomCoherenceDiffs.mat')
    for el=1:size(ShuffCohPFCDiff{1},1)
        RealData=ShuffCohPFCDiff{1}(el,:);
        RandData=[];
        for i=2:size(ShuffCohPFCDiff,2)
            RandData=[RandData;ShuffCohPFCDiff{i}(el,:)];
        end
        LimTemp=mean(RandData)+FactSTD*std(RandData);
        RealData(RealData<LimTemp)=NaN;
        RealDataSig(el,:)=RealData;
        Lim.PFCDiff.F4Hz.STD(el)=std(mean(RandData(:,Band4)'));
        Lim.PFCDiff.F4Hz.MEAN(el)=mean(mean(RandData(:,Band4)'));
        Lim.PFCDiff.F7Hz.STD(el)=std(mean(RandData(:,Band7)'));
        Lim.PFCDiff.F7Hz.MEAN(el)=mean(mean(RandData(:,Band7)'));
    end
    subplot(235)
    imagesc(f,[1:size(RealDataSig,1)],RealDataSig), clim([0.4 0.7])
    load('RandomCoherenceCSDs.mat')
    clear RealDataSig
    for el=1:size(ShuffCohCSDPFC{1},1)
        RealData=ShuffCohCSDPFC{1}(el,:);
        RandData=[];
        for i=2:size(ShuffCohCSDPFC,2)
            RandData=[RandData;ShuffCohCSDPFC{i}(el,:)];
        end
        LimTemp=mean(RandData)+FactSTD*std(RandData);
        RealData(RealData<LimTemp)=NaN;
        RealDataSig(el,:)=RealData;
        Lim.PFCCSD.F4Hz.STD(el)=std(mean(RandData(:,Band4)'));
        Lim.PFCCSD.F4Hz.MEAN(el)=mean(mean(RandData(:,Band4)'));
        Lim.PFCCSD.F7Hz.STD(el)=std(mean(RandData(:,Band7)'));
        Lim.PFCCSD.F7Hz.MEAN(el)=mean(mean(RandData(:,Band7)'));
    end
    subplot(236)
    imagesc(f,[1:size(RealDataSig,1)],RealDataSig), clim([0.4 0.7])
    
    
    
    figure
    FactSTD=2.7;
    subplot(411)
    plot([1:16],mean(ShuffCohOB{1}(:,Band4)'),'linewidth',3), hold on
    plot([1.5:15.5],mean(ShuffCohOBDiff{1}(:,Band4)'),'linewidth',3)
    plot([2:15],mean(ShuffCohCSDOB{1}(:,Band4)'),'linewidth',3)
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
end

for i=1:DoMNCoupling
    % MNCoupling
    MNRatio=[1,1;1.5,1;2,1;3,1;4,1;5,1];
    DoStats=100 ;
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOBdeep=LFP;
    load('ChannelsToAnalyse/Bulb_sup.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOBsup=LFP;
    LFPOB=tsd(Range(LFPOBsup),Data(LFPOBsup)-Data(LFPOBdeep));
    LFPOB=FilterLFP(LFPOB,[2.5 5.5],1024);
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        LFPHPC=FilterLFP(LFP,[6 9],1024);
        [Index.Volt{c},IndexRand.Volt{c},FinalSig.Volt{c}]=PhaseCouplingSlowOscillMNRatio(LFPOB,LFPHPC,FreezeEpoch,DoStats,0,MNRatio);
        AllChans(c,:)=Data(LFP);
    end
    diffvolt=diff(AllChans)';
    for c=1:size(diffvolt,2)
        LFPHPC=FilterLFP(tsd(Range(LFP),diffvolt(:,c)),[6 9],1024);
        [Index.Diff{c},IndexRand.Diff{c},FinalSig.Diff{c}]=PhaseCouplingSlowOscillMNRatio(LFPOB,LFPHPC,FreezeEpoch,DoStats,0,MNRatio);
    end
    lfp=[Range(LFP),AllChans'];
    csd = CSD(lfp);
    csd=csd(:,2:end);
    for c=1:size(csd,2)
        LFPHPC=FilterLFP(tsd(Range(LFP),csd(:,c)),[6 9],1024);
        [Index.CSD{c},IndexRand.CSD{c},FinalSig.CSD{c}]=PhaseCouplingSlowOscillMNRatio(LFPOB,LFPHPC,FreezeEpoch,DoStats,0,MNRatio);
    end
    save('MNCouplingDiffOB.mat','Index','IndexRand','FinalSig')
    
    FreqNum=3;
    for k=1:16
        AllVals.Shannon(k)=Index.Volt{k}.Shannon(FreqNum);
        AllValsRand.Shannon(k)=prctile(IndexRand.Volt{k}.Shannon(FreqNum,:),99);
        AllVals.VectLength(k)=Index.Volt{k}.VectLength(FreqNum);
        AllValsRand.VectLength(k)=prctile(IndexRand.Volt{k}.VectLength(FreqNum,:),99);
    end
    for k=1:15
        AllValsDiff.Shannon(k)=Index.Diff{k}.Shannon(FreqNum);
        AllValsRandDiff.Shannon(k)=prctile(IndexRand.Diff{k}.Shannon(FreqNum,:),99);
        AllValsDiff.VectLength(k)=Index.Diff{k}.VectLength(FreqNum);
        AllValsRandDiff.VectLength(k)=prctile(IndexRand.Diff{k}.VectLength(FreqNum,:),99);
    end
    for k=1:14
        AllValsCSD.Shannon(k)=Index.CSD{k}.Shannon(FreqNum);
        AllValsRandCSD.Shannon(k)=prctile(IndexRand.CSD{k}.Shannon(FreqNum,:),99);
        AllValsCSD.VectLength(k)=Index.CSD{k}.VectLength(FreqNum);
        AllValsRandCSD.VectLength(k)=prctile(IndexRand.CSD{k}.VectLength(FreqNum,:),99);
    end
    
    figure
    subplot(121)
    plot(AllVals.Shannon,[16:-1:1],'linewidth',3), hold on
    plot(AllValsDiff.Shannon,[15.5:-1:1.5],'linewidth',3), hold on
    plot(AllValsCSD.Shannon,[15:-1:2],'linewidth',3), hold on
    plot(AllValsRand.Shannon,[16:-1:1],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandDiff.Shannon,[15.5:-1:1.5],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandCSD.Shannon,[15:-1:2],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    ylim([1 16])
    subplot(122)
    plot(AllVals.VectLength,[16:-1:1],'linewidth',3), hold on
    plot(AllValsDiff.VectLength,[15.5:-1:1.5],'linewidth',3), hold on
    plot(AllValsCSD.VectLength,[15:-1:2],'linewidth',3), hold on
    plot(AllValsRand.VectLength,[16:-1:1],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandDiff.VectLength,[15.5:-1:1.5],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandCSD.VectLength,[15:-1:2],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    ylim([1 16])
end


for i=1:DoMNCouplingBelluscioMethod
    OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
    OptionsMiniMaxi.FilBand=[1 20];
    OptionsMiniMaxi.std=[0.5 0.2];
    OptionsMiniMaxi.TimeLim=0.07;
    
    
    % MNCoupling
    MNRatio=[1,1;1.5,1;2,1;3,1;4,1;5,1];
    DoStats=100;
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOBdeep=LFP;
    load('ChannelsToAnalyse/Bulb_sup.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOBsup=LFP;
    LFPOB=tsd(Range(LFPOBsup),Data(LFPOBsup)-Data(LFPOBdeep));
    AllPeaks=FindPeaksForFrequency(LFPOB,OptionsMiniMaxi,0);
    AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
    Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFP,'s'));
    if AllPeaks(1,2)==1
        PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
    else
        PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
    end
    SigOB=PhaseInterpol;
    clear LFP PhaseInterpol
    
    disp('Volt coupling')
    for c=1:length(HPCOrderChans)
        disp(num2str(c))
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        AllPeaks=FindPeaksForFrequency(LFP,OptionsMiniMaxi,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(SigOB,'s'));
        if AllPeaks(1,2)==1
            PhaseInterpol=tsd(Range(SigOB),mod(Y,2*pi));
        else
            PhaseInterpol=tsd(Range(SigOB),mod(Y+pi,2*pi));
        end
        AllChans(c,:)=Data(LFP);
        SigHPC=PhaseInterpol;
        clear LFP PhaseInterpol
        [Index.LFP{c},IndexRand.LFP{c}]=PhaseCouplingSlowOscillSameFreqMiniMaxi(SigHPC,SigOB,FreezeEpoch,DoStats,0,MNRatio);
    end
    disp('Current coupling')
    diffvolt=diff(AllChans)';
    for c=6:size(diffvolt,2)
        disp(num2str(c))
        LFPHPC=tsd(Range(SigOB),diffvolt(:,c));
        AllPeaks=FindPeaksForFrequency(LFPHPC,OptionsMiniMaxi,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFPHPC,'s'));
        if AllPeaks(1,2)==1
            PhaseInterpol=tsd(Range(LFPHPC),mod(Y,2*pi));
        else
            PhaseInterpol=tsd(Range(LFPHPC),mod(Y+pi,2*pi));
        end
        SigHPC=PhaseInterpol;
        clear LFPHPC PhaseInterpol
        [Index.Diff{c},IndexRand.Diff{c}]=PhaseCouplingSlowOscillSameFreqMiniMaxi(SigHPC,SigOB,FreezeEpoch,DoStats,0,MNRatio);
    end
    disp('CSD coupling')
    lfp=[Range(SigHPC),AllChans'];
    csd = CSD(lfp);
    csd=csd(:,2:end);
    for c=1:size(csd,2)
        disp(num2str(c))
        LFPHPC=tsd(Range(SigOB),csd(:,c));
        AllPeaks=FindPeaksForFrequency(LFPHPC,OptionsMiniMaxi,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFPHPC,'s'));
        if AllPeaks(1,2)==1
            PhaseInterpol=tsd(Range(LFPHPC),mod(Y,2*pi));
        else
            PhaseInterpol=tsd(Range(LFPHPC),mod(Y+pi,2*pi));
        end
        SigHPC=PhaseInterpol;
        clear LFPHPC PhaseInterpol
        [Index.CSD{c},IndexRand.CSD{c}]=PhaseCouplingSlowOscillSameFreqMiniMaxi(SigHPC,SigOB,FreezeEpoch,DoStats,0,MNRatio);
    end
    save('MNCouplingBelluscioMethodLocalOB.mat','Index','IndexRand','FinalSig')
    
    keyboard
    FreqNum=3;
    for k=1:16
        AllVals.Shannon(k)=Index.Volt{k}.Shannon(FreqNum);
        AllValsRand.Shannon(k)=prctile(IndexRand.Volt{k}.Shannon(FreqNum,:),99);
        AllVals.VectLength(k)=Index.Volt{k}.VectLength(FreqNum);
        AllValsRand.VectLength(k)=prctile(IndexRand.Volt{k}.VectLength(FreqNum,:),99);
    end
    for k=1:15
        AllValsDiff.Shannon(k)=Index.Diff{k}.Shannon(FreqNum);
        AllValsRandDiff.Shannon(k)=prctile(IndexRand.Diff{k}.Shannon(FreqNum,:),99);
        AllValsDiff.VectLength(k)=Index.Diff{k}.VectLength(FreqNum);
        AllValsRandDiff.VectLength(k)=prctile(IndexRand.Diff{k}.VectLength(FreqNum,:),99);
    end
    for k=1:14
        AllValsCSD.Shannon(k)=Index.CSD{k}.Shannon(FreqNum);
        AllValsRandCSD.Shannon(k)=prctile(IndexRand.CSD{k}.Shannon(FreqNum,:),99);
        AllValsCSD.VectLength(k)=Index.CSD{k}.VectLength(FreqNum);
        AllValsRandCSD.VectLength(k)=prctile(IndexRand.CSD{k}.VectLength(FreqNum,:),99);
    end
    
    figure
    subplot(121)
    plot(AllVals.Shannon,[16:-1:1],'linewidth',3), hold on
    plot(AllValsDiff.Shannon,[15.5:-1:1.5],'linewidth',3), hold on
    plot(AllValsCSD.Shannon,[15:-1:2],'linewidth',3), hold on
    plot(AllValsRand.Shannon,[16:-1:1],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandDiff.Shannon,[15.5:-1:1.5],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandCSD.Shannon,[15:-1:2],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    ylim([1 16])
    subplot(122)
    plot(AllVals.VectLength,[16:-1:1],'linewidth',3), hold on
    plot(AllValsDiff.VectLength,[15.5:-1:1.5],'linewidth',3), hold on
    plot(AllValsCSD.VectLength,[15:-1:2],'linewidth',3), hold on
    plot(AllValsRand.VectLength,[16:-1:1],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandDiff.VectLength,[15.5:-1:1.5],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    plot(AllValsRandCSD.VectLength,[15:-1:2],'linewidth',3,'color',[0.6 0.6 0.6]), hold on
    ylim([1 16])
end


for i=1:TriggerOnBreathingMov
    load('ChannelsToAnalyse/Bulb_deep.mat')
    OBchan=channel;
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPOB=LFP;
    LFPOB=FilterLFP(LFPOB,[2 6],1024);
    LFPOBHil=hilbert(Data(LFPOB));
    LFPOBPhase=angle(LFPOBHil);
    Phasetsd=tsd(Range(LFPOB),LFPOBPhase);
    Phasetsd=Restrict(Phasetsd,RunEpoch);
    TopBreath=thresholdIntervals(Phasetsd,3.1,'Direction','Above');
    clear HPCTrigBreath
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        [M,T]=PlotRipRaw(LFP,Start(TopBreath,'s'),500,0,0);
        HPCTrigBreath(c,:)=M(:,2);
    end
    
    figure
    subplot(131)
    hold on
    for k=1:16
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(132)
    imagesc(M(:,1),[1:14],HPCTrigBreath),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(133)
    HPCTrigBreathCSD=interp2(diff(diff(HPCTrigBreath)),3);
    imagesc(M(:,1),[1:14],HPCTrigBreathCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
    
     figure
    subplot(121)
    hold on
    for k=1:16
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    title('LFP')
    subplot(122)
    HPCTrigBreathCSD=interp2(diff(diff(HPCTrigBreath)),3);
    imagesc(M(:,1),[1:14],HPCTrigBreathCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
    
    figure
    DatMat=zscore(HPCTrigBreath')';
    [EigVect,EigVals]=PerformPCA(DatMat);
    [val,ind]=max(abs(EigVect(:,1)));EigVect(:,1)=EigVect(:,1)*sign(EigVect(ind,1));
    [val,ind]=max(abs(EigVect(:,2)));EigVect(:,2)=EigVect(:,2)*sign(EigVect(ind,2));
    
    subplot(2,2,1), hold on
    plot(EigVect(:,1),-[0:15],'linewidth',2)
    plot(EigVect(:,2),-[0:15],'r','linewidth',2)
    ylim([-16 1])
    
    subplot(2,2,2)
    hold on
    plot(M(:,1),EigVect(:,1)'*DatMat,'linewidth',2)
    plot(M(:,1),EigVect(:,2)'*DatMat,'r','linewidth',2)
    
    subplot(2,2,3)
    All=[];
    for k=1:16
        All=[All;EigVect(:,1)'*DatMat*EigVect(k,1)];
    end
    imagesc(M(:,1),[1:14],interp2(diff(diff(All)),3)), hold on,axis xy
    for k=1:16
        plot(M(:,1),EigVect(:,1)'*DatMat*EigVect(k,1)*0.4+(k-1),'color','k','linewidth',2)
    end
    ylim([-1 16])
    
    subplot(2,2,4)
    All=[];
    for k=1:16
        All=[All;EigVect(:,2)'*DatMat*EigVect(k,2)];
    end
    imagesc(M(:,1),[1:14],interp2(diff(diff(All)),3)), hold on,axis xy
    for k=1:16
        plot(M(:,1),EigVect(:,2)'*DatMat*EigVect(k,2)*0.4+(k-1),'color','k','linewidth',2)
    end
    ylim([-1 16])
    
    figure
    for i=1:2
        subplot(2,3,1+(i-1)*3)
        All=[];
        for k=1:16
            plot(M(:,1),EigVect(:,i)'*DatMat*EigVect(k,i)+(k-1),'color',cols(k+1,:),'linewidth',2); hold on
            All=[All;EigVect(:,i)'*DatMat*EigVect(k,i)];
        end
        ylim([-2 17]),line([0 0],ylim,'color','k','linewidth',3)
        title('LFP')
        subplot(2,3,2+(i-1)*3)
        Deriv1=diff(All);
        for k=1:14
            plot(M(:,1),Deriv1(k,:)+(k-1)+0.5,'color',cols(k+1,:),'linewidth',2); hold on
        end
        ylim([-2 17]),line([0 0],ylim,'color','k','linewidth',3)
        title('Deriv1')
        subplot(2,3,3+(i-1)*3)
        Deriv2=diff(diff(All));
        for k=1:13
            plot(M(:,1),Deriv2(k,:)+(k-1)+1,'color',cols(k+1,:),'linewidth',2); hold on
        end
        ylim([-2 17]),line([0 0],ylim,'color','k','linewidth',3)
        title('Deriv2')
    end
    
    figure
    subplot(131)
    hold on
    for k=1:16
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(132)
    hold on
    Deriv1=diff(HPCTrigBreath);
    for k=1:15
        plot(M(:,1),Deriv1(k,:)-k*400-200,'color',cols(k+1,:),'linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('Deriv 1')
    subplot(133)
    hold on
    Deriv2=diff(diff(HPCTrigBreath));
    for k=1:14
        plot(M(:,1),Deriv2(k,:)-k*400-400,'color',cols(k+1,:),'linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('Deriv 2')
end



for i=1:TriggerOnLowThetaFz
    
    load(['LFPData/LFP',num2str(HPCOrderChans(7)),'.mat'])
    LFPOB=LFP;
    LFPOB=FilterLFP(LFPOB,[5 8],1024);
    LFPOBHil=hilbert(Data(LFPOB));
    LFPOBPhase=angle(LFPOBHil);
    Phasetsd=tsd(Range(LFPOB),LFPOBPhase);
    Phasetsd=Restrict(Phasetsd,FreezeEpoch);
    TopBreath=thresholdIntervals(Phasetsd,3.1,'Direction','Above');
    clear HPCTrigBreath
    for c=1:length(HPCOrderChans)
        load(['LFPData/LFP',num2str(HPCOrderChans(c)),'.mat'])
        [M,T]=PlotRipRaw(LFP,Start(TopBreath,'s'),300,0,0);
        HPCTrigBreath(c,:)=M(:,2);
    end
    
     figure
    subplot(121)
    hold on
    for k=1:16
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    title('LFP')
    subplot(122)
    HPCTrigBreathCSD=interp2(diff(diff(HPCTrigBreath)),3);
    imagesc(M(:,1),[1:14],HPCTrigBreathCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
    colorbar
    caxis([-500 500])
    
    figure
    subplot(131)
    hold on
    for k=1:16
        plot(M(:,1),HPCTrigBreath(k,:)-k*900,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(132)
    imagesc(M(:,1),[1:14],HPCTrigBreath),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('LFP')
    subplot(133)
    HPCTrigBreathCSD=interp2(diff(diff(HPCTrigBreath)),3);
    imagesc(M(:,1),[1:14],HPCTrigBreathCSD),hold on
    line([0 0],ylim,'color','k','linewidth',3)
    title('CSD')
    
     
end