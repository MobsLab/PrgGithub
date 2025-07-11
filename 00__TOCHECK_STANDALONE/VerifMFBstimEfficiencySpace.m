%VerifMFBstimEfficiencySpace

%filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
%
%
%sleep
%
%cd([filename,'Mouse026/20120109'])
%cd([filename,'Mouse029/20120207'])
%cd([filename,'Mouse035/20120515'])
%cd([filename,'Mouse042/20120801'])
%
%wakePlaceCell
%
%cd([filename,'Mouse026/20111128'])
%cd([filename,'Mouse029/20120209'])
%cd([filename,'Mouse017/20110622'])
%
%
%wake
%
%cd([filename,'Mouse013/20110420'])
%cd([filename,'Mouse015/20110615'])
%cd([filename,'Mouse017/20110614'])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
load('MyColormaps','mycmap')
ma=2.5;
paramMin=9;
paramMax=57;

Vth=20;


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



a=1;
sav=0;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Wake
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
cd([filename,'Mouse013/20110420'])
load behavResources
load stimMFB
load SpikeData
%namePos'
Epoch=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim Manual')

if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse013', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end


%--------------------------------------------------------------------------

cd([filename,'Mouse015/20110615'])
load behavResources
load stimMFB
load SpikeData
%namePos'
Epoch=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim Manual')
if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse015', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end

%--------------------------------------------------------------------------

cd([filename,'Mouse017/20110622'])
load behavResources
load stimMFB
load SpikeData

Epoch=intervalSet(tpsdeb{11}*1E4,tpsfin{12}*1E4);

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim Manual')
if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse017', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Wake Place Cell
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

cd([filename,'Mouse026/20111128'])
load behavResources
load stimMFB
load SpikeData

Epoch=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);

% load xyMax
% [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim spikes')

NeuronNum=31;
SessionPlaceCells=[3];
PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Spikes')

if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse026', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end


cd([filename,'Mouse026/20120109'])
load behavResources
load stimMFB
load SpikeData

Epoch=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax,'Stim')
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim Manual')

NeuronNum=6;
SessionPlaceCells=[7 9 11];
PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,Epoch,paramMin,paramMax,'spikes')
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Spikes')

EpochCtrl1=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
EpochCtrl2=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);
EpochCtrl=or(EpochCtrl1,EpochCtrl2);
EpochCtrl3=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);
EpochCtrl=or(EpochCtrl,EpochCtrl3);

PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,EpochCtrl,paramMin,paramMax,'spikes Ctrl')
nameFile=pwd;
nameFile=nameFile(end-15:end);
title(nameFile)
ylabel('Spikes Ctrl')

if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse026bis', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end

%--------------------------------------------------------------------------

cd([filename,'Mouse029/20120209'])
load behavResources
load stimMFB
load SpikeData
Epoch=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax,'Stim spikes')
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim spikes')

NeuronNum=12;
SessionPlaceCells=[3 4 5];
PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,Epoch,paramMin,paramMax,'spikes')
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Spikes')

if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse029', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Sleep
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


cd([filename,'Mouse035/20120515'])
load behavResources
load stimMFB
load SpikeData

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);


Epoch=intervalSet(tpsdeb{13}*1E4,tpsfin{13}*1E4);
PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim spikes')

NeuronNum=23;
SessionPlaceCells=[3 4];
PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Spikes')

EpochCtrl=intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4);
PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,EpochCtrl,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-15:end);
title(nameFile)
ylabel('Spikes Ctrl')


cd([filename,'Mouse035/20120515'])
load behavResources
load stimMFB
load SpikeData

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

Epoch=intervalSet(tpsdeb{16}*1E4,tpsfin{16}*1E4);
PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-15:end);
title(nameFile)
ylabel('Stim Manual')

if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse035', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end

%--------------------------------------------------------------------------




cd([filename,'Mouse042/20120801'])
load behavResources
load stimMFB
load SpikeData
Epoch=intervalSet(tpsdeb{14}*1E4,tpsfin{14}*1E4);

load xyMax
[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
stim=Restrict(stim,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
S=Restrict(S,Mvt);

PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Stim Manual')

NeuronNum=12;
SessionPlaceCells=[4 12];
PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,Epoch,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Spikes')

EpochCtrl1=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
EpochCtrl2=intervalSet(tpsdeb{12}*1E4,tpsfin{12}*1E4);
EpochCtrl=or(EpochCtrl1,EpochCtrl2);
PlotVerifMFBstimEfficiencySpace(S{NeuronNum},X,Y,EpochCtrl,paramMin,paramMax)
nameFile=pwd;
nameFile=nameFile(end-16:end);
title(nameFile)
ylabel('Spikes Ctrl')

if sav
    for i=1:40
        try
            eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlaceMouse042', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
            a=a+1;
        end
    end
close all
end

% 
% if sav
%     
%     for i=1:98
%         try
%             eval(['saveFigure(',num2str(i),',''FigureVerifMFBStimEfficiencyPlace', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
%         end
%     end
% 
% close all
% end



