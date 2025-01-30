%%%%Parcours figures pour les nuits avec toutes les stimulations débutants
%%%%dans le REM

function [MatTotal,MatCellArray,timeREM,vectTotal,vect,tps2]=ParcoursTransitionSleepOptoV2AllStim

DataLocation{1}='/media/mobsmorty/DataMOBS82/Test Figures/21032018/M675_ProtoStimSleep_1min_180321_102404';
DataLocation{2}='/media/mobsmorty/DataMOBS82/M733/11052018/M733_Stim_ProtoSleep_1min_180511_103535';
DataLocation{3}='/media/mobsmorty/DataMOBS82/M733/23052018/M733_Stim_ProtoSleep_1min_180523_102236';
DataLocation{4}='/media/mobsmorty/DataMOBS81/Pre-processing/M711/04042018/M711_Stim_ProtoSleep_1min_180404_102816';
DataLocation{5}='/media/mobsmorty/DataMOBS82/M711/10042018/M711_Stim_ProtoSleep_1min_180410_103027';
DataLocation{6}='/media/mobsmorty/DataMOBS81/Pre-processing/M675/23032018/M675_Stim_ProtoSleep_1min_180323_103305';
%DataLocation{7}='/media/mobsmorty/DataMOBS821/M733/04062018/M733_Stim_ProtoSleep_1min_180604_100548';

a=1;
MatTotal=[];
timeREM=[];

    vectTotal=[];
for i=1:length(DataLocation)
    cd(DataLocation{i})
    [Result] = Analyse_Stim_Ap()
    [TransREMSWS,TransSWSREM,TransSWSWake,TransSWSSWS,TransSWSNoise,TransREMWake,TransREMNoise,TransREMREM,TransWakeSWS,TransWakeREM,TransWakeNoise,TransWakeWake,TransNoiseSWS,TransNoiseREM, TransNoiseWake,TransNoiseNoise] = Ordered_Analyse_Stim_Ap(Result)
    TransREMSWS=sortrows(TransREMSWS)
    
    
    load('dHPC_deep_Low_Spectrum');
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);



        for i=1:size(TransREMSWS,1)
        Epoch=intervalSet(TransREMSWS(i,1)*1E4-60E4,TransREMSWS(i,1)*1E4+60E4);
        vect{a}=Data(Restrict(SleepStages,Epoch))';
        vectTotal=[vectTotal;vect{a}];
        rg=Range(Restrict(SleepStages,Epoch),'s');
        tps2=rg-rg(1)-30;
        end



    [Mat,tps]=TransitionSleepOpto(Spectro,TransREMSWS(:,1)*1E4,[6.5 9],60);
    timeREM=[timeREM;TransREMSWS(:,2)]; %%% colonne 2 = temps de REM avant la Stim ; colonne 3 pour trier avec la latence de sortie de REM 
    MatTotal=[MatTotal;Mat]; 
    MatCellArray{a}=Mat;
    a=a+1;

end
        
        
figure, plot(tps,mean(MatCellArray{1})), hold on, plot(tps,mean(MatCellArray{2}),'r')

[BE,idx]=sort(timeREM);
%%% Figure RACER each line representing the power of the chosen frequency
%%% band around the event (stim t=0s) + the average power for each
%%% recording 
figure, 
subplot(4,1,1),hold on
for i=1:a-1
plot(tps,mean(MatCellArray{i}))
end
subplot(4,1,2:4),imagesc(tps,1:size(MatTotal,1),zscore(MatTotal(idx,:)')')

figure, imagesc(tps2,1:size(vectTotal,1),vectTotal(idx,:))


id1=find(tps>-20&tps<-1);
id2=find(tps>1&tps<20);
PlotErrorBar2(mean(MatTotal(:,id1),2),mean(MatTotal(:,id2),2));3
histo_sortie_REM(vectTotal,1000)
end
