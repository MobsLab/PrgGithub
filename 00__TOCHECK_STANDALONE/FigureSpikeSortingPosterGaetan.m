%FigureSpikeSortingPosterGaetan


try
cd /Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/ICSS/ICSS-Mouse-29-03022012
catch
cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse029/20120203/ICSS-Mouse-29-03022012
end

load behavResources
load SpikeData S cellnames
Epoch1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);


if 0
    tp=70;
    tp=tp*10;
    bin=10;

    figure('color',[1 1 1]),RasterPETH(poolNeurons(S,[[2:28],[30:length(S)]]), (Restrict(stim,Epoch1)), -tp, +tp,'BinSize',bin);title('All Neurons but #29')
    figure('color',[1 1 1]),RasterPETH(S{29}, (Restrict(stim,Epoch1)), -tp, +tp,'BinSize',bin);title('Neuron #29')
    figure('color',[1 1 1]),RasterPETH(poolNeurons(S,[[2:28],[29:length(S)]]), (Restrict(stim,Epoch1)), -tp, +tp,'BinSize',bin);title('All Neurons')
    figure('color',[1 1 1]),RasterPETH(poolNeurons(S,[2:28]), (Restrict(stim,Epoch1)), -tp, +tp,'BinSize',bin);title('All Neurons tetrode 1')
    % 
    % saveFigure(1,'FigureSpikeSortingNew1c','/Users/karimbenchenane/Documents/MATLAB')
    % saveFigure(2,'FigureSpikeSortingNew2c','/Users/karimbenchenane/Documents/MATLAB')
    % saveFigure(3,'FigureSpikeSortingNew3c','/Users/karimbenchenane/Documents/MATLAB')
    % saveFigure(4,'FigureSpikeSortingNew4c','/Users/karimbenchenane/Documents/MATLAB')
end


PlaceCellList=[3 5 9 14 18 20 34]; %40];
Epoch1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
Epoch2=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);

try
    load StabPHBefAftStim 
    r12;
catch


[r12,p12,rc12,pc12]=StabilityPFEpoch(S(PlaceCellList),X,Y,Epoch1,Epoch2,cellnames(PlaceCellList),0);
close all

Epoch3=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);
Epoch4=intervalSet(tpsdeb{10}*1E4,tpsfin{10}*1E4);
[r34,p34,rc34,pc34]=StabilityPFEpoch(S(PlaceCellList),X,Y,Epoch3,Epoch4,cellnames(PlaceCellList),0);
close all

EpochB=intervalSet(tpsdeb{1}*1E4,tpsfin{2}*1E4);
EpochA=intervalSet(tpsdeb{9}*1E4,tpsfin{10}*1E4);
[rBA,pBA,rcBA,pcBA]=StabilityPFEpoch(S(PlaceCellList),X,Y,EpochA,EpochB,cellnames(PlaceCellList),0);
close all

[r13,p13,rc13,pc13]=StabilityPFEpoch(S(PlaceCellList),X,Y,Epoch3,Epoch4,cellnames(PlaceCellList),0);
close all
[r23,p23,rc23,pc23]=StabilityPFEpoch(S(PlaceCellList),X,Y,Epoch3,Epoch4,cellnames(PlaceCellList),0);
close all
[r14,p14,rc14,pc14]=StabilityPFEpoch(S(PlaceCellList),X,Y,Epoch3,Epoch4,cellnames(PlaceCellList),0);
close all
[r24,p24,rc24,pc24]=StabilityPFEpoch(S(PlaceCellList),X,Y,Epoch3,Epoch4,cellnames(PlaceCellList),0);
close all

save StabPHBefAftStim r12 r13 r14 r23 r24 r34 p12 p13 p14 p23 p24 p34 rc12 rc13 rc14 rc23 rc24 rc34 pc12 pc13 pc14 pc23 pc24 pc34 rBA pBA rcBA pcBA


end


R(1,2)=mean(r12);
R(1,3)=mean(r13);
R(1,4)=mean(r14);
R(2,3)=mean(r23);
R(2,4)=mean(r24);
R(3,4)=mean(r34);

R=R';

R(1,2)=mean(p12);
R(1,3)=mean(p13);
R(1,4)=mean(p14);
R(2,3)=mean(p23);
R(2,4)=mean(p24);
R(3,4)=mean(p34);

PlotErrorBar([r12; r13; r14; r23; r24; r34]')
set(gca,'xtick',[1:6])
set(gca,'xticklabel',{'12','13','14','23','24','34'})
ylabel('Correlation coefficient')


PlotErrorBar([r12; r13; r14; r23; r24; r34; rBA]')
set(gca,'xtick',[1:7])
set(gca,'xticklabel',{'12','13','14','23','24','34','12 vs 34'})
ylabel('Correlation coefficient')


pmax=max([p12 p13 p14 p23 p24 p34]);


[rmax,pmax,rcmax,pcmax]=StabilityPFEpoch(S(18),X,Y,Epoch1,Epoch2,cellnames(18),0);
[rmin,pmin,rcmin,pcmin]=StabilityPFEpoch(S(40),X,Y,Epoch1,Epoch2,cellnames(40),0);




