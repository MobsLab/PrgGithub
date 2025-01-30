function [MatTotal,MatCellArray,timeREM,vectTotal,vect,tps2]=ParcoursTransitionSleepOpto_Ap

DataLocation{1}='/media/mobschapeau/DataMOBS82/Test Figures/21032018/M675_ProtoStimSleep_1min_180321_102404';
DataLocation{2}='/media/mobschapeau/DataMOBS82/M733/11052018/M733_Stim_ProtoSleep_1min_180511_103535';
DataLocation{3}='/media/mobschapeau/DataMOBS82/M711/10042018/M711_Stim_ProtoSleep_1min_180410_103027';
DataLocation{4}='/media/mobschapeau/DataMOBS821/M711/04042018/M711_Stim_ProtoSleep_1min_180404_102816';
DataLocation{5}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/23032018/M675_Stim_ProtoSleep_1min_180323_103305';
DataLocation{6}='/media/mobschapeau/DataMOBS82/M733/23052018/M733_Stim_ProtoSleep_1min_180523_102236';
DataLocation{7}='/media/mobschapeau/DataMOBS82/M733/04062018/M733_Stim_ProtoSleep_1min_180604_100548';
a=1;
A = [];

MatTotal=[];
timeREM=[];
Latence = [];
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
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);



    for i=1:size(Ordered_REM,1)
    Epoch=intervalSet(Ordered_REM(i,2)*1E4-30E4,Ordered_REM(i,2)*1E4+30E4);
    vect{a}=Data(Restrict(SleepStages,Epoch))';
    vectTotal=[vectTotal;vect{a}];
    rg=Range(Restrict(SleepStages,Epoch),'s');
    tps2=rg-rg(1)-30;
    end



    [Mat,tps]=TransitionSleepOpto(Spectro,Ordered_REM(:,2)*1E4,[6.5 9],40);
    timeREM=[timeREM;Ordered_REM(:,3)];
    MatTotal=[MatTotal;Mat]; 
    MatCellArray{a}=Mat;
    a=a+1;

end
        
        
figure, plot(tps,mean(MatCellArray{1})), hold on, plot(tps,mean(MatCellArray{2}),'r')

[BE,idx]=sort(timeREM);

figure, 
subplot(4,1,1),hold on
for i=1:a-1
plot(tps,mean(MatCellArray{i}))
end
subplot(4,1,2:4),imagesc(tps,1:size(MatTotal,1),zscore(MatTotal(idx,:)')')

figure, imagesc(tps2,1:size(vectTotal,1),vectTotal(idx,:))


id1=find(tps>-30&tps<-10);
id2=find(tps>5&tps<20);
PlotErrorBar2(mean(MatTotal(:,id1),2),mean(MatTotal(:,id2),2));
histo_sortie_REM(vectTotal,1000)

figure, hist(A(:,3))

norm_Stim_REM =A(:,2)./(A(:,2)+A(:,3));
figure, hist(norm_Stim_REM)
ylabel('nb de stim')
title('Distribution of the stimulations along the REM Epoch')
xlabel('normalized location of the stimulations in the REM Epoch')
legend([length(A(:,2)) ' stim'])

end
