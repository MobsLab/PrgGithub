% Code Use for 11th april draft
clear all, close all
smootime=1;
EMGmice
%% Trigger EMG on OB transitions and OB on EMG transitions
% figures per mouse
% average over mice
wa
for mm=1:m
    mm
    cd (filename{mm,1})
    
    load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
    %     load('ChannelsToAnalyse/EMG.mat')
    %     load(['LFPData/LFP',num2str(channel),'.mat']);
    %     FilLFP=FilterLFP(LFP,[50 300],1024);
    %     HilEMG=hilbert(Data(FilLFP));
    %     H=abs(HilEMG);
    %     tot_emg=Restrict(tsd(Range(LFP),H),Epoch);
    %     smooth_emg=tsd(Range(tot_emg),runmean(Data(tot_emg),ceil(smootime/median(diff(Range(tot_emg,'s'))))));
    %
    %     load('ChannelsToAnalyse/Bulb_deep.mat')
    %     load(['LFPData/LFP',num2str(channel),'.mat']);
    %     FilGamma=FilterLFP(LFP,[50 70],1024);
    %     HilGamma=hilbert(Data(FilGamma));
    %     H=abs(HilGamma);
    %     tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
    %     smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
    %
    %     load('H_Low_Spectrum.mat')
    %     mnH=mean(Spectro{1}(:,20:end)');
    %     HPowtsd=tsd(Spectro{2}*1e4,runmean(mnH',ceil(smootime/median(diff(Spectro{2})))));
    %     HPowtsd=Restrict(HPowtsd,Epoch);
    load('ScoringShortSmoothingThresholds.mat','gamma_thresh','emg_thresh','bef_cellG','bef_cellE','smooth_emg','smooth_ghi','HPowtsd')
    
    %     emg_thresh=GetGammaThresh(Data(smooth_emg));
    %     EMGwake=thresholdIntervals(smooth_emg,exp(emg_thresh),'Direction','Above');
    %     EMGwake=mergeCloseIntervals(EMGwake,3*1e4);
    %     EMGSleep=Epoch-EMGwake;EMGSleep=dropShortIntervals(EMGSleep,5*1e4);
    %     EMGwake=dropShortIntervals(EMGwake,5*1e4);
    %     [aft_cellE,bef_cellE]=transEpoch(EMGSleep,EMGwake);
    %
%         gamma_thresh=GetGammaThresh(Data(smooth_ghi));
%         Gammawake=thresholdIntervals(smooth_ghi,exp(gamma_thresh),'Direction','Above');
%         Gammawake=mergeCloseIntervals(Gammawake,3*1e4);
%         GammaSleep=Epoch-Gammawake;GammaSleep=dropShortIntervals(GammaSleep,5*1e4);
%         Gammawake=dropShortIntervals(Gammawake,5*1e4);
%         [aft_cellG,bef_cellG]=transEpoch(GammaSleep,Gammawake);
%     
    
    [M,T{mm,1}]= PlotRipRaw(smooth_emg,Start(bef_cellG{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    EMGWSG(:,mm)=M(:,2);
    [M,T{mm,2}]=PlotRipRaw(smooth_emg,Start(bef_cellG{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    EMGSWG(:,mm)=M(:,2);
    [M,T{mm,3}]=PlotRipRaw(smooth_ghi,Start(bef_cellG{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    GammaWSG(:,mm)=M(:,2);
    [M,T{mm,4}]= PlotRipRaw(smooth_ghi,Start(bef_cellG{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    GammaSWG(:,mm)=M(:,2);
    tpsG=M(:,1);
    [M,T{mm,5}]=PlotRipRaw(HPowtsd,Start(bef_cellG{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    TvalsM=max(T{mm,5}');Upper=prctile(TvalsM,90);
    ToKeep=find(TvalsM<Upper);
    HPCWSG(:,mm)=mean(T{mm,5}(ToKeep,:));
    [M,T{mm,6}]= PlotRipRaw(HPowtsd,Start(bef_cellG{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    TvalsM=max(T{mm,6}');Upper=prctile(TvalsM,90);
    ToKeep=find(TvalsM<Upper);
    HPCSWG(:,mm)=mean(T{mm,6}(ToKeep,:));
    tpsH=M(:,1);
    
    [M,T{mm,7}]= PlotRipRaw(smooth_emg,Start(bef_cellE{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    EMGWSE(:,mm)=M(:,2);
    [M,T{mm,8}]=PlotRipRaw(smooth_emg,Start(bef_cellE{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    EMGSWE(:,mm)=M(:,2);
    [M,T{mm,9}]=PlotRipRaw(smooth_ghi,Start(bef_cellE{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    GammaWSE(:,mm)=M(:,2);
    [M,T{mm,10}]= PlotRipRaw(smooth_ghi,Start(bef_cellE{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    GammaSWE(:,mm)=M(:,2);
    tpsG=M(:,1);
    [M,T{mm,11}]=PlotRipRaw(HPowtsd,Start(bef_cellE{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    TvalsM=max(T{mm,11}');Upper=prctile(TvalsM,90);
    ToKeep=find(TvalsM<Upper);
    HPCWSE(:,mm)=mean(T{mm,11}(ToKeep,:));
    [M,T{mm,12}]= PlotRipRaw(HPowtsd,Start(bef_cellE{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    TvalsM=max(T{mm,12}');Upper=prctile(TvalsM,90);
    ToKeep=find(TvalsM<Upper);
    HPCSWE(:,mm)=mean(T{mm,12}(ToKeep,:));
    tpsH=M(:,1);
    save('ScoringShortSmoothingThresholds.mat','gamma_thresh','emg_thresh','bef_cellG','bef_cellE','smooth_emg','smooth_ghi','HPowtsd')
    
end

figure
g=shadedErrorBar(tpsG,runmean(mean(zscore(EMGWSG)')',500),[runmean(stdError(zscore(EMGWSG)'),500);runmean(stdError(zscore(EMGWSG)'),500)]')
hold on
g=shadedErrorBar(tpsG,runmean(mean(zscore(GammaWSG)')',500),[runmean(stdError(zscore(GammaWSG)'),500);runmean(stdError(zscore(GammaWSG)'),500)]','b')
g=shadedErrorBar(tpsH,runmean(mean(zscore(HPCWSG)')',3),[runmean(stdError(zscore(HPCWSG)'),3);runmean(stdError(zscore(HPCWSG)'),3)]','r')
line([0 0],ylim,'color','k')
title('Gamma trig')

figure
g=shadedErrorBar(tpsG,runmean(mean(zscore(EMGSWG)')',500),[runmean(stdError(zscore(EMGSWG)'),500);runmean(stdError(zscore(EMGSWG)'),500)]')
hold on
g=shadedErrorBar(tpsG,runmean(mean(zscore(GammaSWG)')',500),[runmean(stdError(zscore(GammaSWG)'),500);runmean(stdError(zscore(GammaWSG)'),500)]','b')
g=shadedErrorBar(tpsH,runmean(mean(zscore(HPCSWG)')',3),[runmean(stdError(zscore(HPCSWG)'),3);runmean(stdError(zscore(HPCSWG)'),3)]','r')
line([0 0],ylim,'color','k')
title('Gamma trig')

figure
g=shadedErrorBar(tpsG,runmean(mean(zscore(EMGWSE)')',500),[runmean(stdError(zscore(EMGWSE)'),500);runmean(stdError(zscore(EMGWSE)'),500)]')
hold on
g=shadedErrorBar(tpsG,runmean(mean(zscore(GammaWSE)')',500),[runmean(stdError(zscore(GammaWSE)'),500);runmean(stdError(zscore(GammaWSE)'),500)]','b')
g=shadedErrorBar(tpsH,runmean(mean(zscore(HPCWSE)')',3),[runmean(stdError(zscore(HPCWSE)'),3);runmean(stdError(zscore(HPCWSE)'),3)]','r')
line([0 0],ylim,'color','k')
title('EMG trig')

figure
g=shadedErrorBar(tpsG,runmean(mean(zscore(EMGSWE)')',500),[runmean(stdError(zscore(EMGSWE)'),500);runmean(stdError(zscore(EMGSWE)'),500)]')
hold on
g=shadedErrorBar(tpsG,runmean(mean(zscore(GammaSWE)')',500),[runmean(stdError(zscore(GammaSWE)'),500);runmean(stdError(zscore(GammaWSE)'),500)]','b')
g=shadedErrorBar(tpsH,runmean(mean(zscore(HPCSWE)')',3),[runmean(stdError(zscore(HPCSWE)'),3);runmean(stdError(zscore(HPCSWE)'),3)]','r')
line([0 0],ylim,'color','k')
title('EMG trig')

