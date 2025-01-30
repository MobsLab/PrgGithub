
%FigureBilanEffectStimOnFiringRate

Test1=[];
Test2=[];



%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------

try
    cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012
    load behavResources X
    X;
catch
    cd('L:\DataSauvegarde\Mouse029\20120203\ICSS-Mouse-29-03022012')
end

load SpikeData
load behavResources
load Waveforms
load StimMFB
load Celltypes

PlaceCellTrig=35; 
listneurones=[2:24];
nchannelSpk=3;
[testa,test2a,test3a,test4a,rga]=EffectStimOnFiringRate(S,W,burst,SleepEpoch,PlaceCellTrig,listneurones,nchannelSpk,Celltypes);

close all


Test1=[Test1,testa/length(listneurones)];
Test2=[Test2,test3a/length(listneurones)];

%------------------------------------------------------------------------

%cd /media/HardBackUp/DataSauvegarde/Mouse029/20120207/ICSS-Mouse-29-0702201202
%cd /media/HardBackUp/DataSauvegarde/Mouse029/20120207


try
    cd /media/HardBackUp/DataSauvegarde/Mouse029/20120207
    load behavResources X
    X;
catch
    cd('L:\DataSauvegarde\Mouse029\20120207')
end



load SpikeData
load behavResources
load Waveforms
load StimMFB

PlaceCellTrig=12; 
listneurones=[29:41];
nchannelSpk=4;
[testb,test2b,test3b,test4b,rgb]=EffectStimOnFiringRate(S,W,burst,SleepEpoch,PlaceCellTrig,listneurones,nchannelSpk);

close all

Test1=[Test1,testb/length(listneurones)];
Test2=[Test2,test3b/length(listneurones)];

%------------------------------------------------------------------------

%cd([filename,'Mouse026/20120109'])

%cd /media/HardBackUp/DataSauvegarde/Mouse026/20120109/ICSS-Mouse-26-09012011


try
    cd /media/HardBackUp/DataSauvegarde/Mouse026/20120109/ICSS-Mouse-26-09012011
    load behavResources X
    X;
catch
    cd('L:\DataSauvegarde\Mouse026\20120109\ICSS-Mouse-26-09012011')
end



load SpikeData
load behavResources
load Waveforms
load StimMFB
load Celltypes
%VisuQuantifEpochTrialNeuron(M,6,[7],1,30)
PlaceCellTrig=6; 
listneurones=[[8:16],[18,19 21,23,24]];
nchannelSpk=1;

[testc,test2c,test3c,test4c,rgc]=EffectStimOnFiringRate(S,W,burst,SleepEpoch,PlaceCellTrig,listneurones,nchannelSpk,Celltypes);

close all


Test1=[Test1,testc/length(listneurones)];
Test2=[Test2,test3c/length(listneurones)];


%------------------------------------------------------------------------


%cd /media/HardBackUp/DataSauvegarde/Mouse035/20120515/ICSS-Mouse-35-15052012


try
    cd /media/HardBackUp/DataSauvegarde/Mouse035/20120515/ICSS-Mouse-35-15052012
    load behavResources X
    X;
catch
    cd('L:\DataSauvegarde\Mouse035\20120515\ICSS-Mouse-35-15052012')
end



load SpikeData
load behavResources
load Waveforms
load StimMFB

PlaceCellTrig=23; 
listneurones=[2:17];
nchannelSpk=3;
[testd,test2d,test3d,test4d,rgd]=EffectStimOnFiringRate(S,W,burst,SleepEpoch,PlaceCellTrig,listneurones,nchannelSpk,' ');

close all


Test1=[Test1,testd/length(listneurones)];
Test2=[Test2,test3d/length(listneurones)];


%------------------------------------------------------------------------


% cd /media/HardBackUp/DataSauvegarde/Mouse042/20120801/ICSS-Mouse-42-01082012

try
    cd /media/HardBackUp/DataSauvegarde/Mouse042/20120801/ICSS-Mouse-42-01082012
    load behavResources X
    X;
catch
    cd('L:\DataSauvegarde\Mouse042\20120801\ICSS-Mouse-42-01082012')
end

load SpikeData
load behavResources
load Waveforms
load StimMFB
 
PlaceCellTrig=12; 
listneurones=[2:5];
nchannelSpk=6;
[teste,test2e,test3e,test4e,rg]=EffectStimOnFiringRate(S,W,burst,SleepEpoch,PlaceCellTrig,listneurones,nchannelSpk,' ');

close all


Test1=[Test1,teste/length(listneurones)];
Test2=[Test2,test3e/length(listneurones)];


%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------

[h,p]=ttest2(Test1',Test2');


psig=0.05;
figure('color',[1 1 1]), hold on,
line([0 0],[0 0.2],'color',[0.7 0.7 0.7])
plot(rg,mean(Test1'),'k','linewidth',1)
plot(rg,mean(Test2'),'r','linewidth',1)
plot(rg(find(p<psig)),0.2*ones(length(find(p<psig)),1),'ko','markerfacecolor','k')




