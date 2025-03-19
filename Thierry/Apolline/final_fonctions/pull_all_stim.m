clear all 
clc

DataLocation{1}='/media/mobschapeau/DataMOBS82/Test Figures/21032018/M675_ProtoStimSleep_1min_180321_102404';
DataLocation{2}='/media/mobschapeau/DataMOBS82/M733/11052018/M733_Stim_ProtoSleep_1min_180511_103535';
DataLocation{3}='/media/mobschapeau/DataMOBS82/M711/10042018/M711_Stim_ProtoSleep_1min_180410_103027';
DataLocation{4}='/media/mobschapeau/DataMOBS821/M711/04042018/M711_Stim_ProtoSleep_1min_180404_102816';
DataLocation{5}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/23032018/M675_Stim_ProtoSleep_1min_180323_103305';
DataLocation{6}='/media/mobschapeau/DataMOBS82/M733/23052018/M733_Stim_ProtoSleep_1min_180523_102236';
DataLocation{7}='/media/mobschapeau/DataMOBS82/M733/04062018/M733_Stim_ProtoSleep_1min_180604_100548';

DataLocation_Base{1}='/media/mobschapeau/DataMOBS82/Test Figures/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439';
DataLocation_Base{2}='/media/mobschapeau/DataMOBS82/M733/24052018/M733_Baseline_ProtoSleep_1min_180524_103728';
% DataLocation_Base{3}='/media/mobschapeau/DataMOBS82/M711/17042018/M711_M675_Baseline_ProtoSleep_1min_180417_101952';
DataLocation_Base{3}='/media/mobschapeau/DataMOBS821/M711/28032018/M711_Baseline_ProtoSleep_1min_28032018';
DataLocation_Base{4}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/28032018/M675_M711_Baseline_ProtoSleep_1min_180328_111302';
DataLocation_Base{5}='/media/mobschapeau/DataMOBS82/M733/28052018/M733_Baseline_ProtoSleep_1min_180528_110038';

a=1;
MatTotal=[];
timeREM=[];
A = [];
vectTotal=[];

for i=1:length(DataLocation)
    cd(DataLocation{i})
    
    load('LFPData/DigInfo2.mat')
    load('SleepScoring_OBGamma.mat')
    
    WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
    SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
    REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states
    NoiseStart = Start(TotalNoiseEpoch)./(1e4); %matrix with the start times of all the Noise states

    %Calculation of the start time of all the stimulations and their frequency
    TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
    TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
    Nb_Stim = length(Start(TTLEpoch_merged));
    Freq_Stim = zeros(Nb_Stim,1);
    Time_Stim = zeros(Nb_Stim,1); %matrix with all the start times of the stimulations

    for k = 1:Nb_Stim
    LittleEpoch = subset(TTLEpoch_merged,k);
    Freq_Stim(k) =round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)))./(1e4);
    end

    
    New_Latence = Latence_all_mice_analyse(WkStart, SWSStart, REMStart, NoiseStart, Time_Stim);
    
    if isempty(New_Latence) == 0
        A = [A; New_Latence];
    end
    
    load('Ordered_REM')
    load('dHPC_deep_Low_Spectrum');
    load SleepScoring_OBGamma
    load('LFPData/DigInfo2.mat')

    Wake_merged = mergeCloseIntervals(Wake, 5e4);
    WakeStart = Start(Wake_merged);
    WakeEnd = End(Wake_merged);
    test = WakeEnd - WakeStart;
    Start1 = [];
    End1 = [];
    for r = 1:length(test)
        if test(r) <= 5e4
            Start1 = [Start1; WakeStart(r)];
            End1 = [End1; WakeEnd(r)];
        end
    end
    Wake_merged = Wake_merged - intervalSet(Start1,End1);
        
    SWSEpoch_merged = mergeCloseIntervals(SWSEpoch, 5e4);
    SWSStart = Start(SWSEpoch_merged);
    SWSEnd = End(SWSEpoch_merged);
    test = SWSEnd - SWSStart;
    Start1 = [];
    End1 = [];
    for r = 1:length(test)
        if test(r) <= 5e4
            Start1 = [Start1; SWSStart(r)];
            End1 = [End1; SWSEnd(r)];
        end
    end
    SWSEpoch_merged = SWSEpoch_merged - intervalSet(Start1,End1);
    
    REMEpoch_merged = mergeCloseIntervals(REMEpoch, 5e4);
    REMStart = Start(REMEpoch_merged);
    REMEnd = End(REMEpoch_merged);
    test = REMEnd - REMStart;
    Start1 = [];
    End1 = [];
    for r = 1:length(test)
        if test(r) <= 5e4
            Start1 = [Start1; REMStart(r)];
            End1 = [End1; REMEnd(r)];
        end
    end
    REMEpoch_merged = REMEpoch_merged - intervalSet(Start1,End1);
    
    SleepStages=PlotSleepStage(Wake_merged,SWSEpoch_merged,REMEpoch_merged);
    
    WkStart_merged = Start(Wake_merged)./(1e4);
    SWSStart_merged = Start(SWSEpoch_merged)./(1e4);
    REMStart_merged = Start(REMEpoch_merged)./(1e4);
    NoiseStart = Start(TotalNoiseEpoch)./(1e4);
    
    TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
    TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
    Nb_Stim = length(Start(TTLEpoch_merged));
    Freq_Stim = zeros(Nb_Stim,1);
    Time_Stim = zeros(Nb_Stim,1); %matrix with all the start times of the stimulations

    for k = 1:Nb_Stim
    LittleEpoch = subset(TTLEpoch_merged,k);
    Freq_Stim(k) =round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)))./(1e4);
    end

    [TransREMSWS] = Latence_all_mice_analyse(WkStart_merged, SWSStart_merged, REMStart_merged, NoiseStart, Time_Stim);
    TransREMSWSbis = [];
    for h = 1:length(TransREMSWS(:,1))
        if TransREMSWS(h,2) <= 30
            TransREMSWSbis = [TransREMSWSbis; TransREMSWS(h,:)];
        end
    end

    for i=1:size(TransREMSWSbis,1)
        Epoch=intervalSet(TransREMSWSbis(i,1)*1E4-30E4,TransREMSWSbis(i,1)*1E4+30E4);
        vect{a}=Data(Restrict(SleepStages,Epoch))';
        vectTotal=[vectTotal;vect{a}];
        timeREM = [timeREM;TransREMSWSbis(i,2)];
        rg=Range(Restrict(SleepStages,Epoch),'s');
        tps2=rg-rg(1)-30;
    end



%     [Mat,tps]=TransitionSleepOpto(Spectro,TransREMSWS(:,1)*1E4,[6.5 9],40);
%     timeREM=[timeREM;TransREMSWS(:,2)];
%     MatTotal=[MatTotal;Mat]; 
%     MatCellArray{a}=Mat;
%     a=a+1;

end

a=1;
MatTotal=[];
timeREM=[];
B = [];
vectTotal=[];

for i=1:length(DataLocation_Base)
    cd(DataLocation_Base{i})
    
    load('LFPData/DigInfo2.mat')
    load('SleepScoring_OBGamma.mat')
    
    WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
    SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
    REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states
    NoiseStart = Start(TotalNoiseEpoch)./(1e4); %matrix with the start times of all the Noise states

    %Calculation of the start time of all the stimulations and their frequency
    TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
    TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
    Nb_Stim = length(Start(TTLEpoch_merged));
    Freq_Stim = zeros(Nb_Stim,1);
    Time_Stim = zeros(Nb_Stim,1); %matrix with all the start times of the stimulations

    for k = 1:Nb_Stim
    LittleEpoch = subset(TTLEpoch_merged,k);
    Freq_Stim(k) =round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)))./(1e4);
    end

    
    New_Latence = Latence_all_mice_analyse(WkStart, SWSStart, REMStart, NoiseStart, Time_Stim);
    
    if isempty(New_Latence) == 0
        B = [B; New_Latence];
    end
    
    load('Ordered_REM')
    load('dHPC_deep_Low_Spectrum');
    load SleepScoring_OBGamma
    load('LFPData/DigInfo2.mat')

    Wake_merged = mergeCloseIntervals(Wake, 5e4);
    WakeStart = Start(Wake_merged);
    WakeEnd = End(Wake_merged);
    test = WakeEnd - WakeStart;
    Start1 = [];
    End1 = [];
    for r = 1:length(test)
        if test(r) <= 5e4
            Start1 = [Start1; WakeStart(r)];
            End1 = [End1; WakeEnd(r)];
        end
    end
    Wake_merged = Wake_merged - intervalSet(Start1,End1);
        
    SWSEpoch_merged = mergeCloseIntervals(SWSEpoch, 5e4);
    SWSStart = Start(SWSEpoch_merged);
    SWSEnd = End(SWSEpoch_merged);
    test = SWSEnd - SWSStart;
    Start1 = [];
    End1 = [];
    for r = 1:length(test)
        if test(r) <= 5e4
            Start1 = [Start1; SWSStart(r)];
            End1 = [End1; SWSEnd(r)];
        end
    end
    SWSEpoch_merged = SWSEpoch_merged - intervalSet(Start1,End1);
    
    REMEpoch_merged = mergeCloseIntervals(REMEpoch, 5e4);
    REMStart = Start(REMEpoch_merged);
    REMEnd = End(REMEpoch_merged);
    test = REMEnd - REMStart;
    Start1 = [];
    End1 = [];
    for r = 1:length(test)
        if test(r) <= 5e4
            Start1 = [Start1; REMStart(r)];
            End1 = [End1; REMEnd(r)];
        end
    end
    REMEpoch_merged = REMEpoch_merged - intervalSet(Start1,End1);
    
    SleepStages=PlotSleepStage(Wake_merged,SWSEpoch_merged,REMEpoch_merged);
    
    WkStart_merged = Start(Wake_merged)./(1e4);
    SWSStart_merged = Start(SWSEpoch_merged)./(1e4);
    REMStart_merged = Start(REMEpoch_merged)./(1e4);
    NoiseStart = Start(TotalNoiseEpoch)./(1e4);
    
    TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
    TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
    Nb_Stim = length(Start(TTLEpoch_merged));
    Freq_Stim = zeros(Nb_Stim,1);
    Time_Stim = zeros(Nb_Stim,1); %matrix with all the start times of the stimulations

    for k = 1:Nb_Stim
    LittleEpoch = subset(TTLEpoch_merged,k);
    Freq_Stim(k) =round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)))./(1e4);
    end

    [TransREMSWS] = Latence_all_mice_analyse(WkStart_merged, SWSStart_merged, REMStart_merged, NoiseStart, Time_Stim);
    TransREMSWSBase = [];
    for h = 1:length(TransREMSWS(:,1))
        if TransREMSWS(h,2) <= 30
            TransREMSWSBase = [TransREMSWSBase; TransREMSWS(h,:)];
        end
    end

    for i=1:size(TransREMSWSBase,1)
        Epoch=intervalSet(TransREMSWSBase(i,1)*1E4-30E4,TransREMSWSBase(i,1)*1E4+30E4);
        vect{a}=Data(Restrict(SleepStages,Epoch))';
        vectTotal=[vectTotal;vect{a}];
        timeREM = [timeREM;TransREMSWSBase(i,2)];
        rg=Range(Restrict(SleepStages,Epoch),'s');
        tps2=rg-rg(1)-30;
    end



%     [Mat,tps]=TransitionSleepOpto(Spectro,TransREMSWS(:,1)*1E4,[6.5 9],40);
%     timeREM=[timeREM;TransREMSWS(:,2)];
%     MatTotal=[MatTotal;Mat]; 
%     MatCellArray{a}=Mat;
%     a=a+1;

end




%         figure, imagesc(tps2,1:size(vectTotal,1),vectTotal(:,:))
        
% figure, plot(tps,mean(MatCellArray{1})), hold on, plot(tps,mean(MatCellArray{2}),'r')

[BE,idx]=sort(timeREM);

% figure, 
% subplot(4,1,1),hold on
% for i=1:a-1
% plot(tps,mean(MatCellArray{i}))
% end
% subplot(4,1,2:4),imagesc(tps,1:size(MatTotal,1),zscore(MatTotal(idx,:)')')
% 
% figure, imagesc(tps2,1:size(vectTotal,1),vectTotal(idx,:))


% id1=find(tps>-30&tps<-10);
% id2=find(tps>5&tps<20);
% PlotErrorBar2(mean(MatTotal(:,id1),2),mean(MatTotal(:,id2),2));3
% histo_sortie_REM(vectTotal,1000)

cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/projet_VLPO')
load('Latence_all_mice1000.mat')


Nb_Total_Stim = length(A(:,1));
Nb_Total_all_mice = length(TransREMSWS(:,1));
Nb_Total_Baseline = length(B(:,1));


norm_Stim_REM =A(:,2)./(A(:,2)+A(:,3));
figure, hist(norm_Stim_REM)
title('Distribution of the stimulations along the REM epoch')
ylabel('nb de stim')
xlabel('normalized location of the stimulation inside the REM epoch')
str = sprintf('%d stim',Nb_Total_Stim);
legend(str)


% figure, nhist({A(:,3),TransREMSWS(:,3)},'number')
figure, nhist({TransREMSWS(:,3), A(:,3), B(:,3)}, 'proportion')
title('Histograms of the latence distribution for baseline and stimulated mice')
% ylabel('number of stimulations')
ylabel('proportion of stimulations')
xlabel('Latence of the transition REM-SWS (s)')
mb1 = mean(TransREMSWS(:,3));
strb1 = sprintf('All mice - %dstim - mean = %f',Nb_Total_all_mice,mb1);
ms1 = mean(A(:,3));
strs1 = sprintf('Stimulated mice - %dstim - mean = %f',Nb_Total_Stim,ms1);
mb2 = mean(B(:,3));
strb2 = sprintf('Baseline - %dstim - mean = %f',Nb_Total_Baseline,mb2);
legend(strb1,strs1,strb2)


% figure, nhist({TransREMSWS(:,2)+TransREMSWS(:,3),A(:,2)+A(:,3)},'number')
figure, nhist({TransREMSWS(:,2)+TransREMSWS(:,3), A(:,2)+A(:,3), B(:,2)+B(:,3)}, 'proportion')
title('REM duration distribution for Baseline and stimulated mice')
% ylabel('number of stimulations')
ylabel('proportion of stimulations')
xlabel('Total duration of the REM (s)')
mb = mean(TransREMSWS(:,2)+TransREMSWS(:,3));
strb = sprintf('All mice - %dstim - mean = %f',Nb_Total_all_mice,mb);
ms = mean(A(:,2)+A(:,3));
strs = sprintf('Stimulated mice - %dstim - mean = %f',Nb_Total_Stim,ms);
mb2 = mean(B(:,2)+B(:,3));
strb2 = sprintf('Baseline - %dstim - mean = %f',Nb_Total_Baseline,mb2);
legend(strb,strs,strb2)

