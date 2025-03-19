function [MatTotal,MatCellArray,timeREM,vectTotalB,vect,tps2]=ParcoursTransitionSleepBaselineSimulated

DataLocation{1}='/media/mobsmorty/DataMOBS81/Pre-processing/M675/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439';
DataLocation{2}='/media/mobsmorty/DataMOBS81/Pre-processing/M675/28032018/M675_M711_Baseline_ProtoSleep_1min_180328_111302';
DataLocation{3}='/media/mobsmorty/DataMOBS81/Pre-processing/M711/28032018/M711_Baseline_ProtoSleep_1min_28032018';
DataLocation{4}='/media/mobsmorty/DataMOBS82/M733/24052018/M733_Baseline_ProtoSleep_1min_180524_103728';

%DataLocation{5}='/media/mobsmorty/DataMOBS82/M711/17042018/M711_M675_Baseline_ProtoSleep_1min_180417_101952';
DataLocation{5}='/media/mobsmorty/DataMOBS82/M733/28052018/M733_Baseline_ProtoSleep_1min_180528_110038';
%DataLocation{4}='/media/mobsmorty/DataMOBS82/M733/24052018/M733_Baseline_ProtoSleep_1min_180524_103728';
%DataLocation{4}='/media/mobsmorty/DataMOBS82/M647/24042018/M647_Stim_ProtoSleep_1min_180424_102646';
%DataLocation{5}='/media/mobsmorty/DataMOBS821/M675/17042018/M675_baseline_ProtoSleep?';
a=1;

MatTotal=[];
timeREM=[];

    vectTotalB=[];
for i=1:length(DataLocation)
    cd(DataLocation{i})
    
  [Ordered_REM] = Ordered_REM_BaselineSimulation();
    load('dHPC_deep_Low_Spectrum');
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);



        for i=1:size(Ordered_REM,1)
        Epoch=intervalSet(Ordered_REM(i,2)*1E4-60E4,Ordered_REM(i,2)*1E4+60E4);
        vect{a}=Data(Restrict(SleepStages,Epoch))';
        vectTotalB=[vectTotalB;vect{a}];
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

figure, imagesc(tps2,1:size(vectTotalB,1),vectTotalB(idx,:))


id1=find(tps>-20&tps<-1);
id2=find(tps>1&tps<20);
PlotErrorBar2(mean(MatTotal(:,id1),2),mean(MatTotal(:,id2),2));
histo_sortie_REM(vectTotalB,1000)
end
