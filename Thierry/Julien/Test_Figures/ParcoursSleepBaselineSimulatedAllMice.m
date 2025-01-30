function [MatTotal,MatCellArray,timeREM,vectTotalB,vect,tps2]=ParcoursTransitionSleepBaselineSimulatedAllMice

Dir=PathForExperimentsEmbReact('BaselineSleep');

a=1;

MatTotal=[];
timeREM=[];
vectTotalB=[];
Dir=PathForExperimentsEmbReact('BaselineSleep');

TransREMSWS = [];
i = 0

for k = 1:length(Dir.path)
    cd(Dir.path{k}{1})
        load('StateEpochSB.mat')
        [Ordered_REM] = Ordered_REM_BaselineSimulation()
    
        load('H_Low_Spectrum');
        %load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
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


id1=find(tps>-20&tps<-5);
id2=find(tps>5&tps<20);
PlotErrorBar2(mean(MatTotal(:,id1),2),mean(MatTotal(:,id2),2));
histo_sortie_REM(vectTotalB,1000)
end
