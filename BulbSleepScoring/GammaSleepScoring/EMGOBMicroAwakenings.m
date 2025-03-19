clear all, close all
smootime=0.5;
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
% filename{m,2}=18;



clear emg gam
for mm=1:m

    cd(filename{mm})
    
    
    load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
    load('ChannelsToAnalyse/EMG.mat')
    load(['LFPData/LFP',num2str(channel),'.mat']);
    FilLFP=FilterLFP(LFP,[50 300],1024);
    HilEMG=hilbert(Data(FilLFP));
    H=abs(HilEMG);
    tot_emg=Restrict(tsd(Range(LFP),H),Epoch);
    smooth_emg=tsd(Range(tot_emg),runmean(Data(tot_emg),ceil(smootime/median(diff(Range(tot_emg,'s'))))));
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat']);
    FilGamma=FilterLFP(LFP,[50 70],1024);
    HilGamma=hilbert(Data(FilGamma));
    H=abs(HilGamma);
    tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
    smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
    
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP',num2str(channel),'.mat']);
    [paramsL,movingwinL]=SpectrumParametersML('low',0);
    [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
    [Spectro{1},Spectro{2},Spectro{3}]=mtspecgramc(y,movingwinL,paramsL);
    mnH=mean(Spectro{1}(:,20:end)');
    HPowtsd=tsd(Spectro{2}*1e4,runmean(mnH',ceil(smootime/median(diff(Spectro{2})))));
    HPowtsd=Restrict(HPowtsd,Epoch);
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    
    figure,hist(log(Data(smooth_emg)),1000);[x,y]=ginput(1);
    EMGwake=thresholdIntervals(smooth_emg,exp(x),'Direction','Above');
    EMGwake=mergeCloseIntervals(EMGwake,3*1e4);
    EMGwake=dropLongIntervals(EMGwake,10*1e4);
    
    figure,hist(log(Data(smooth_ghi)),1000);[x,y]=ginput(1);
    Gammawake=thresholdIntervals(smooth_ghi,exp(x),'Direction','Above');
    Gammawake=mergeCloseIntervals(Gammawake,3*1e4);
    Gammawake=dropLongIntervals(Gammawake,10*1e4);
    
    figure;
    temp=log(Data(smooth_emg));
    div=prctile(temp,95)-prctile(temp,5);
    plot(Range(smooth_emg,'s'),log(Data(smooth_emg))/div),hold on
    plot(Range(Restrict(smooth_emg,EMGwake),'s'),log(Data(Restrict(smooth_emg,EMGwake)))/div),
    temp=log(Data(smooth_ghi));
    div=prctile(temp,95)-prctile(temp,5);
    plot(Range(smooth_ghi,'s'),log(Data(smooth_ghi))/div-2),
    temp=log(Data(HPowtsd));
    div=prctile(temp,95)-prctile(temp,5);
    plot(Range(HPowtsd,'s'),log(Data(HPowtsd))/div-2),
    
    figure
    subplot(121)
    yyaxis left
    [M,S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Start(Gammawake)),100,200,0,1,1);hold on,
    imagesc(t/1E3,Spectro{3},SmoothDec(M,[2 2])), axis xy
    caxis([14 28])
    xlim([-9.5 9.5]),ylim([1 19])
    line([0 0],[0 20],'color','w')
    yyaxis right
    [M,T]=PlotRipRaw(HPowtsd,Start(Gammawake,'s'),10000,0,0);
    T(find(sum(T'==0)>10),:)=[];
    plot(M(:,1),mean(zscore(T')')')
    title('Gamma')
    
    subplot(122)
    yyaxis left
    [M,S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Start(EMGwake)),100,200,0,1,1);hold on,
    imagesc(t/1E3,Spectro{3},SmoothDec(M,[2 2])), axis xy
    caxis([14 28])
    xlim([-9.5 9.5]),ylim([1 19])
    line([0 0],[0 20],'color','w')
    yyaxis right
    [M,T]=PlotRipRaw(HPowtsd,Start(EMGwake,'s'),10000,0,0);
    T(find(sum(T'==0)>10),:)=[];
    plot(M(:,1),mean(zscore(T')')')
    title('EMG')
    
    figure
    [M,T]=PlotRipRaw(smooth_ghi,Start(Gammawake,'s'),10000,0,0);
    [M,T2]=PlotRipRaw(HPowtsd,Start(Gammawake,'s'),10000,0,0);
    T2(find(sum(T'==0)>10),:)=[];
    T(find(sum(T'==0)>10),:)=[];
    Window=[12530:15000];
    [MatNew,ind]=SortMat(T,Window);
    subplot(2,2,1)
    imagesc(M(:,1),[1:length(ind)],T(ind,:)),line([0 0],ylim,'color','w')
    title('Gamma')
    subplot(2,2,3)
    imagesc(M(:,1),[1:length(ind)],T2(ind,:)),line([0 0],ylim,'color','w')
    
    [M,T]=PlotRipRaw(smooth_emg,Start(EMGwake,'s'),10000,0,0);
    [M,T2]=PlotRipRaw(HPowtsd,Start(EMGwake,'s'),10000,0,0);
    T2(find(sum(T'==0)>10),:)=[];
    T(find(sum(T'==0)>10),:)=[];
    Window=[12530:15000];
    [MatNew,ind]=SortMat(T,Window);
    subplot(2,2,2)
    imagesc(M(:,1),[1:length(ind)],T(ind,:)),line([0 0],ylim,'color','w')
    title('EMG')
    subplot(2,2,4)
    imagesc(M(:,1),[1:length(ind)],T2(ind,:)),line([0 0],ylim,'color','w')
    
    
    figure
    [C, B] = CrossCorr(Start(EMGwake),Start(EMGwake), 8000, 250); C(126)=0;
    plot(B/1e3,C)
    [C, B] = CrossCorr(Start(Gammawake),Start(Gammawake), 8000, 250);C(126)=0;
    hold on
    plot(B/1e3,C)
    legend({'EMG','Gamma'})
end
