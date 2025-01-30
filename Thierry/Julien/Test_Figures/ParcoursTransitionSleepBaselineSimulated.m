function [MatTotal,MatCellArray,timeREM,vectTotalB,vect,tps2]=ParcoursTransitionSleepBaseline

%DataLocation{1}='/media/mobsmorty/DataMOBS81/Pre-processing/M675/22012018/VLPO-647-675-baseline_180122_092958';
DataLocation{1}='/media/mobsmorty/DataMOBS81/Pre-processing/M675/22022018/Sleep_Baseline_M648_M675_180222_101938';
DataLocation{2}='/media/mobsmorty/DataMOBS81/Pre-processing/M711/28032018/M711_Baseline_ProtoSleep_1min_28032018';
%DataLocation{4}='/media/mobsmorty/DataMOBS82/M727/25042018/M727_Baseline_ProtoSleep_1min_180425_104009ssss';
%DataLocation{5}=

a=1;

MatTotal=[];
timeREM=[];

    vectTotalB=[];
for i=1:length(DataLocation)
    cd(DataLocation{i})
    [Ordered_REM] = Ordered_REM_BaselineSimulation()
    
    load('Ordered_REM')
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


id1=find(tps>-30&tps<-10);
id2=find(tps>5&tps<20);
PlotErrorBar2(mean(MatTotal(:,id1),2),mean(MatTotal(:,id2),2));
histo_sortie_REM(vectTotalB,1000)
end
