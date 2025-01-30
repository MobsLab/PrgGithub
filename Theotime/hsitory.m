%-- 11/10/2024 13:06:50 --%
load('behavResources.mat', 'AlignedXtsd')
edit Essentials.m
load('SpikeData.mat', 'PlaceCells')
edit Essentials.m
load('SleepScoring_Accelero.mat', 'Wake')
%-- 24/10/2024 18:19:00 --%
fopen(Essentials)
fopen(Essentials.m)
fopen(EssaiNewICSS)
LoadPar
Essentials
cleart
clear
Essentials
edit Essentials.m
edit Champalimaud_Poster_2023_BM.m
addpath
%LoadPath
res=pwd;
try
addpath(genpath('/home/greta/Dropbox/Kteam/PrgMatlab'))
addpath('/home/greta/Dropbox/Kteam/PrgMatlab')
end
eval(['cd(''',res,''')'])
clear res
cmap = colormap('jet');
set(groot,'DefaultFigureColorMap',cmap);
close all
clear cmap
set(0,'DefaultFigureWindowStyle','docked')
groot
%-- 24/10/2024 19:39:16 --%
load('nnBehavior.mat')
%-- 25/10/2024 11:45:41 --%
path
edit Essentials.m
load('HeartBeatInfo.mat', 'EKG')
Heart_Rate_tsd = EKG.HBRate;
load('BreathingEx.mat')
load('BreathingEx.mat', 'Breath')
breath
R = Range(breath, 's')
R = Range(breath)
load("behavResources.mat")
figure;
plot (Data(Xtsd), Data(Ytsd))
load('behavResources.mat', 'Xtsd', 'Ytsd');
figure;
plot (Data(Xtsd), Data(Ytsd))
% here we plot the position of th
Essentials
clear all
load('behavResources.mat', 'Xtsd', 'Ytsd');
figure;
plot (Data(Xtsd), Data(Ytsd))
StartPoint = [1 5];
StopPoint = [2 6];
Study_Epoch = intervalSet(StartPoint , StopPoint);
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'Sleep', 'SWSEpoch')
figure
load('behavResources.mat', 'Xtsd', 'Ytsd');
figure;
plot (Data(Xtsd), Data(Ytsd))
load('behavResources.mat')
plot(Data(AlignedXtsd), data(AlignedYtsd))
plot(Data(AlignedXtsd), Data(AlignedYtsd))
plot(Data(LinearDist))
plot(Data(LinearDist), Data(Vtsd))
plot(Data(LinearDist), Data(Vtsd[:-1]))
plot(Data(LinearDist), Data(Vtsd[:0]))
plot(Data(LinearDist), Data(Vtsd[:]))
Vtsd[1:10]
Data(Vtsd)
Data(Vtsd)(1:10}
Data(Vtsd)(1:10]
Data(Vtsd)(1:10)
Data(Vtsd)[1:10]
Data(Vtsd)(1,10)
Data(Vtsd)(1;10)
Data(Vtsd)(1:10)
Data(Vtsd)(2:10,:)
Data(Vtsd)(2:10,)
Data(Vtsd)(2:10)
Vtsd(2:10)
Vtsd(1:1)
Data(Vtsd)
Data(Vtsd)(1,1:10)
Data(Vtsd)(0,1:10)
Data(Vtsd)(0,0:10)
shape(Data(Vtsd))
sharpe(Data(Vtsd))
Data(Vtsd)(1,1:10)
Data(Vtsd)(0,1:10)
Data(Vtsd)(0,0:10)
Data(Vtsd)(1,1:10)
nain = Data(Vtsd)
nain = Data(Vtsd);
nain(10,1)
nain(1:10,1)
clear nain
%-- 25/10/2024 12:10:45 --%
load('behavResources.mat')
figure
plot(Data(CleanXtsd),Data(CleanYtsd))
load('nnBehavior.mat')
position(:,1)=Data(CleanXtsd)
position(:,2)=Data(CleanYtsd)
load('nnBehavior_sauv.mat')
posirion = positions
position = behavior.positions
position = behavior.positions;
positionTime = behavior.position_time;
behavior.positionTime = behavior.position_time;
behavior.position = behavior.positions;
save('nnbehavior.mat','behavior.positionTime','behavior.position','-append')
save('nnbehavior.mat','behavior','-append')
save('nnBehavior.mat','behavior','-append')
clear all
load('nnBehavior.mat')
load('nnBehavior_sauv.mat')
load('nnBehavior.mat')
load('behavResources.mat')
figure;
plot(Data(CleanXtsd),Data(CleanYtsd))
plot(Data(Xtsd),Data(Ytsd))
figure;
plot(Data(Xtsd),Data(Ytsd))
plot(Data(CleanXtsd),Data(CleanYtsd))
%-- 25/10/2024 15:59:35 --%
load('nnBehavior.mat')
load('nnBehavior_tmp.mat')
load('nnBehavior_sauv.mat')
load('nnBehavior.mat')
load('nnBehavior_tmp.mat')
load('behavResources.mat')
%-- 31/10/2024 10:53:19 --%
edit extractTsd.m
%-- 31/10/2024 11:11:58 --%
load('behavResources.mat')
load('nnBehavior.mat')
load('nnBehavior.mat', 'behavior')
load('behavResources.mat')
clear all
%-- 04/11/2024 18:54:43 --%
load('nnBehavior.mat')
plot(data(behavior.positions))
figure;
plot(data(behavior.positions[:,1]), data(behavior.positions[:,2]))
behavior.positions
plot(behavior.positions)
plot(behavior.positions[:,1], behavior.positions[:,2])
behavior.positions[:,1]
behavior.positions[1,1]
behavior.positions(1,1)
plot(behavior.positions(:,1), behavior.positions(:,2))
figure;
plot(behavior.positions(:,2), behavior.positions(:,1))
%-- 05/11/2024 11:21:20 --%
edit startup.m
path
load('behavResources.mat')
figure; plot(Data(CleanAlignedXtsd)n Data(CleanAlignedYtsd))
figure; plot(Data(CleanAlignedXtsd), Data(CleanAlignedYtsd))
OccupancyMap
edit OccupancyMap.m
edit OccMap.m
edit occupancyMap.m
edit OccupancyMapDB.m
OccupancyMapDB(CleanAlignedXtsd, CleanAlignedYtsd)
OccupancyMapDB(Data(CleanAlignedXtsd), Data(CleanAlignedYtsd))
%-- 12/11/2024 10:52:39 --%
load('nnBehavior.mat')
plot(behavior.positions)
figure; plot(behavior.positions(:,1), behavior.positions(:,2))
clear all
load('behavResources.mat')
plot(data(AlignedXtsd))
plot(Data(AlignedXtsd))
plot(Data(AlignedXtsd), Data(AlignedYtsd))
load('nnBehavior.mat')
figure; plot(behavior.positions(:,1), behavior.positions(:,2))
nain = OccupancyMapDB(AlignedXtsd, AlignedYtsd)
nain = OccupancyMapDB(data(AlignedXtsd), Data(AlignedYtsd))
nain = OccupancyMapDB(Data(AlignedXtsd), Data(AlignedYtsd))
nain = OccupancyMapDB(Data(Xtsd), Data(Ytsd))
nain = OccupancyMapDB(Xtsd, Ytsd)
[Oc,OcS,OcR,OcRS]=OccupancyMapDB(Xtsd,Ytsd,'smoothing', 1.5, 'size', 50, 'video', 15, 'plotfig', 0);
[Oc,OcS,OcR,OcRS]=OccupancyMapDB(Xtsd,Ytsd,'smoothing', 1.5, 'size', 50, 'video', 15, 'plotfig', 1);
[Oc,OcS,OcR,OcRS]=OccupancyMapDB(AlignedXtsd,AlignedYtsd,'smoothing', 1.5, 'size', 50, 'video', 15, 'plotfig', 1);
OcRS
plot(OcRS)
figure;plot(OcRS)
figure;hist3(OcRS)
figure;hist(OcRS)
Oc
figure; plot(OCrS)
figure; plot(OcRS)
pcolor(OcRS)
shape(OcRS)
size(OcRS)
sum(OcRS, 1)
plot(sum(OcRS, 1))
plot(sum(OcRS, 0))
plot(sum(OcRS, 2))
plot(sum(OcRS, 1))
OcRS(63,:) = sum(OcRS,1)
pcolor(OcRS)
OcRS = OcRS(1:62,:)
OcRS(63,:) = sum(OcRS,1)
OcRS(63,:) = OcRS(63,:)/sum(OcRS(63,:))
pcolor(OcRS)
figure; plot(behavior.positions(:,1), behavior.positions(:,2))
clear all
load('behavResources.mat')
load('nnBehavior.mat')
figure; plot(behavior.positions(:,1), behavior.positions(:,2))
[Oc,OcS,OcR,OcRS]=OccupancyMapDB(AlignedXtsd,AlignedYtsd,'smoothing', 1.5, 'size', 50, 'video', 15, 'plotfig', 1);
figrue; plot(Data(Xtsd), Data(Ytsd))
figure; plot(Data(Xtsd), Data(Ytsd))
clear all
load('behavResources.mat')
load('nnBehavior.mat')
figure; plot(Data(Xtsd), Data(Ytsd))
figure; plot(Data(AlignedXtsd), Data(AlignedYtsd))
figure; plot(behavior.positions(:,1), behavior.positions(:,2))
clear all
load('behavResources.mat')
load('nnBehavior.mat')
figure; plot(Data(Xtsd), Data(Ytsd))
figure; plot(Data(AlignedXtsd), Data(AlignedYtsd))
figure; plot(behavior.positions(:,1), behavior.positions(:,2))
figure; plot(behavior.positions(:,1), behavior.positions(:,2))
clear all
clear all
load('behavResources.mat')
load('nnBehavior.mat')
figure("Name", "nnBehavior"); plot(behavior.positions(:,1), behavior.positions(:,2))
figure('Name', 'rawTsd'); plot(Data(Xtsd), Data(Ytsd))
figure('Name', 'Alignedtsd'); plot(Data(AlignedXtsd), Data(AlignedYtsd))
clear all
> load('behavResources.mat')
load('nnBehavior.mat')
figure("Name", "nnBehavior"); plot(behavior.positions(:,1), behavior.positions(:,2))
figure('Name', 'rawTsd'); plot(Data(Xtsd), Data(Ytsd))
figure('Name', 'Alignedtsd'); plot(Data(AlignedXtsd), Data(AlignedYtsd))
clear all
load('behavResources.mat')
load('nnBehavior.mat')
figure("Name", "nnBehavior"); plot(behavior.positions(:,1), behavior.positions(:,2))
figure('Name', 'rawTsd'); plot(Data(Xtsd), Data(Ytsd))
figure('Name', 'Alignedtsd'); plot(Data(AlignedXtsd), Data(AlignedYtsd))
clear all
> load('beh
load('behavResources.mat')
load('nnBehavior.mat')
figure("Name", "nnBehavior"); plot(behavior.positions(:,1), behavior.positions(:,2))
figure('Name', 'rawTsd'); plot(Data(Xtsd), Data(Ytsd))
figure('Name', 'Alignedtsd'); plot(Data(AlignedXtsd), Data(AlignedYtsd))
clear all
%-- 17/11/2024 16:40:59 --%
load('behavResources.mat')
plot(Data(AlignedXtsd), Data(AlignedYtsd))
OccupancyMapDB(Data(CleanAlignedXtsd), Data(CleanAlignedYtsd))
OccupancyMapDB(Data(AlignedXtsd), Data(AlignedYtsd))
%-- 02/12/2024 12:21:31 --%
edit FreezingCameraAnalyses_UMaze_BM.m
cl
clear all
Trajectories_Maze_BM
edit Trajectories_Maze_BM.m
edit Trajectories_Function_Maze_BM.m
edit PlotSessionTrajectories.m
edit PathForExperimentsERC.m
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
edit RestrictPathForExperiment.m
path_dict = conditions = {
"MFB":["1281", "1239", "13360", "12810", "12390"],
"Known":["1336", "13361"],
"PAG": ["1186", "1161", "11610", "1124", "1186", "1117", "1199", "994"],
"Umaze":["1199", "906", "1168", "905","1182"],
#WARNING: 994 has non-aligned nnbehavior.positions; hence the results should not be trusted
}
}conditions = {
"MFB":["1281", "1239", "13360", "12810", "12390"],
"Known":["1336", "13361"],
"PAG": ["1186", "1161", "11610", "1124", "1186", "1117", "1199", "994"],
"Umaze":["1199", "906", "1168", "905","1182"],
#WARNING: 994 has non-aligned nnbehavior.positions; hence the results should not be trusted
}
conditions = {
"MFB":[1281, 1239, 13360, 12810, 12390],
"Known":[1336, 13361],
"PAG": [1186, 1161, 11610, 1124, 1186, 1117, 1199, 994],
"Umaze":[1199, 906, 1168, 905,1182],
#WARNING: 994 has non-aligned nnbehavior.positions; hence the results should not be trusted
}
{'1239vBasile': 'TEST3_Basile_M1239/TEST',
'1281vBasile': 'TEST3_Basile_1281MFB/TEST',
'1199': 'TEST1_Basile/TEST',
'1336': 'Known_M1336/TEST/',
'1168MFB': 'DataERC2/M1168/TEST/',
'905': 'DataERC2/M905/TEST/',
'1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
'1161': 'DataERC2/M1161/TEST initial/',
'1124': 'DataERC2/M1124/TEST/',
'1186': 'DataERC2/M1186/TEST/',
'1182': 'DataERC2/M1182/TEST/',
'1168UMaze': 'DataERC1/M1168/TEST/',
'1117': 'DataERC1/M1117/TEST/',
'994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
'1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
'1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
'1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
'1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'}
nain = py.dict({'1239vBasile': 'TEST3_Basile_M1239/TEST',
'1281vBasile': 'TEST3_Basile_1281MFB/TEST',
'1199': 'TEST1_Basile/TEST',
'1336': 'Known_M1336/TEST/',
'1168MFB': 'DataERC2/M1168/TEST/',
'905': 'DataERC2/M905/TEST/',
'1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
'1161': 'DataERC2/M1161/TEST initial/',
'1124': 'DataERC2/M1124/TEST/',
'1186': 'DataERC2/M1186/TEST/',
'1182': 'DataERC2/M1182/TEST/',
'1168UMaze': 'DataERC1/M1168/TEST/',
'1117': 'DataERC1/M1117/TEST/',
'994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
'1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
'1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
'1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
'1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'})
nain
dp = py.dict(soup=3.57,bread=2.29,bacon=3.91,salad=5.00);
dp
dpp = dictionary({'1239vBasile': 'TEST3_Basile_M1239/TEST',
'1281vBasile': 'TEST3_Basile_1281MFB/TEST',
'1199': 'TEST1_Basile/TEST',
'1336': 'Known_M1336/TEST/',
'1168MFB': 'DataERC2/M1168/TEST/',
'905': 'DataERC2/M905/TEST/',
'1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
'1161': 'DataERC2/M1161/TEST initial/',
'1124': 'DataERC2/M1124/TEST/',
'1186': 'DataERC2/M1186/TEST/',
'1182': 'DataERC2/M1182/TEST/',
'1168UMaze': 'DataERC1/M1168/TEST/',
'1117': 'DataERC1/M1117/TEST/',
'994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
'1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
'1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
'1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
'1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'})
dppp = py.dict({'1239vBasile': 'TEST3_Basile_M1239/TEST',
'1281vBasile': 'TEST3_Basile_1281MFB/TEST',
'1199': 'TEST1_Basile/TEST',
'1336': 'Known_M1336/TEST/',
'1168MFB': 'DataERC2/M1168/TEST/',
'905': 'DataERC2/M905/TEST/',
'1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
'1161': 'DataERC2/M1161/TEST initial/',
'1124': 'DataERC2/M1124/TEST/',
'1186': 'DataERC2/M1186/TEST/',
'1182': 'DataERC2/M1182/TEST/',
'1168UMaze': 'DataERC1/M1168/TEST/',
'1117': 'DataERC1/M1117/TEST/',
'994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
'1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
'1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
'1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
'1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'})
dpp = py.dict('1239vBasile'= 'TEST3_Basile_M1239/TEST',
'1281vBasile'= 'TEST3_Basile_1281MFB/TEST',
'1199'= 'TEST1_Basile/TEST',
'1336'= 'Known_M1336/TEST/',
'1168MFB'= 'DataERC2/M1168/TEST/',
'905'= 'DataERC2/M905/TEST/',
'1161w1199'= 'DataERC2/M1161/TEST_with_1199_model/',
'1161'= 'DataERC2/M1161/TEST initial/',
'1124'= 'DataERC2/M1124/TEST/',
'1186'= 'DataERC2/M1186/TEST/',
'1182'= 'DataERC2/M1182/TEST/',
'1168UMaze'= 'DataERC1/M1168/TEST/',
'1117'= 'DataERC1/M1117/TEST/',
'994'= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
'1336v3'= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
'1336v2'= 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
'1281v2'= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
'1239v3'= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
dppp = py.dict(1239vBasile= 'TEST3_Basile_M1239/TEST',
1281vBasile= 'TEST3_Basile_1281MFB/TEST',
1199= 'TEST1_Basile/TEST',
1336= 'Known_M1336/TEST/',
1168MFB= 'DataERC2/M1168/TEST/',
905= 'DataERC2/M905/TEST/',
1161w1199= 'DataERC2/M1161/TEST_with_1199_model/',
1161= 'DataERC2/M1161/TEST initial/',
1124= 'DataERC2/M1124/TEST/',
1186= 'DataERC2/M1186/TEST/',
1182= 'DataERC2/M1182/TEST/',
1168UMaze= 'DataERC1/M1168/TEST/',
1117= 'DataERC1/M1117/TEST/',
994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
py.dict(1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3')
py.dict( 1239v3 = 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3')
py.dict( s1239v3 = 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3')
py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST',
m1281vBasile= 'TEST3_Basile_1281MFB/TEST',
m1199= 'TEST1_Basile/TEST',
m1336= 'Known_M1336/TEST/',
m1168MFB= 'DataERC2/M1168/TEST/',
m905= 'DataERC2/M905/TEST/',
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/',
m1161= 'DataERC2/M1161/TEST initial/',
m1124= 'DataERC2/M1124/TEST/',
m1186= 'DataERC2/M1186/TEST/',
m1182= 'DataERC2/M1182/TEST/',
m1168UMaze= 'DataERC1/M1168/TEST/',
m1117= 'DataERC1/M1117/TEST/',
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
mydict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
mydict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3')
pathdir = '/home/mickey/Documents/Theotime/DimaERC2'
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict)
cl all
clear all
pathdir = '/home/mickey/Documents/Theotime/DimaERC2'
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict)
pathdir = str('/home/mickey/Documents/Theotime/DimaERC2')
pathdir = string('/home/mickey/Documents/Theotime/DimaERC2')
% Assuming matlab_dict is already defined and populated
keys = keys(matlab_dict); % Extract keys from the dictionary
values = values(matlab_dict); % Extract values from the dictionary
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
for i = 1:numel(keys)
a = a + 1;
currentKey = keys{i};
currentPath = values{i};
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
% Assuming matlab_dict is already defined and populated
keys = keys(matlab_dict); % Extract keys from the dictionary
values = values(matlab_dict); % Extract values from the dictionary
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
for i = 1:numel(keys)
a = a + 1;
currentKey = keys{i};
currentPath = values{i};
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath, "..");
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
% Assuming matlab_dict is already defined and populated
keys = keys(matlab_dict); % Extract keys from the dictionary
values = values(matlab_dict); % Extract values from the dictionary
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
for i = 1:numel(keys)
a = a + 1;
currentKey = keys{i};
currentPath = values{i};
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath, "../");
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
clear all
pathdir = string('/home/mickey/Documents/Theotime/DimaERC2')
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict)
keys = keys(matlab_dict); % Extract keys from the dictionary
values = values(matlab_dict); % Extract values from the dictionary
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
for i = 1:numel(keys)
a = a + 1;
currentKey = keys{i};
currentPath = values{i};
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath, "../");
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
pathdir = "/home/mickey/Documents/Theotime/DimaERC2"
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict)
% Assuming matlab_dict is already defined and populated
keys = keys(matlab_dict); % Extract keys from the dictionary
values = values(matlab_dict); % Extract values from the dictionary
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
for i = 1:numel(keys)
a = a + 1;
currentKey = keys{i};
currentPath = values{i};
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath, "../");
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
clear all
pathdir = "/home/mickey/Documents/Theotime/DimaERC2"
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict)
% Assuming matlab_dict is already defined and populated
keys = keys(matlab_dict); % Extract keys from the dictionary
values = values(matlab_dict); % Extract values from the dictionary
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
for i = 1:numel(keys)
a = a + 1;
currentKey = keys{i};
resultsPath = values{i};
currentPath = fullfile(resultsPath, "..")
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
%% Mazes
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC('All');
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
edit PlotSessionTrajectories.m
PlotSessionTrajectories_TC([994, 1239v3])
PlotSessionTrajectories_TC([994, 1239])
PlotSessionTrajectories_TC([994])
PlotSessionTrajectories_TC(994)
clear all
PlotSessionTrajectories_TC(994)
mice = [994]
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC('All');
Dir = PathForExperiments_TC("All");
clear all
PlotSessionTrajectories(994)
PlotSessionTrajectories_TC(994)
edit PlotSessionTrajectories.m
PlotSessionTrajectories_TC(994)
PlotSessionTrajectories_TC
PlotSessionTrajectories_TC(994)
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
Dir = PathForExperiments_TC("Sub");
subpython_dict = py.dict(1336= 'Known_M1336/TEST/', 994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
1186= 'DataERC2/M1186/TEST/', 1199= 'TEST1_Basile/TEST', 1117= 'DataERC1/M1117/TEST/',
1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', 1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', 1168UMaze= 'DataERC1/M1168/TEST/', 1182= 'DataERC2/M1182/TEST/',
1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2')
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
m1186= 'DataERC2/M1186/TEST/', m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3',
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
m1168UMaze= 'DataERC1/M1168/TEST/', m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2'
)
submatlab_dict=dictionary(subpython_dict);
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
m1186= 'DataERC2/M1186/TEST/', m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3',
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
m1168UMaze= 'DataERC1/M1168/TEST/', m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2'
);
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3',
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
m1168UMaze= 'DataERC1/M1168/TEST/', m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2'
);
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
%% Mazes
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
a = cell(length(Dir.path),1);
%% Mazes
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
clear all
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
pathdir = "/home/mickey/Documents/Theotime/DimaERC2";
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
experimentName = "Sub"
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
print(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
print(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
temp
Dir.path{i}
Dir.path{i}[1]
Dir.path{i}[1}
Dir.path{i}{1}
strfind(Dir.path{i}{1},'/M')
currentPath
%-- 04/12/2024 10:08:59 --%
PlotSessionTrajectories_TC(["994", "1239v3"])
i
0
ans*
ans
experimentName="Sub"
function Dir = PathForExperimentsERC(experimentName)
%% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = "/home/mickey/Documents/Theotime/DimaERC2";
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
%% Get mice groups
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
if strcmp(Dir.manipe{i},'UMazePAG')
% Allocate
Dir.group{1} = cell(length(Dir.path),1);
Dir.group{2} = cell(length(Dir.path),1);
Dir.group{3} = cell(length(Dir.path),1);
Dir.group{4} = cell(length(Dir.path),1);
Dir.group{5} = cell(length(Dir.path),1);
Dir.group{6} = cell(length(Dir.path),1);
for j=1:length(LFP)
Dir.group{1}{LFP(j)} = 'LFP';
end
for j=1:length(Neurons)
Dir.group{2}{Neurons(j)} = 'Neurons';
end
for j=1:length(ECG)
Dir.group{3}{ECG(j)} = 'ECG';
end
for j=1:length(OB_resp)
Dir.group{4}{OB_resp(j)} = 'OB_resp';
end
for j=1:length(OB_gamma)
Dir.group{5}{OB_gamma(j)} = 'OB_gamma';
end
for j=1:length(PFC)
Dir.group{6}{PFC(j)} = 'PFC';
end
end
end
end
%% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = "/home/mickey/Documents/Theotime/DimaERC2";
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
temp
Dir.path{i}{1}
strfind(Dir.path{i}{1},'/M');
strfind(Dir.path{i}{1},'/M')
strfind(Dir.path{i}{1},'/M994')
strfind(Dir.path{i}{1},'/994')
strfind(Dir.path{i}{1},'994')
strfind(Dir.path{i}{1},'/M994')
isempty(temp)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
end
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
clear all
%% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = "/home/mickey/Documents/Theotime/DimaERC2";
python_dict = py.dict(m1239vBasile= 'M1239TEST3_Basile_M1239/TEST', m1281vBasile= 'M1281TEST3_Basile_1281MFB/TEST', ...
m1199= 'M1199TEST1_Basile/TEST', m1336= 'M1336_Known/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'M1336_Known/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'M1199TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
experimentName = "Sub"
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
%% Get mice groups
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
if strcmp(Dir.manipe{i},'UMazePAG')
% Allocate
Dir.group{1} = cell(length(Dir.path),1);
Dir.group{2} = cell(length(Dir.path),1);
Dir.group{3} = cell(length(Dir.path),1);
Dir.group{4} = cell(length(Dir.path),1);
Dir.group{5} = cell(length(Dir.path),1);
Dir.group{6} = cell(length(Dir.path),1);
for j=1:length(LFP)
Dir.group{1}{LFP(j)} = 'LFP';
end
for j=1:length(Neurons)
Dir.group{2}{Neurons(j)} = 'Neurons';
end
for j=1:length(ECG)
Dir.group{3}{ECG(j)} = 'ECG';
end
for j=1:length(OB_resp)
Dir.group{4}{OB_resp(j)} = 'OB_resp';
end
for j=1:length(OB_gamma)
Dir.group{5}{OB_gamma(j)} = 'OB_gamma';
end
for j=1:length(PFC)
Dir.group{6}{PFC(j)} = 'PFC';
end
end
end
end
temp
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
isempty(temp)
strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.path{i}{1}(temp(1)+2)
temp
temp(1)
temp(1)+2
Dir.path{i}{1}
Dir.path{i}{1}(temp(1))
%% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = '/home/mickey/Documents/Theotime/DimaERC2';
python_dict = py.dict(m1239vBasile= 'M1239TEST3_Basile_M1239/TEST', m1281vBasile= 'M1281TEST3_Basile_1281MFB/TEST', ...
m1199= 'M1199TEST1_Basile/TEST', m1336= 'M1336_Known/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'M1336_Known/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'M1199TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
%% Get mice groups
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
if strcmp(Dir.manipe{i},'UMazePAG')
% Allocate
Dir.group{1} = cell(length(Dir.path),1);
Dir.group{2} = cell(length(Dir.path),1);
Dir.group{3} = cell(length(Dir.path),1);
Dir.group{4} = cell(length(Dir.path),1);
Dir.group{5} = cell(length(Dir.path),1);
Dir.group{6} = cell(length(Dir.path),1);
for j=1:length(LFP)
Dir.group{1}{LFP(j)} = 'LFP';
end
for j=1:length(Neurons)
Dir.group{2}{Neurons(j)} = 'Neurons';
end
for j=1:length(ECG)
Dir.group{3}{ECG(j)} = 'ECG';
end
for j=1:length(OB_resp)
Dir.group{4}{OB_resp(j)} = 'OB_resp';
end
for j=1:length(OB_gamma)
Dir.group{5}{OB_gamma(j)} = 'OB_gamma';
end
for j=1:length(PFC)
Dir.group{6}{PFC(j)} = 'PFC';
end
end
end
end
temp
PlotSessionTrajectories_TC(["994", "1239v3"])
PlotSessionTrajectories_TC(['994', '1239v3'])
PlotSessionTrajectories_TC([994, 1239v3])
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir
PlotSessionTrajectories_TC([994 1239v3])
PlotSessionTrajectories_TC([994 1239])
PlotSessionTrajectories_TC([994*])
PlotSessionTrajectories_TC([994])
mice = [994]
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
Dir
a = cell(length(Dir.path),1);
a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
end
%% Find necessary tests
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));
for i=1:length(a)
id_Pre{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPre');
id_Cond{i} = FindSessionID_ERC(a{i}.behavResources, 'Cond');
id_Post{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPost');
end
load(file:///home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat)
load('home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat')
file:///home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat
load('home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat', 'naiaina')
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat', 'naiaina')
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat')
Warning: Function newline has the same name as a MATLAB built-in. We suggest you rename the function to avoid a potential name conflict.
> In path (line 109)
In addpath>doPathAddition (line 126)
In addpath (line 90)
In startup (line 5)
>> PlotSessionTrajectories_TC(["994", "1239v3"])
Warning: ExpeInfo.mat not found for m1336
> In PathForExperiments_TC (line 113)
In PlotSessionTrajectories_TC (line 30)
Warning: ExpeInfo.mat not found for m994
> In PathForExperiments_TC (line 113)
In PlotSessionTrajectories_TC (line 30)
Warning: ExpeInfo.mat not found for m1199
> In PathForExperiments_TC (line 113)
In PlotSessionTrajectories_TC (line 30)
Warning: ExpeInfo.mat not found for m1239v3
> In PathForExperiments_TC (line 113)
In PlotSessionTrajectories_TC (line 30)
Warning: ExpeInfo.mat not found for m1336v3
> In PathForExperiments_TC (line 113)
In PlotSessionTrajectories_TC (line 30)
Warning: ExpeInfo.mat not found for m1281v2
> In PathForExperiments_TC (line 113)
In PlotSessionTrajectories_TC (line 30)
Warning: ExpeInfo.mat not found for m1336v2
> In PathForExperiments_TC (line 113)
In PlotSessionTrajectories_TC (line 30)
Error in Filename - No MOUSE number
66
Index exceeds the number of array elements. Index must not exceed 1.
Error in PathForExperiments_TC (line 520)
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
^^^^^^^^^^^^^^^^^^^^^^^^^
Error in PlotSessionTrajectories_TC (line 30)
Dir = PathForExperiments_TC("Sub");
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>>
>> PlotSessionTrajectories_TC(["994", "1239v3"])
Error in Filename - No MOUSE number
66
Index exceeds the number of array elements. Index must not exceed 1.
Error in PathForExperiments_TC (line 520)
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
^^^^^^^^^^^^^^^^^^^^^^^^^
Error in PlotSessionTrajectories_TC (line 30)
Dir = PathForExperiments_TC("Sub");
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> i
ans =
0.0000 + 1.0000i
>> 0
ans =
0
>> ans*
ans*
↑
Error: Invalid expression. Check for missing or extra characters.
>> ans
ans =
0
>> ans
ans =
0
>> experimentName="Sub"
experimentName =
"Sub"
>> function Dir = PathForExperimentsERC(experimentName)
%% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = "/home/mickey/Documents/Theotime/DimaERC2";
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
%% Get mice groups
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
if strcmp(Dir.manipe{i},'UMazePAG')
% Allocate
Dir.group{1} = cell(length(Dir.path),1);
Dir.group{2} = cell(length(Dir.path),1);
Dir.group{3} = cell(length(Dir.path),1);
Dir.group{4} = cell(length(Dir.path),1);
Dir.group{5} = cell(length(Dir.path),1);
Dir.group{6} = cell(length(Dir.path),1);
for j=1:length(LFP)
Dir.group{1}{LFP(j)} = 'LFP';
end
for j=1:length(Neurons)
Dir.group{2}{Neurons(j)} = 'Neurons';
end
for j=1:length(ECG)
Dir.group{3}{ECG(j)} = 'ECG';
end
for j=1:length(OB_resp)
Dir.group{4}{OB_resp(j)} = 'OB_resp';
end
for j=1:length(OB_gamma)
Dir.group{5}{OB_gamma(j)} = 'OB_gamma';
end
for j=1:length(PFC)
Dir.group{6}{PFC(j)} = 'PFC';
end
end
end
end
function Dir = PathForExperimentsERC(experimentName)
↑
Error: Function definitions are not supported in this context. Functions can only be created as local or nested functions in code files.
>>
%% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = "/home/mickey/Documents/Theotime/DimaERC2";
python_dict = py.dict(m1239vBasile= 'TEST3_Basile_M1239/TEST', m1281vBasile= 'TEST3_Basile_1281MFB/TEST', ...
m1199= 'TEST1_Basile/TEST', m1336= 'Known_M1336/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'Known_M1336/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
>>
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
Error in Filename - No MOUSE number
66
Index exceeds the number of array elements. Index must not exceed 1.
>> temp
temp =
66
>> Dir.path{i}{1}
ans =
"/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/Final_results_v3/.."
>> strfind(Dir.path{i}{1},'/M');
>> strfind(Dir.path{i}{1},'/M')
ans =
66
>> strfind(Dir.path{i}{1},'/M994')
ans =
66
>> strfind(Dir.path{i}{1},'/994')
ans =
[]
>> strfind(Dir.path{i}{1},'994')
ans =
68
>> strfind(Dir.path{i}{1},'/M994')
ans =
66
>>
>> isempty(temp)
ans =
logical
0
>>     Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
>> if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
end
66
Index exceeds the number of array elements. Index must not exceed 1.
>> for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
disp(temp)
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
Error in Filename - No MOUSE number
66
Index exceeds the number of array elements. Index must not exceed 1.
>> clear all
>> %% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = "/home/mickey/Documents/Theotime/DimaERC2";
python_dict = py.dict(m1239vBasile= 'M1239TEST3_Basile_M1239/TEST', m1281vBasile= 'M1281TEST3_Basile_1281MFB/TEST', ...
m1199= 'M1199TEST1_Basile/TEST', m1336= 'M1336_Known/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'M1336_Known/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'M1199TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
>> experimentName = "Sub"
experimentName =
"Sub"
>> if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
%% Get mice groups
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
if strcmp(Dir.manipe{i},'UMazePAG')
% Allocate
Dir.group{1} = cell(length(Dir.path),1);
Dir.group{2} = cell(length(Dir.path),1);
Dir.group{3} = cell(length(Dir.path),1);
Dir.group{4} = cell(length(Dir.path),1);
Dir.group{5} = cell(length(Dir.path),1);
Dir.group{6} = cell(length(Dir.path),1);
for j=1:length(LFP)
Dir.group{1}{LFP(j)} = 'LFP';
end
for j=1:length(Neurons)
Dir.group{2}{Neurons(j)} = 'Neurons';
end
for j=1:length(ECG)
Dir.group{3}{ECG(j)} = 'ECG';
end
for j=1:length(OB_resp)
Dir.group{4}{OB_resp(j)} = 'OB_resp';
end
for j=1:length(OB_gamma)
Dir.group{5}{OB_gamma(j)} = 'OB_gamma';
end
for j=1:length(PFC)
Dir.group{6}{PFC(j)} = 'PFC';
end
end
end
end
Index exceeds the number of array elements. Index must not exceed 1.
>> temp
temp =
41
>>     Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
>> isempty(temp)
ans =
logical
1
Index exceeds the number of array elements. Index must not exceed 1.
Error in PathForExperiments_TC (line 519)
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Index exceeds the number of array elements. Index must not exceed 1.
Error in PathForExperiments_TC (line 519)
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Index exceeds the number of array elements. Index must not exceed 1.
Error in PathForExperiments_TC (line 519)
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
>>         temp=strfind(Dir.path{i}{1},'/M');
>> isempty(temp)
ans =
logical
0
>> strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Index exceeds the number of array elements. Index must not exceed 1.
>> Dir.path{i}{1}(temp(1)+2)
Index exceeds the number of array elements. Index must not exceed 1.
>> temp
temp =
41
>> temp(1)
ans =
41
>> temp(1)+2
ans =
43
>> Dir.path{i}{1}
ans =
"/home/mickey/Documents/Theotime/DimaERC2/M1336_Known/TEST/.."
>> Dir.path{i}{1}(temp(1))
Index exceeds the number of array elements. Index must not exceed 1.
>>
%% Groups PAG expe
% Concatenated - small zone (starting with 797)
LFP = 6:21; % Good LFP
Neurons = [6 7 8 10 12:21]; % Good Neurons
ECG = [6 9 10 14 15]; % Good ECG
OB_resp = [6:10 13 14 16:21];
OB_gamma = [6:8 10 11 13 14 16:20];
PFC = [6:14 16:18 21];
% Concatenated - big and small zone
LFP_All = 1:21; % Good LFP
Neurons_All = [1 6 7 8 10 12:21]; % Good Neurons
ECG_All = [1 3 5 6 9 10 14 15]; % Good ECG
%%
a=0;
%%
%  '1239vBasile': 'TEST3_Basile_M1239/TEST',
%  '1281vBasile': 'TEST3_Basile_1281MFB/TEST',
%  '1199': 'TEST1_Basile/TEST',
%  '1336': 'Known_M1336/TEST/',
%  '1168MFB': 'DataERC2/M1168/TEST/',
%  '905': 'DataERC2/M905/TEST/',
%  '1161w1199': 'DataERC2/M1161/TEST_with_1199_model/',
%  '1161': 'DataERC2/M1161/TEST initial/',
%  '1124': 'DataERC2/M1124/TEST/',
%  '1186': 'DataERC2/M1186/TEST/',
%  '1182': 'DataERC2/M1182/TEST/',
%  '1168UMaze': 'DataERC1/M1168/TEST/',
%  '1117': 'DataERC1/M1117/TEST/',
%  '994': 'neuroencoders_1021/_work/M994_PAG/Final_results_v3',
%  '1336v3': 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3',
%  '1336v2': 'neuroencoders_1021/_work/M1336_known/Final_results_v2',
%  '1281v2': 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2',
%  '1239v3': 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3'
%
pathdir = '/home/mickey/Documents/Theotime/DimaERC2';
python_dict = py.dict(m1239vBasile= 'M1239TEST3_Basile_M1239/TEST', m1281vBasile= 'M1281TEST3_Basile_1281MFB/TEST', ...
m1199= 'M1199TEST1_Basile/TEST', m1336= 'M1336_Known/TEST/', m1168MFB= 'DataERC2/M1168/TEST/', m905= 'DataERC2/M905/TEST/', ...
m1161w1199= 'DataERC2/M1161/TEST_with_1199_model/', m1161= 'DataERC2/M1161/TEST initial/', ...
m1124= 'DataERC2/M1124/TEST/', m1186= 'DataERC2/M1186/TEST/', m1182= 'DataERC2/M1182/TEST/', ...
m1168UMaze= 'DataERC1/M1168/TEST/', m1117= 'DataERC1/M1117/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2', m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3');
matlab_dict=dictionary(python_dict);
% Assuming matlab_dict is already defined and populated
keyss = keys(matlab_dict); % Extract keys from the dictionary
valuess = values(matlab_dict); % Extract values from the dictionary
subpython_dict = py.dict(m1336= 'M1336_Known/TEST/', ...
m994= 'neuroencoders_1021/_work/M994_PAG/Final_results_v3', m1186= 'DataERC2/M1186/TEST/', ...
m1199= 'M1199TEST1_Basile/TEST', m1117= 'DataERC1/M1117/TEST/', ...
m1239v3= 'neuroencoders_1021/_work/M1239_MFB/Final_results_v3', ...
m1336v3= 'neuroencoders_1021/_work/M1336_MFB/Final_results_v3', ...
m1281v2= 'neuroencoders_1021/_work/M1281_MFB/Final_results_v2', m1168UMaze= 'DataERC1/M1168/TEST/', ...
m1182= 'DataERC2/M1182/TEST/', m1336v2= 'neuroencoders_1021/_work/M1336_known/Final_results_v2');
submatlab_dict=dictionary(subpython_dict);
Dir.path = {}; % Initialize a cell array for paths
Dir.ExpeInfo = {}; % Initialize a cell array for ExpeInfo
a = 0; % Initialize counter
if strcmp(experimentName,'All')
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName, "Sub")
% Assuming matlab_dict is already defined and populated
keyss = keys(submatlab_dict); % Extract keys from the dictionary
valuess = values(submatlab_dict); % Extract values from the dictionary
for i = 1:numel(keyss)
a = a + 1;
currentKey = keyss{i};
resultsPath = valuess{i};
currentPath = fullfile(resultsPath, "..");
% Assign path
Dir.path{a}{1} = fullfile(pathdir, currentPath);
% Load ExpeInfo
expeInfoFile = fullfile(Dir.path{a}{1}, 'ExpeInfo.mat');
if isfile(expeInfoFile)
load(expeInfoFile, 'ExpeInfo');
Dir.ExpeInfo{a} = ExpeInfo;
else
warning('ExpeInfo.mat not found for %s', currentKey);
end
end
elseif strcmp(experimentName,'UMazePAG')
% Mouse711
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse712
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse714
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse742
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse753
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse797
a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse798
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse828
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse861
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse905
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse906
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse911
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse912
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse977
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191013/PagExp/_Concatenated/';
%         a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-994/20191106/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K117/20201109/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1124
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K124/20201120/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K162/20210121/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K168/20210122/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K182/20200301/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1186
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1230
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K230/20210927/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC2/Mouse-K230/20211004/_Concatenated/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC2/Mouse-K239/2021110/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'StimMFBWake')
% Mouse882
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0882/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse936
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0936/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse941
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0941/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse934
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0934/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse935
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0935/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse863
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0863/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse913
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M0913/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% 8 x 2 min pre and post tests mice
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/StimMFBWake/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1182/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1199/exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1228/take2/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1239
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1257
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1257/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
% exp 1
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1317/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% exp 2
Dir.path{a}{2}='/media/nas7/ProjetERC1/StimMFBWake/M1317/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1334/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/StimMFBWake/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Reversal')
% Mouse994
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/M994/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1081
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K081/20200925/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC3/M1199/Reversal/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'UMazePAGPCdriven')
% Mouse 1115
a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-K115/20201006/_Concatenated/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Novel')
%%%% Only hab - 6 mice
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse882 - no spikes
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% %
% %     % Mouse905
% %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
% %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse912
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-912/20190506/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse977
%
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-977/20190809/FirstUMaze/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%     % Mouse979
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-979/20190828/FirstExplo/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, no PostTests - 4 mice
% MouseK016
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1016/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1081
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1081/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1083
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1083/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1183
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1183/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 2 min, Cond 8 * 4 min, PostTests 4 * 2 min - 2 mice
% Mouse1116
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1116/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1117
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1117/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, PostTests 8 * 2 min
% Mouse1161
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1161/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1162
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1162/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1182
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1182/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1185/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1223
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1223/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1228
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1228/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1281
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1317
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1334 - NO REM
%     a=a+1;Dir.path{a}{1}='/media/hobbes/DataMOBS163/M1334/Novel/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse1336
a=a+1;Dir.path{a}{1}='/media/nas7/ProjetERC1/Novel/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 8 * 2 min, Cond 8 * 4 min, no PostTests
% Mouse1168
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1168/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%%%%%% PreTests 4 * 4 min, Cond 8 * 4 min, PostTests 4 * 4 min
% Mouse1239
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/Novel/M1239/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'BaselineSleep')
% Mouse 1162 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1162 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1162/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 1
a=a+1;
Dir.path{a}{1}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 2
Dir.path{a}{2}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1168 - 3
Dir.path{a}{3}='/media/hobbes/DataMOBs155/M1168/BaselineSleep/3/';
load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1185
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1185/20210412/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1199
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1199/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1230
a=a+1;Dir.path{a}{1}='/media/nas6/ProjetERC1/BaselineSleep/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
elseif strcmp(experimentName,'Known')
% Mouse 1230
a=a+1;
Dir.path{a}{1}='/media/nas6/ProjetERC1/Known/M1230/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1281
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1281/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1317
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1317/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1334
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1334/1/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
Dir.path{a}{2}='/media/nas7/ProjetERC1/Known/M1334/2/';
load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
% Mouse 1336
a=a+1;
Dir.path{a}{1}='/media/nas7/ProjetERC1/Known/M1336/';
load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
end
%% Get mice names
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
temp=strfind(Dir.path{i}{1},'Mouse-');
disp(temp)
if isempty(temp)
temp=strfind(Dir.path{i}{1},'/M');
if isempty(temp)
disp('Error in Filename - No MOUSE number')
else
if strcmp(Dir.path{i}{1}(temp(1)+2),'1')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+5)];
elseif strcmp(Dir.path{i}{1}(temp(1)+2),'0')
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+3:temp+5)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+2:temp+4)];
end
end
else
if strcmp(Dir.path{i}{1}(temp(1)+6), 'K')
Dir.name{i}=['Mouse1',Dir.path{i}{1}(temp(1)+7:temp(1)+9)];
else
Dir.name{i}=['Mouse',Dir.path{i}{1}(temp(1)+6:temp(1)+8)];
end
end
end
%% Get mice groups
for i=1:length(Dir.path)
Dir.manipe{i}=experimentName;
if strcmp(Dir.manipe{i},'UMazePAG')
% Allocate
Dir.group{1} = cell(length(Dir.path),1);
Dir.group{2} = cell(length(Dir.path),1);
Dir.group{3} = cell(length(Dir.path),1);
Dir.group{4} = cell(length(Dir.path),1);
Dir.group{5} = cell(length(Dir.path),1);
Dir.group{6} = cell(length(Dir.path),1);
for j=1:length(LFP)
Dir.group{1}{LFP(j)} = 'LFP';
end
for j=1:length(Neurons)
Dir.group{2}{Neurons(j)} = 'Neurons';
end
for j=1:length(ECG)
Dir.group{3}{ECG(j)} = 'ECG';
end
for j=1:length(OB_resp)
Dir.group{4}{OB_resp(j)} = 'OB_resp';
end
for j=1:length(OB_gamma)
Dir.group{5}{OB_gamma(j)} = 'OB_gamma';
end
for j=1:length(PFC)
Dir.group{6}{PFC(j)} = 'PFC';
end
end
end
end
Index exceeds the number of array elements. Index must not exceed 1.
>>
>> temp
temp =
41
>> PlotSessionTrajectories_TC(["994", "1239v3"])
Error using num2str (line 24)
Input to num2str must be numeric.
Error in RestrictPathForExperiment_TC (line 32)
disp(['Getting Mice ',num2str(nameMice),' from Dir'])
^^^^^^^^^^^^^^^^^
Error in PlotSessionTrajectories_TC (line 31)
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> PlotSessionTrajectories_TC(['994', '1239v3'])
Getting Mice 9941239v3 from Dir
No Mouse009 in Dir
No Mouse009 in Dir
No Mouse004 in Dir
No Mouse001 in Dir
No Mouse002 in Dir
No Mouse003 in Dir
No Mouse009 in Dir
No Mouse00v in Dir
No Mouse003 in Dir
>> PlotSessionTrajectories_TC([994, 1239v3])
PlotSessionTrajectories_TC([994, 1239v3])
↑
Invalid expression. Check for missing multiplication operator, missing or unbalanced delimiters, or other syntax error. To construct matrices, use
brackets instead of parentheses.
>> maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
>> Dir
Dir =
struct with fields:
path: {{1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}  {1×1 cell}}
ExpeInfo: {1×11 cell}
manipe: {["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]  ["Sub"]}
name: {1×11 cell}
>> PlotSessionTrajectories_TC([994 1239v3])
PlotSessionTrajectories_TC([994 1239v3])
↑
Invalid expression. Check for missing multiplication operator, missing or unbalanced delimiters, or other syntax error. To construct matrices, use
brackets instead of parentheses.
>> PlotSessionTrajectories_TC([994 1239])
Getting Mice 994  1239 from Dir
Unrecognized field name "CleanAlignedXtsd".
Error in PlotSessionTrajectories_TC (line 63)
plot(Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedYtsd),...
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> PlotSessionTrajectories_TC([994*])
PlotSessionTrajectories_TC([994*])
↑
Invalid expression. When calling a function or indexing a variable, use parentheses. Otherwise, check for mismatched delimiters.
>> PlotSessionTrajectories_TC([994])
Getting Mice 994 from Dir
Unrecognized field name "CleanAlignedXtsd".
Error in PlotSessionTrajectories_TC (line 63)
plot(Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedYtsd),...
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> mice = [994]
mice =
994
>> maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
Getting Mice 994 from Dir
>> Dir
Dir =
struct with fields:
path: {{1×1 cell}}
correcAmpli: 1
group: []
name: {'Mouse994'}
manipe: {["Sub"]}
>> a = cell(length(Dir.path),1);
>> a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
end
>> %% Find necessary tests
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));
for i=1:length(a)
id_Pre{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPre');
id_Cond{i} = FindSessionID_ERC(a{i}.behavResources, 'Cond');
id_Post{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPost');
end
>> load(file:///home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat)
load(file:///home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat)
↑
Invalid use of operator.
>> load('home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat')
Error using load
Unable to find file or directory 'home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat'.
>> file:///home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat
file:///home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat
↑
Invalid use of operator.
>> load('home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat', 'naiaina')
Error using load
Unable to find file or directory 'home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat'.
>> load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat', 'naiaina')
Warning: Variable 'naiaina' not found.
>> load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat')
>>
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M1239_MFB/behavResources.mat')
CleanAlignedXtsd
clear all
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M1239_MFB/behavResources.mat')
clear all
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat')
clear all
edit CleanTrajectories_DB
edit CleanTrajectories_SL.m
CleanTrajectories_DB('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat')
CleanTrajectories_DB('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG')
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M994_PAG/behavResources.mat')
clear all
mice = [994]
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
end
%% Find necessary tests
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));
for i=1:length(a)
id_Pre{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPre');
id_Cond{i} = FindSessionID_ERC(a{i}.behavResources, 'Cond');
id_Post{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPost');
end
isfield(a{i}.behavResources, "CleanAlignedXtsd")
isfield(a{i}.behavResources, "AlignedXtsd")
if (not isfield(a{i}.behavResources, "CleanAlignedXtsd")) and (isfield(a{i}.behavResources, "CleanAlignedXtsd")):
if not isfield(a{i}.behavResources, "CleanAlignedXtsd"), AND (isfield(a{i}.behavResources, "CleanAlignedXtsd")):
if not isfield(a{i}.behavResources, "CleanAlignedXtsd"), AND isfield(a{i}.behavResources, "CleanAlignedXtsd"):
disp("nain")
end
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd"), AND isfield(a{i}.behavResources, "CleanAlignedXtsd"):
disp("nain")
end
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd"), && isfield(a{i}.behavResources, "CleanAlignedXtsd"):
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd") && isfield(a{i}.behavResources, "CleanAlignedXtsd"):
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd") && isfield(a{i}.behavResources, "CleanAlignedXtsd")
disp('nain')
end
~isfield(a{i}.behavResources, "CleanAlignedXtsd")
isfield(a{i}.behavResources, "CleanAlignedXtsd")
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd") && isfield(a{i}.behavResources, "AlignedXtsd")
disp('nain')
end
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd") && isfield(a{i}.behavResources, "AlignedXtsd")
if ~isfield(a{i}.behavResources, "AlignedXtsd")
disp("No clean or aligned Xtsd found")
end
a{i}.behavResources.CleanAlignedXtsd = a{i}.behavResources.AlignedXtsd
end
a{i}.behavResources.CleanAlignedXtsd = a{i}.behavResources.AlignedXtsd
a{i}.behavResources.CleanAlignedXtsd = a{i}.behavResources.AlignedXtsd;
edit CleanTrajectories_DB.m
a{i}.behavResources.CleanAlignedXtsd = 1
a{i}.behavResources.AlignedXtsd
a{i}.behavResources.AlignedXtsd;
a{i}.behavResources.CleanAlignedXtsd
a{i}.behavResources(:).CleanAlignedXtsd = 1
a{i}.behavResources(:).CleanAlignedXtsd
a{i}.behavResources(:).CleanAlignedXtsd = a{i}.behavResources.AlignedXtsd
a{i}.behavResources(:).CleanAlignedXtsd = a{i}.behavResources(:).AlignedXtsd
a{i}.behavResources(:).CleanAlignedXtsd = a{i}.behavResources.AlignedXtsd{:}
a{i}.behavResources(:).CleanAlignedXtsd = a{i}.behavResources.AlignedXtsd{:,}
a{i}.behavResources(:).CleanAlignedXtsd = a{i}.behavResources.AlignedXtsd
numel(a{i}.behavResources
numel(a{i}.behavResources)
a{i}.behavResources.AlignedXtsd(1)
a{i}.behavResources(1).AlignedXtsd
a{i}.behavResources[{1}.AlignedXtsd
a{i}.behavResources{1}.AlignedXtsd
a{i}.behavResources(:).AlignedXtsd
a{i}.behavResources(2).AlignedXtsd
for i in 1:numel(a{i}.behavResources)
for i = 1:numel(a{i}.behavResources)
a{i}.behavResources(i).CleanAlignedXtsd = a{i}.behavResources(i).AlignedXtsd
a{i}.behavResources(i).CleanAlignedXtsd = a{i}.behavResources(i).AlignedXtsd
end
for i = 1:numel(a{i}.behavResources)
a{i}.behavResources(i).CleanAlignedXtsd = a{i}.behavResources(i).AlignedXtsd
a{i}.behavResources(i).CleanAlignedYtsd = a{i}.behavResources(i).AlignedYtsd
end
a{1, 1}.behavResources = rmfield(a{1, 1}.behavResources, 'CleanAlignedXtsd');
for i = 1:numel(a{i}.behavResources)
a{i}.behavResources(i).CleanAlignedXtsd = a{i}.behavResources(i).AlignedXtsd
a{i}.behavResources(i).CleanAlignedYtsd = a{i}.behavResources(i).AlignedYtsd
end
i = 1
a{i}
for j = 1:numel(a{i}.behavResources)
a{i}.behavResources(j).CleanAlignedXtsd = a{j}.behavResources(i).AlignedXtsd
a{i}.behavResources(j).CleanAlignedYtsd = a{j}.behavResources(i).AlignedYtsd
end
a{i}.behavResources(1)
a{i}.behavResources(2)
a{i}.behavResources(3)
a{i}.behavResources(4)
for j = 1:numel(a{i}.behavResources)
a{i}.behavResources(j).CleanAlignedXtsd = a{j}.behavResources(i).AlignedXtsd
a{i}.behavResources(j).CleanAlignedYtsd = a{j}.behavResources(i).AlignedYtsd
end
for j = 1:numel(a{i}.behavResources)
a{i}.behavResources(j).CleanAlignedXtsd = a{i}.behavResources(j).AlignedXtsd
a{i}.behavResources(j).CleanAlignedYtsd = a{i}.behavResources(j).AlignedYtsd
end
clear all
%% Mazes
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
end
clear all
mice = [994]
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
end
%% Find necessary tests
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));
for i=1:length(a)
id_Pre{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPre');
id_Cond{i} = FindSessionID_ERC(a{i}.behavResources, 'Cond');
id_Post{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPost');
end
%% Check if CleanAlignedXtsd exists
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd") && isfield(a{i}.behavResources, "AlignedXtsd")
if ~isfield(a{i}.behavResources, "AlignedXtsd")
disp("No clean or aligned Xtsd found")
end
for j = 1:numel(a{i}.behavResources)
a{i}.behavResources(j).CleanAlignedXtsd = a{i}.behavResources(j).AlignedXtsd
a{i}.behavResources(j).CleanAlignedYtsd = a{i}.behavResources(j).AlignedYtsd
end
end
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd") && isfield(a{i}.behavResources, "AlignedXtsd")
if ~isfield(a{i}.behavResources, "AlignedXtsd")
disp("No clean or aligned Xtsd found")
end
for j = 1:numel(a{i}.behavResources)
a{i}.behavResources(j).CleanAlignedXtsd = a{i}.behavResources(j).AlignedXtsd;
a{i}.behavResources(j).CleanAlignedYtsd = a{i}.behavResources(j).AlignedYtsd;
end
end
if ~isfield(a{i}.behavResources, "CleanAlignedXtsd") && isfield(a{i}.behavResources, "AlignedXtsd")
if ~isfield(a{i}.behavResources, "AlignedXtsd")
disp("No clean or aligned Xtsd found")
end
for j = 1:numel(a{i}.behavResources)
a{i}.behavResources(j).CleanAlignedXtsd = a{i}.behavResources(j).AlignedXtsd
a{i}.behavResources(j).CleanAlignedYtsd = a{i}.behavResources(j).AlignedYtsd
end
end
%% Plot
fh = figure('units', 'normalized', 'outerposition', [0 0 0.85 0.5]);
tabs = arrayfun(@(x) uitab('Title', Dir.name{x}), 1:length(Dir.path));
for itab = 1:length(tabs)
curtab = tabs(itab);
% PreTests
ax(1) = axes('Parent', curtab, 'position', [0.03 0.07 0.3 0.85]);
axes(ax(1));
hold on
for itest = 1:numtest
plot(Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedYtsd),...
'LineWidth',3, 'Color', [0.2 0.2 0.2]);
end
set(gca,'XtickLabel',{},'YtickLabel',{});
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
title('PreTests','FontSize',18,'FontWeight','bold');
xlim([0 1])
ylim([0 1])
hold off
makepretty
% Cond
ax(2) = axes('Parent', curtab, 'position', [0.36 0.07 0.3 0.85]);
axes(ax(2));
hold on
for itest = 1:numtest
plot(Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd),...
'LineWidth',3, 'Color', [0.2 0.2 0.2]);
tempX = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd);
tempY = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd);
plot(tempX(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),tempY(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),...
'p','Color','r','MarkerFaceColor','red','MarkerSize',16);
clear tempX tempY
end
set(gca,'XtickLabel',{},'YtickLabel',{});
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
title('Conditioning','FontSize',18,'FontWeight','bold');
xlim([0 1])
ylim([0 1])
hold off
makepretty
% PostTest
ax(3) = axes('Parent', curtab, 'position', [0.69 0.07 0.3 0.85]);
axes(ax(3));
hold on
for itest = 1:numtest
plot(Data(a{itab}.behavResources(id_Post{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Post{itab}(itest)).CleanAlignedYtsd),...
'LineWidth',3, 'Color', [0.2 0.2 0.2]);
end
set(gca,'XtickLabel',{},'YtickLabel',{});
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
title('PostTests','FontSize',18,'FontWeight','bold');
xlim([0 1])
ylim([0 1])
hold off
makepretty
end
end
mice = [994, 1281]
PlotSessionTrajectories_TC(mice)
a{2}
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
if ~isfield(a{imouse}.behavResources, "CleanAlignedXtsd") && isfield(a{imouse}.behavResources, "AlignedXtsd")
if ~isfield(a{imouse}.behavResources, "AlignedXtsd")
disp("No clean or aligned Xtsd found")
end
for j = 1:numel(a{imouse}.behavResources)
a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).AlignedXtsd;
a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).AlignedYtsd;
end
end
end
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M1281_MFB/behavResources.mat')
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M1281_MFB/behavResources.mat', nain)
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M1281_MFB/behavResources.mat', "nain")
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M1281_MFB/behavResources.mat')
%% Get data
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
if ~isfield(a{imouse}.behavResources, "CleanAlignedXtsd") && isfield(a{imouse}.behavResources, "AlignedXtsd")
if ~isfield(a{imouse}.behavResources, "AlignedXtsd")
disp("No clean or aligned Xtsd found")
end
for j = 1:numel(a{imouse}.behavResources)
a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).AlignedXtsd;
a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).AlignedYtsd;
end
end
end
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
a = cell(length(Dir.path),1);
for imouse = 1:length(Dir.path)
if strcmp(Dir.name{imouse}, 'Mouse905')
a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
else
a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
end
if ~isfield(a{imouse}.behavResources, "CleanAlignedXtsd") && isfield(a{imouse}.behavResources, "AlignedXtsd") && 1 == 0
if ~isfield(a{imouse}.behavResources, "AlignedXtsd")
disp("No clean or aligned Xtsd found")
end
for j = 1:numel(a{imouse}.behavResources)
a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).AlignedXtsd;
a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).AlignedYtsd;
end
end
end
clear all
load('/home/mickey/Documents/Theotime/DimaERC2/neuroencoders_1021/_work/M1281_MFB/behavResources.mat')
behavResources = rmfield(behavResources, {'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned', 'CleanLinearDist'});
behavResources = rmfield(behavResources, {'CleanPosMat', 'CleanPosMatInit', 'CleanXtsd', 'CleanYtsd', 'CleanVtsd', 'CleanZoneIndices', 'CleanZoneEpoch'});
behavResources = rmfield(behavResources, 'CleanMaskBounary');
clear all
mice = [994 1281]
PlotSessionTrajectories_TC(mice)
q
edit PlotSessionTrajectories
Trajectories_Stims_Learning_Maze_BM
edit Trajectories_Stims_Learning_Maze_BM
%-- 09/12/2024 16:20:46 --%
ERC
clear all
lookup ERC
lookup ERC*
locate ERC
ERC2_OccupancyMapsExamples_SL
BehaviorERC_example
dir_out = '/home/mickey/download/test';
fig_out1 = 'MeanOccupancyMap2';
fig_out2 = 'Example';
sav = 1;
Mice_to_analyze = [994 1239];
ExampleMouse = 994;
SessNames={'TestPre' 'TestPost' };
XLinPos = [0:0.05:1];
Dir = PathForExperiments_TC('Sub');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
DirExample{ss} = RestrictPathForExperiment_TC(Dir,'nMice', ExampleMouse);
for i = 1:length(Dir.path)
a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end
edit ERC2_OccupancyMapsExamples_DB.m
dir_out = '/home/mickey/download/test';
fig_out1 = 'MeanOccupancyMap2';
fig_out2 = 'Example';
sav = 1;
% Numbers of mice to run analysis on
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];
Mice_to_analyze = [994 1239];
SessNames={'TestPre' 'TestPost' };
XLinPos = [0:0.05:1];
Dir = PathForExperiments_TC('Sub');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
for i = 1:length(Dir.path)
a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end
%% Find indices of PreTests and PostTest and Cond session in the structure
id_Pre = cell(1,length(a));
id_Post = cell(1,length(a));
for i=1:length(a)
for i=1:length(a)
id_Pre{i} = zeros(1,length(a{i}.behavResources));
id_Post{i} = zeros(1,length(a{i}.behavResources));
for k=1:length(a{i}.behavResources)
if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPre'))
id_Pre{i}(k) = 1;
end
if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPost'))
id_Post{i}(k) = 1;
end
end
id_Pre{i}=find(id_Pre{i});
id_Post{i}=find(id_Post{i});
end
end
ERC_OccupancyMaps_TC
%ER2_OccupancyMapsExamples - Plot basic behavior comparisons of ERC experiment avergaed across mice.
%
% Plot occupance in the shock zone in the PreTests vs PostTests
% Plot number of entries in the shock zone in the PreTests vs PostTests
% Plot time to enter in the shock zone in the PreTests vs PostTests
% Plot average speed in the shock zone in the PreTests vs PostTests
%
%
%  OUTPUT
%
%    Figure
%
%       See
%
%       QuickCheckBehaviorERC, PathForExperimentERC_Dima, BehaviorERC
%
%       2018 by Dmitri Bryzgalov
%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mickey/download/test';
fig_out1 = 'MeanOccupancyMap2';
fig_out2 = 'Example';
sav = 1;
% Numbers of mice to run analysis on
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];
Mice_to_analyze = [994 1239];
SessNames={'TestPre' 'TestPost' };
XLinPos = [0:0.05:1];
Dir = PathForExperiments_TC('Sub');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
for i = 1:length(Dir.path)
a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end
%% Find indices of PreTests and PostTest and Cond session in the structure
id_Pre = cell(1,length(a));
id_Post = cell(1,length(a));
for i=1:length(a)
for i=1:length(a)
id_Pre{i} = zeros(1,length(a{i}.behavResources));
id_Post{i} = zeros(1,length(a{i}.behavResources));
for k=1:length(a{i}.behavResources)
if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPre'))
id_Pre{i}(k) = 1;
end
if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPost'))
id_Post{i}(k) = 1;
end
end
id_Pre{i}=find(id_Pre{i});
id_Post{i}=find(id_Post{i});
end
end
for ss = 1 : length(SessNames)
% Initialize
Files.(SessNames{ss}) = cell(1,length(Dir.path));
OccupMap.(SessNames{ss}) = zeros(101,101);
FreezeTime.(SessNames{ss}) = [];
LinPos.(SessNames{ss}) = [];
ZoneTimeTest.(SessNames{ss}) = [];
ZoneTimeTestTot.(SessNames{ss}) = [];
SpeedDistrib.(SessNames{ss}) = [];
ZoneNumTest.(SessNames{ss}) = [];
FirstZoneTimeTest.(SessNames{ss}) = [];
for mm = 1:length(Dir.path)
cd(Dir.path{mm}{1})
load('behavResources.mat','Vtsd','AlignedXtsd','AlignedYtsd','ZoneEpochAligned','LinearDist');
load('ExpeInfo.mat')
TotalEpoch = intervalSet(0,max(Range(Vtsd)));
% occupation map
[OccupMap_temp,xx,yy] = hist2d(Data(AlignedXtsd),Data(AlignedYtsd),[0:0.01:1],[0:0.01:1]);
OccupMap_temp = OccupMap_temp/sum(OccupMap_temp(:));
OccupMap.(SessNames{ss}) = OccupMap.(SessNames{ss}) + OccupMap_temp;
%         % speed
%         [YSp,XSp] = hist(log(Data(Restrict(Vtsd,TotalEpoch-FreezeAccEpoch))),[-15:0.1:1]);
%         YSp = YSp/sum(YSp);
%         SpeedDistrib.(SessNames{ss})= [SpeedDistrib;YSp];
% time in different zones
for k=1:5
% mean episode duration
ZoneTime(k)=nanmean(Stop(ZoneEpochAligned{k},'s')-Start(ZoneEpochAligned{k},'s'));
% total duration
ZoneTimeTot(k)=nansum(Stop(ZoneEpochAligned{k},'s')-Start(ZoneEpochAligned{k},'s'));
% number of visits
RealVisit = dropShortIntervals(ZoneEpochAligned{k},1*1e4);
ZoneEntr(k)=length(Stop(RealVisit,'s')-Start(RealVisit,'s'));
% time to first entrance
if not(isempty(Start(RealVisit)))
FirstZoneTime(k) =min(Start(RealVisit,'s'));
else
FirstZoneTime(k) =200;
end
end
ZoneTimeTest.(SessNames{ss}) = [ZoneTimeTest.(SessNames{ss});ZoneTime];
ZoneTimeTestTot.(SessNames{ss}) = [ZoneTimeTestTot.(SessNames{ss});ZoneTimeTot];
ZoneNumTest.(SessNames{ss}) = [ZoneNumTest.(SessNames{ss});ZoneEntr];
FirstZoneTimeTest.(SessNames{ss}) = [FirstZoneTimeTest.(SessNames{ss});FirstZoneTime];
%         % freezing time in different zones
%         for k=1:5
%             ZoneTime(k)=sum(Stop(and(Behav.FreezeAccEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeAccEpoch),'s'));
%         end
%         FreezeTime.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
%             [FreezeTime.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};ZoneTime];
%
% Linear Position
[YPos,XPos] = hist(Data(LinearDist),XLinPos);
YPos = YPos/sum(YPos);
LinPos.(SessNames{ss}) = [LinPos.(SessNames{ss});YPos];
end
end
%% Plot occupancy
fh = figure('units', 'normalized', 'outerposition', [0 0 0.85 0.65]);
maze = [0.04 0.05; 0.35 0.05; 0.35 0.8; 0.65 0.8; 0.65 0.05; 0.95 0.05; 0.95 0.97; 0.04 0.97; 0.04 0.05];
xmaze = maze(:,1)*101;
ymaze = maze(:,2)*101;
BW = poly2mask(xmaze, ymaze, 101,101);
BW = double(BW);
BW(find(BW==0))=Inf;
for ss = 1 : length(SessNames)
subplot(1,2,ss)
toplot = (log(OccupMap.(SessNames{ss}))/sum(sum(OccupMap.(SessNames{ss}))))';
imagesc(yy,xx,toplot.*BW)
%     imagesc(yy,xx,toplot)
colormap hot
%     colormap(inferno)
axis xy
set(gca,'XTick',[],'YTick',[])
caxis([-1.3 -0.4])
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',5)
if ss == 1
title('Pre', 'FontWeight','bold','FontSize',18)
elseif ss == 2
title('Post', 'FontWeight','bold','FontSize',18)
end
end
%% Save it
if sav
saveas(gcf, [dir_out fig_out1 '.fig']);
saveFigure(gcf,fig_out1,dir_out);
end
%
% %% Plot example
% fh2 = figure('units', 'normalized', 'outerposition', [0 0 0.85 0.65]);
% maze = [0.04 0.05; 0.35 0.05; 0.35 0.8; 0.65 0.8; 0.65 0.05; 0.95 0.05; 0.95 0.97; 0.04 0.97; 0.04 0.05;];
% xmaze = maze(:,1)*101;
% ymaze = maze(:,2)*101;
%
% BW = poly2mask(xmaze, ymaze, 101,101);
% BW = double(BW);
% BW(find(BW==0))=Inf;
%
% for ss = 1 : length(SessNames)
%
%     subplot(1,2,ss)
%     plot(Data(CoordinatesExample{ss}.AlignedXtsd),Data(CoordinatesExample{ss}.AlignedYtsd));
% %     imagesc(yy,xx,toplot)
%     axis xy
%     set(gca,'XTick',[],'YTick',[])
% %     caxis([-1.6 -0.8])
%     hold on
%     plot(maze(:,1),maze(:,2),'k','LineWidth',5)
%     if ss == 1
%         title('Pre', 'FontWeight','bold','FontSize',18)
%     elseif ss == 2
%         title('Post', 'FontWeight','bold','FontSize',18)
%     end
% end
%
%% Save it
% if sav
%     saveas(fh2, [dir_out fig_out2 '.fig']);
%     saveFigure(fh2,fig_out2,dir_out);
% end
%% Clear variables
clear
%ER2_OccupancyMapsExamples - Plot basic behavior comparisons of ERC experiment avergaed across mice.
%
% Plot occupance in the shock zone in the PreTests vs PostTests
% Plot number of entries in the shock zone in the PreTests vs PostTests
% Plot time to enter in the shock zone in the PreTests vs PostTests
% Plot average speed in the shock zone in the PreTests vs PostTests
%
%
%  OUTPUT
%
%    Figure
%
%       See
%
%       QuickCheckBehaviorERC, PathForExperimentERC_Dima, BehaviorERC
%
%       2018 by Dmitri Bryzgalov
%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
fig_out1 = 'MeanOccupancyMap2';
sav = 0;
ntrial = 4;
SessNames = {'TestPre', 'TestPost', 'Cond'};
% Numbers of mice to run analysis on
Mice_to_analyze = 994;
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912 994];
XLinPos = [0:0.05:1];
% Get paths
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
% Initialize
for ss = 1:length(SessNames)
Files.(SessNames{ss}) = cell(1,length(Dir.path));
OccupMap.(SessNames{ss}) = zeros(101,101);
FreezeTime.(SessNames{ss}) = [];
LinPos.(SessNames{ss}) = [];
ZoneTimeTest.(SessNames{ss}) = [];
ZoneTimeTestTot.(SessNames{ss}) = [];
SpeedDistrib.(SessNames{ss}) = [];
ZoneNumTest.(SessNames{ss}) = [];
FirstZoneTimeTest.(SessNames{ss}) = [];
for mm = 1:length(Dir.path)
cd(Dir.path{mm}{1})
load('behavResources.mat','CleanVtsd','CleanAlignedXtsd','CleanAlignedYtsd','ZoneEpochAligned','CleanLinearDist');
load('behavResources.mat','SessionEpoch');
load('ExpeInfo.mat')
TotalEpoch = intervalSet(0,max(Range(CleanVtsd)));
for i=1:ntrial-1
if i == 1
eval(['DoEpoch = or(SessionEpoch.' SessNames{ss} '1,SessionEpoch.' SessNames{ss} num2str(i+1) ');']);
else
eval(['DoEpoch = or(DoEpoch,SessionEpoch.' SessNames{ss} num2str(i) ');']);
end
end
% occupation map
[OccupMap_temp,xx,yy] = hist2d(Data(Restrict(CleanAlignedXtsd,DoEpoch)),...
Data(Restrict(CleanAlignedYtsd,DoEpoch)),[0:0.01:1],[0:0.01:1]);
OccupMap_temp = OccupMap_temp/sum(OccupMap_temp(:));
OccupMap.(SessNames{ss}) = OccupMap.(SessNames{ss}) + OccupMap_temp;
%         % speed
%         [YSp,XSp] = hist(log(Data(Restrict(Vtsd,TotalEpoch-FreezeAccEpoch))),[-15:0.1:1]);
%         YSp = YSp/sum(YSp);
%         SpeedDistrib.(SessNames{ss})= [SpeedDistrib;YSp];
%
%         % time in different zones
%         for k=1:5
%             % mean episode duration
%             ZoneTime(k)=nanmean(Stop(ZoneEpochAligned{k},'s')-Start(ZoneEpochAligned{k},'s'));
%             % total duration
%             ZoneTimeTot(k)=nansum(Stop(ZoneEpochAligned{k},'s')-Start(ZoneEpochAligned{k},'s'));
%
%             % number of visits
%             RealVisit = dropShortIntervals(ZoneEpochAligned{k},1*1e4);
%             ZoneEntr(k)=length(Stop(RealVisit,'s')-Start(RealVisit,'s'));
%
%             % time to first entrance
%             if not(isempty(Start(RealVisit)))
%                 FirstZoneTime(k) =min(Start(RealVisit,'s'));
%             else
%                 FirstZoneTime(k) =200;
%             end
%         end
%
%         ZoneTimeTest.(SessNames{ss}) = [ZoneTimeTest.(SessNames{ss});ZoneTime];
%         ZoneTimeTestTot.(SessNames{ss}) = [ZoneTimeTestTot.(SessNames{ss});ZoneTimeTot];
%         ZoneNumTest.(SessNames{ss}) = [ZoneNumTest.(SessNames{ss});ZoneEntr];
%         FirstZoneTimeTest.(SessNames{ss}) = [FirstZoneTimeTest.(SessNames{ss});FirstZoneTime];
%         % freezing time in different zones
%         for k=1:5
%             ZoneTime(k)=sum(Stop(and(Behav.FreezeAccEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeAccEpoch),'s'));
%         end
%         FreezeTime.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
%             [FreezeTime.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};ZoneTime];
%
%         % Linear Position
%         [YPos,XPos] = hist(Data(LinearDist),XLinPos);
%         YPos = YPos/sum(YPos);
%         LinPos.(SessNames{ss}) = [LinPos.(SessNames{ss});YPos];
end
end
%% Plot occupancy
fh = figure('units', 'normalized', 'outerposition', [0 0 0.85 0.65]);
maze = [0.04 0.05; 0.35 0.05; 0.35 0.8; 0.65 0.8; 0.65 0.05; 0.95 0.05; 0.95 0.97; 0.04 0.97; 0.04 0.05];
xmaze = maze(:,1)*101;
ymaze = maze(:,2)*101;
BW = poly2mask(xmaze, ymaze, 101,101);
BW = double(BW);
BW(find(BW==0))=Inf;
subplot(1,2,1)
toplot = (log(OccupMap.TestPre)/sum(sum(OccupMap.TestPre)))';
imagesc(yy,xx,toplot.*BW)
%     imagesc(yy,xx,toplot)
colormap hot
%     colormap(inferno)
axis xy
set(gca,'XTick',[],'YTick',[])
% caxis([-1 -0.3])
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',5)
title('Pre', 'FontWeight','bold','FontSize',18)
subplot(1,2,2)
toplot = (log(OccupMap.TestPost)/sum(sum(OccupMap.TestPost)))';
imagesc(yy,xx,toplot.*BW)
%     imagesc(yy,xx,toplot)
colormap hot
%     colormap(inferno)
axis xy
set(gca,'XTick',[],'YTick',[])
% caxis([-1 -0.3])
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',5)
title('Post', 'FontWeight','bold','FontSize',18)
% Save it
if sav
saveas(gcf, [dir_out fig_out1 '.fig']);
saveFigure(gcf,fig_out1,dir_out);
end
%% Plot cond
fh = figure('units', 'normalized', 'outerposition', [0 0 0.45 0.65]);
maze = [0.04 0.05; 0.35 0.05; 0.35 0.8; 0.65 0.8; 0.65 0.05; 0.95 0.05; 0.95 0.97; 0.04 0.97; 0.04 0.05];
xmaze = maze(:,1)*101;
ymaze = maze(:,2)*101;
BW = poly2mask(xmaze, ymaze, 101,101);
BW = double(BW);
BW(find(BW==0))=Inf;
toplot = (log(OccupMap.Cond)/sum(sum(OccupMap.Cond)))';
imagesc(yy,xx,toplot.*BW)
%     imagesc(yy,xx,toplot)
colormap hot
%     colormap(inferno)
axis xy
set(gca,'XTick',[],'YTick',[])
% caxis([-1 -0.3])
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',5)
title('Cond', 'FontWeight','bold','FontSize',18)
% Save it
if sav
saveas(gcf, [dir_out fig_out1 '_Cond.fig']);
saveFigure(gcf,[fig_out1 '_Cond'],dir_out);
end
%
% %% Plot example
% fh2 = figure('units', 'normalized', 'outerposition', [0 0 0.85 0.65]);
% maze = [0.04 0.05; 0.35 0.05; 0.35 0.8; 0.65 0.8; 0.65 0.05; 0.95 0.05; 0.95 0.97; 0.04 0.97; 0.04 0.05;];
% xmaze = maze(:,1)*101;
% ymaze = maze(:,2)*101;
%
% BW = poly2mask(xmaze, ymaze, 101,101);
% BW = double(BW);
% BW(find(BW==0))=Inf;
%
% for ss = 1 : length(SessNames)
%
%     subplot(1,2,ss)
%     plot(Data(CoordinatesExample{ss}.AlignedXtsd),Data(CoordinatesExample{ss}.AlignedYtsd));
% %     imagesc(yy,xx,toplot)
%     axis xy
%     set(gca,'XTick',[],'YTick',[])
% %     caxis([-1.6 -0.8])
%     hold on
%     plot(maze(:,1),maze(:,2),'k','LineWidth',5)
%     if ss == 1
%         title('Pre', 'FontWeight','bold','FontSize',18)
%     elseif ss == 2
%         title('Post', 'FontWeight','bold','FontSize',18)
%     end
% end
%
%% Save it
% if sav
%     saveas(fh2, [dir_out fig_out2 '.fig']);
%     saveFigure(fh2,fig_out2,dir_out);
% end
%% Clear variables
clear
ERC_OccupancyMaps_TC_bis
PlotSessionTrajectories_TC
mice = 994
PlotSessionTrajectories_TC
PlotSessionTrajectories_TC(994)
figure, plot(Data(AlignedXtsd), Data(AlignedYtsd),'ko')
figure, plot(Data(AlignedXtsd), Data(AlignedYtsd),'k.-')
load('behavResources.mat', 'SessionEpoch')
figure, plot(Data(Restrict(AlignedXtsd,Cond1)), Data(Restrict(AlignedXtsd,Cond1)),'k.-')
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)),'k.-')
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
load('behavResources.mat', 'StimEpoch')
stim=ts(Start(StimEpoch));
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfaceoclor,'r')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond1)),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
close all
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1])
ylim([0 1])
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Range(Restrict(AlignedXtsd,Restrict(stim,Cond)),'s'),Data(Restrict(AlignedXtsd,Restrict(stim,Cond))),'k.-'),
figure, plot(Range(Restrict(AlignedXtsd,Cond),'s'), Data(Restrict(AlignedYtsd,Cond)),'k.-')
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r')
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, hold on, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'), scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
caxis
caxis([0 30])
caxis([0 15])
caxis([5 15])
caxis([5 6])
caxis([5
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
6])
igure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
>
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
caxis([0 30])
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
TestPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
figure, plot(Data(Restrict(AlignedXtsd,TestPost)), Data(Restrict(AlignedYtsd,TestPost)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Hab)), Data(Restrict(AlignedYtsd,SessionEpoch.Hab)),'k.-')
%-- 09/12/2024 18:56:25 --%
%%
addpath(genpath('/home/mobs/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('/home/mobs/Dropbox/Kteam/Fra'))
addpath(genpath('/home/mobs/Dropbox/Kteam/PrgMatlab'))
addpath('/home/mobs/Dropbox/Kteam/PrgMatlab')
%%
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
% load LFPData/LFP14
addpath(genpath('~/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('~/Dropbox/Kteam/Fra'))
addpath(genpath('~/Dropbox/Kteam/PrgMatlab'))
addpath('~/Dropbox/Kteam/PrgMatlab')
%%
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
figure, plot(Data(Restrict(AlignedXtsd,Cond1)), Data(Restrict(AlignedXtsd,Cond1)),'k.-'
commandhistory
clear all
load('behavResources.mat')
karim0912
figure, plot(Data(AlignedXtsd), Data(AlignedYtsd),'ko')
%-- 09/12/2024 19:16:28 --%
load('behavResources.mat')
karim0912
figure, plot(Data(AlignedXtsd), Data(AlignedYtsd),'ko')
figure, plot(Data(AlignedXtsd), Data(AlignedYtsd),'k.-')
load('behavResources.mat', 'SessionEpoch')
figure, plot(Data(Restrict(AlignedXtsd,Cond1)), Data(Restrict(AlignedXtsd,Cond1)),'k.-')
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)),'k.-')
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
load('behavResources.mat', 'StimEpoch')
stim=ts(Start(StimEpoch));
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond1)),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
close all
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
stim=ts(Start(StimEpoch));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
%figure, plot
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
close all
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1])
ylim([0 1])
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Range(Restrict(AlignedXtsd,Restrict(stim,Cond)),'s'),Data(Restrict(AlignedXtsd,Restrict(stim,Cond))),'k.-'),
figure, plot(Range(Restrict(AlignedXtsd,Cond),'s'), Data(Restrict(AlignedYtsd,Cond)),'k.-')
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r')
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, hold on, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'), scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
caxis
caxis([0 30])
caxis([0 15])
caxis([5 15])
caxis([5 6])
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
stim=ts(Start(StimEpoch));
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
caxis([0 30])
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
TestPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
figure, plot(Data(Restrict(AlignedXtsd,TestPost)), Data(Restrict(AlignedYtsd,TestPost)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Hab)), Data(Restrict(AlignedYtsd,SessionEpoch.Hab)),'k.-')
TestPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
figure, plot(Data(Restrict(AlignedXtsd,TestPost)), Data(Restrict(AlignedYtsd,TestPost)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
%-- 09/12/2024 19:37:14 --%
load('behavResources.mat')
load('nnBehavior.mat')
load('SpikeData.mat')
figure, RasterPlot(S)
run('/home/mickey/Dropbox/Kteam/PrgMatlab/BasileToulemonde/BasileStufff.m')
edit('/home/mickey/Dropbox/Kteam/PrgMatlab/BasileToulemonde/BasileStufff.m')
%%
addpath(genpath('~/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('~/Dropbox/Kteam/Fra'))
addpath(genpath('~/Dropbox/Kteam/PrgMatlab'))
addpath('~/Dropbox/Kteam/PrgMatlab')
%%
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
% load LFPData/LFP14
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
clear
close all
BasileStufff
clear
BasileStufff
clear
BasileStufff
hwhich -all readtable
which -all readtable
uiopen('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featurePred.csv',1)
help csvread
help readtable
testcsv=uiopen('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featurePred.csv',1);
edit csvread
m = csvread('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featurePred.csv');
size(m)
figure, plot(m(:,1),m(:,2))
figure, plot(m(:,1),m(:,3))
figure, plot(m(:,2),m(:,3))
m = csvread('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
size(predi)
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
k=80;
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);
edit mETAverage
[m,s,tps]=mETAverage(e,t,v,binsize,nbBins);
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
%%%%%%%%subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
%-- 10/12/2024 12:17:47 --%
commandhistory
edit commandhistory
%-- 12/12/2024 15:31:16 --%
%%
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
% load LFPData/LFP14
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
clear
close all
BasileStufff
clear
BasileStufff
clear
BasileStufff
hwhich -all readtable
which -all readtable
uiopen('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featurePred.csv',1)
help csvread
help readtable
testcsv=uiopen('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv',1);
edit csvread
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
size(m)
figure, plot(m(:,1),m(:,2))
figure, plot(m(:,1),m(:,3))
figure, plot(m(:,2),m(:,3))
m = csvread('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
size(predi)
figure, plot(m(:,2),m(:,3))
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
size(predi)
figure, hist(predi(:,2),
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
size(predi)
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
k=80;
[map,mapS
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
k=80;
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);
edit mETAverage
%-- 12/12/2024 16:01:59 --%
edit startup.m
which startup
e startup.m
edit startup.m
username="mickey";
res=pwd;
cd(strcat('/home/',username,'/Dropbox/Kteam'))
addpath(genpath(strcat('/home/',username,'/Dropbox/Kteam/PrgMatlab')))
addpath(genpath(strcat('/home/',username,'/Dropbox/Kteam/PrgMatlab/MatFilesMarie')))
eval(['cd(''',res,''')'])
clear res
clear username
cmap = colormap('jet');
set(groot,'DefaultFigureColorMap',cmap);
close all
clear cmap
%-- 12/12/2024 16:05:44 --%
locate path
find path
find naindejardin
username="mickey";
res=pwd;
cd(strcat('/home/',username,'/Dropbox/Kteam'))
genpath(strcat('/home/',username,'/Dropbox/Kteam/PrgMatlab'))
test = genpath(strcat('/home/',username,'/Dropbox/Kteam/PrgMatlab'))
test
addpath(test)
edit BasileStufff.m
which -all readtable
%-- 12/12/2024 17:06:14 --%
testcsv=uiopen('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv',1);
edit csvread
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
size(m)
figure, plot(m(:,1),m(:,2))
figure, plot(m(:,1),m(:,3))
figure, plot(m(:,2),m(:,3))
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
testcsv=uiopen('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv',1);
testcsv=uiopen('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
size(m)
figure, plot(m(:,1),m(:,2))
figure, plot(m(:,1),m(:,3))
figure, plot(m(:,2),m(:,3))
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
size(predi)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
k=80;
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
cd('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/')
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
cd('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/')
load behavResources.mat
load SpikeData.mat
load SWR
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
k=80;
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
k
k=80;
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);
edit mETAverage
[m,s,tps]=mETAverage(e,t,v,binsize,nbBins);
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure,
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure,
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
%%%%%%%%subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
load('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/LFPData/LFP14.mat')
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
%%%%%%%%subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
%-- 10/12/2024 12:17:47 --%
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
%%%%%%%%subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
tsd
Data(LFP)
LFP
load('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/LFPData/InfoLFP.mat')
figure, RasterPlot(S)
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
% figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
%%%%%%%%subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])
csvLinearPred = readtable('/media/mickey/DimaERC2/M119TEST1_Basile/TEST/results/200/linearPred.csv');
idxLinearPred = csvLinearPred{2:end,1};
LinearPred=csvLinearPred{2:end,2};
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
mice = [1199]
Dir = PathForExperiments_TC("Sub");
Dir
Dir = RestrictPathForExperiment_TC(Dir,'nMice', mice);
Dir
%%
mice = 1199
Dir = PathForExperiments_TC("Sub")
Dir = RestrictPathForExperiment_TC(Dir, "nMice", mice)
%%
mice = 1199;
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir, "nMice", mice);
Dir = RestrictPathForExperiment_TC(Dir, 'nMice', mice);
csvLinearPred = readtable(Dir.path{1}{1} + '/TEST/results/200/linearPred.csv');
csvLinearPred = readtable([ Dir.path{1}{1} + '/TEST/results/200/linearPred.csv']);
csvLinearPred = readtable([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
[ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']
csvTimeStepsPred = readtable('/media/mickey/DimaERC2/M1199TEST1_Basile/TEST/results/200/timeStepsPred.csv');
csvTimeStepsPred = readtable('/media/mickey/DataMOBs210/DimaERC2/M1199TEST1_Basile/TEST/results/200/timeStepsPred.csv');
csvTimeStepsPred = readtable('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/timeStepsPred.csv');
csvTimeStepsPred = readtable("/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/timeStepsPred.csv");
tlab.io.internal.functions.FunctionStore.getFunctionByName("readtable");
matlab.io.internal.functions.FunctionStore.getFunctionByName("readtable");
csvTimeStepsPred = readtable("/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/timeStepsPred.csv")
readtable("/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/timeStepsPred.csv")
which readtable
figure, plot(predi(:,1),predi(:,2))
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
clear figs
clear fig
clear allfig
clear allfigs
close all
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPost),Restrict(X,testPost),Restrict(Y,testPost));
testPre
testPost
tot
k
Restrict(Stsd{k},testPost)
Restrict(X,testPost)
Restrict(Y,testPost)
PlaceField(Restrict(Stsd{k},testPost),Restrict(X,testPost),Restrict(Y,testPost));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPost),Restrict(X,testPost),Restrict(Y,testPost));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
plot(Data(Restrict(X,testPost)), Data(Restrict(Y,testPost)))
figure; plot(Data(Restrict(X,testPost)), Data(Restrict(Y,testPost)))
figure; plot(Data(Restrict(X,testPre)), Data(Restrict(Y,testPre)))
figure; plot(Data(Restrict(X,cond)), Data(Restrict(Y,cond)))
stim
stim=ts(Start(StimEpoch));
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
map
PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
PlaceField(Restrict(Stsd{k},and(testPost,SpeedEpoch)),Restrict(X,and(testPost,SpeedEpoch)),Restrict(Y,and(testPost,SpeedEpoch)));
tot
PlaceField(Restrict(Stsd{k},and(tot,SpeedEpoch)),Restrict(X,and(tot,SpeedEpoch)),Restrict(Y,and(tot,SpeedEpoch)));
predi
predi{1}
predi{1;}
predi[1]
predi
predi{1,1}
mice = 1199;
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir, 'nMice', mice);
csvLinearPred = readtable([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred{2:end,1};
LinearPred=csvLinearPred{2:end,2};
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = readtable(Dir.path{1}{1}  'TEST/results/200/timeStepsPred.csv');
idxTimeStepsPred = csvTimeStepsPred{2:end,1};
TimeStepsPred = csvTimeStepsPred{2:end,2};
[ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']
readcsv([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv'])
readDecoding([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv'])
edit readDecoding
csvLinearPred = csvread([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred{2:end,1};
idxLinearPred = csvLinearPred(2:end,1);
idxLinearPred = csvLinearPred(2:end,1);
LinearPred=csvLinearPred(2:end,2);
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = csvread(Dir.path{1}{1}  'TEST/results/200/timeStepsPred.csv');
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
csvTimeStepsPred = csvread(Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv');
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
csvTimeStepsPred = csvread([Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv']);
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
TimeStepsPred = csvTimeStepsPred{2:end,2};
TimeStepsPred = csvTimeStepsPre(2:end,2);
pwd
cd('~/download')
csvLinearPred = csvread([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred(2:end,1);
LinearPred=csvLinearPred(2:end,2);
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = csvread([Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv']);
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
TimeStepsPred = csvTimeStepsPre(2:end,2);
save('timeStepsPred.mat', 'idxTimeStepsPred', 'TimeStepsPred')
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
idxTimeStepsPred
csvTimeStepsPred
csvTimeStepsPred(1,2)
csvTimeStepsPred(10,2)
csvTimeStepsPred(10:end,2)
csvTimeStepsPred(2:end,2)
TimeStepsPred = csvTimeStepsPre(2:end,2);
TimeStepsPred = csvTimeStepsPre{2:end,2};
BasileStufff
TimeStepsPred = csvTimeStepsPre{2:end,2};
mice = 1199;
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir, 'nMice', mice);
csvLinearPred = csvread([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred(2:end,1);
LinearPred=csvLinearPred(2:end,2);
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = csvread([Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv']);
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
TimeStepsPred = csvTimeStepsPred{2:end,2};
save('timeStepsPred.mat', 'idxTimeStepsPred', 'TimeStepsPred')
TimeStepsPred = csvTimeStepsPred(2:end,2);
save('timeStepsPred.mat', 'idxTimeStepsPred', 'TimeStepsPred')
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST1_Basile/TEST/results/200/linearTrue.csv');
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST1_Basile/TEST/results/200/linearTrue.csv']);
Dir
Dir.path
Dir.path{1}{1}
csvLossPred = readtable([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
csvLossPred = csvread([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
idxLossPred = csvLossPred{2:end,1};
idxLossPred = csvLossPred(2:end,1);
LossPred=csvLossPred(2:end,2);
save('lossPred.mat', 'idxLossPred', 'LossPred')
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
idxLinearTrue = csvLinearTrue(2:end,1);
LinearTrue=csvLinearTrue(2:end,2);
save('linearTrue.mat', 'idxLinearTrue', 'LinearTrue')
csvLinearPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/linearPred.csv']);
clear all
%BasileStufff
%%
addpath(genpath('~/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('~/Dropbox/Kteam/Fra'))
addpath(genpath('~/Dropbox/Kteam/PrgMatlab'))
addpath('~/Dropbox/Kteam/PrgMatlab')
%%
% cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
% load LFPData/LFP14
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
load LFPData/LFP14
cd('~/download/')
%%
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
mice = 1199;
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir, 'nMice', mice);
csvLinearPred = csvread([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred(2:end,1);
LinearPred=csvLinearPred(2:end,2);
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = csvread([Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv']);
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
TimeStepsPred = csvTimeStepsPred(2:end,2);
save('timeStepsPred.mat', 'idxTimeStepsPred', 'TimeStepsPred')
svLossPred = csvread([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
idxLossPred = csvLossPred(2:end,1);
LossPred=csvLossPred(2:end,2);
save('lossPred.mat', 'idxLossPred', 'LossPred')
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
idxLinearTrue = csvLinearTrue(2:end,1);
LinearTrue=csvLinearTrue(2:end,2);
save('linearTrue.mat', 'idxLinearTrue', 'LinearTrue')
csvLossPred = csvread([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
idxLossPred = csvLossPred(2:end,1);
LossPred=csvLossPred(2:end,2);
save('lossPred.mat', 'idxLossPred', 'LossPred')
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
idxLinearTrue = csvLinearTrue(2:end,1);
LinearTrue=csvLinearTrue(2:end,2);
save('linearTrue.mat', 'idxLinearTrue', 'LinearTrue')
csvLossPred = csvread([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
idxLossPred = csvLossPred(2:end,1);
LossPred=csvLossPred(2:end,2);
save('lossPred.mat', 'idxLossPred', 'LossPred')
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
idxLinearTrue = csvLinearTrue(2:end,1);
LinearTrue=csvLinearTrue(2:end,2);
save('linearTrue.mat', 'idxLinearTrue', 'LinearTrue')
clear all
BasileStufff
idxLinearPredSleep = csvLinearPredSleep(2:end,1);
BasileStufff
csvTimeStepsPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/timeStepsPred.csv']);
idxTimeStepsPredSleep = csvTimeStepsPredSleep(2:end,1);
TimeStepsPredSleep = csvTimeStepsPredSleep(2:end,2);
save('timeStepsPredSleep.mat', 'idxTimeStepsPredSleep', 'TimeStepsPredSleep')
%BasileStufff
%%
addpath(genpath('~/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('~/Dropbox/Kteam/Fra'))
addpath(genpath('~/Dropbox/Kteam/PrgMatlab'))
addpath('~/Dropbox/Kteam/PrgMatlab')
%%
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
load LFPData/LFP14
cd('~/download/')
%%
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
%%
mice = 1199;
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir, 'nMice', mice);
csvLinearPred = csvread([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred(2:end,1);
LinearPred=csvLinearPred(2:end,2);
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = csvread([Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv']);
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
TimeStepsPred = csvTimeStepsPred(2:end,2);
save('timeStepsPred.mat', 'idxTimeStepsPred', 'TimeStepsPred')
csvLossPred = csvread([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
idxLossPred = csvLossPred(2:end,1);
LossPred=csvLossPred(2:end,2);
save('lossPred.mat', 'idxLossPred', 'LossPred')
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
idxLinearTrue = csvLinearTrue(2:end,1);
LinearTrue=csvLinearTrue(2:end,2);
save('linearTrue.mat', 'idxLinearTrue', 'LinearTrue')
%importing decoded position during sleep
csvLinearPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/linearPred.csv']);
idxLinearPredSleep = csvLinearPredSleep(2:end,1);
LinearPredSleep=csvLinearPredSleep(2:end,2);
save('linearPredSleep.mat', 'idxLinearPredSleep', 'LinearPredSleep')
csvTimeStepsPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/timeStepsPred.csv']);
idxTimeStepsPredSleep = csvTimeStepsPredSleep(2:end,1);
TimeStepsPredSleep = csvTimeStepsPredSleep(2:end,2);
save('timeStepsPredSleep.mat', 'idxTimeStepsPredSleep', 'TimeStepsPredSleep')
clear all
BasileStufff
idxLinearPred
idxLinearPred(0)
idxLinearPred(1)
idxLinearPred(2)
shape(idxLinearPred)
size(idxLinearPred)
idxLinearPredSleep
size(idxLinearPredSleep)
idxLinearPredSleep(0)
idxLinearPredSleep(1)
postSleep
Data(postSleep)
idxLinearPredtot = [idxLinearPred; idxLinearPredSleep];
idxLinearPredSleep
nain = idxLinearPredSleep + idxLinearPred
nain = idxLinearPredSleep + idxLinearPred(end)
nain
size(nain)
nain(1)
idxTimeStepsPredtot = [idxTimeStepsPred;idxTimeStepsPredSleep];
TimeStepsPredtot = [TimeStepsPred;TimeStepsPredSleep];
TimeStepsPred
TimeStepsPredtot
size(TimeStepsPredtot)
figure; plot(TimeStepsPredtot)
figure; plot(TimeStepsPred)
figure; plot(csvTimeStepsPred)
figure; plot(csvTimeStepsPred(:,1), csvTimeStepsPred(:,2))
figure; plot(csvTimeStepsPredSleep(:,1), csvTimeStepsPredSleep(:,2))
figure; plot(csvTimeStepsPred(:,1), csvTimeStepsPred(:,2))
idxLinearPredtot = [idxLinearPred; idxLinearPredSleep];
LinearPredtot=[LinearPred;LinearPredSleep];
save('linearPredtot.mat', 'idxLinearPredtot', 'LinearPredtot')
idxTimeStepsPredtot = [idxTimeStepsPred;idxTimeStepsPredSleep];
TimeStepsPredtot = [TimeStepsPred;TimeStepsPredSleep];
save('timeStepsPredtot.mat', 'idxTimeStepsPredtot', 'TimeStepsPredtot')
k=80;
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),30,Data(Restrict(V,Restrict(Y,testPre))),'filled')
disp('pause')
figure, RasterPlot(Restrict(Stsd,testPost))
disp('pause')
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),130,Data(Restrict(V,Restrict(Y,testPre))),'filled')
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),300,Data(Restrict(V,Restrict(Y,testPre))),'filled')
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),3,Data(Restrict(V,Restrict(Y,testPre))),'filled')
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),3,Data(Restrict(V,Restrict(Y,testPre))),'filled')
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),30,Data(Restrict(V,Restrict(Y,testPre))),'filled')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPost),Restrict(X,testPost),Restrict(Y,testPost));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},tot),Restrict(X,tot),Restrict(Y,tot));
disp('pause')
k=28
k=k+1
PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
PlaceField(Restrict(Stsd{k},and(tot,SpeedEpoch)),Restrict(X,and(tot,SpeedEpoch)),Restrict(Y,and(tot,SpeedEpoch)));
disp('pause')
k=1;
rg=Range(X,'s');
tend=rg(end)-rg(1);
T=poissonKB((length(Range(Stsd{k}))/(rg(end)-rg(1)))/1,tend)+rg(1);
Ts=tsd(T'*1E4,T'*1E4);
PlaceField(Restrict(Ts,and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
k=1;
k=k+1;
[C,B]=CrossCorr(Range(Stsd{k}),Range(Stsd{k+1}),10,100);
figure, bar(B/1E3,C,1,'k')
C,B]=CrossCorr(Range(Stsd{k}),Range(Stsd{k}),5,100);C(B==0)=0;
figure, bar(B/1E3,C,1,'k')
[C,B]=CrossCorr(Range(Stsd{k}),Range(Stsd{k}),5,100);C(B==0)=0;
figure, bar(B/1E3,C,1,'k')
[C,B]=CrossCorr(Range(Stsd{k+1}),Range(Stsd{k+1}),5,100);C(B==0)=0;
figure, bar(B/1E3,C,1,'k')
k=1;
k=k+1;
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
k=1;
Qs = MakeQfromS(Stsd,500);  % 50ms !!!!!
ratek = Restrict(Qs,intervalSet(ts(1)-30000,ts(end)+3000));
ratek=Qs;
Qs=tsdArray(Qs);
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,k));
ratetotal=tsd(Range(ratek),sum(rate,2));
figure, plot(Data(ratetotal))
k=1;
Qs = MakeQfromS(Stsd,500);  % 50ms !!!!!
ratek = Restrict(Qs,intervalSet(ts(1)-30000,ts(end)+3000));
ratek=Qs;
Qs=tsdArray(Qs);
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,k));
k=1;
Qs = MakeQfromS(Stsd,500);  % 50ms !!!!!
ratek = Restrict(Qs,intervalSet(ts(1)-30000,ts(end)+3000));
ts
ts(1)
ts(end)
Data(ts)
Range(ts)
Range(ts(1))
Data(ts(1))
Qs = MakeQfromS(Stsd,500);  % 50ms !!!!!
ratek = Restrict(Qs,intervalSet(Qs(1)-30000,Qs(end)+3000));
ratek=Qs;
Qs=tsdArray(Qs);
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,k));
ratetotal=tsd(Range(ratek),sum(rate,2));
figure, plot(Data(ratetotal))
figure, plot(Qs)
Qs = MakeQfromS(Stsd,500);  % 50ms !!!!!
Data(Qs)
Range(Qsà$
Range(Qs)
ratek = Restrict(Qs,intervalSet(Ts(1)-30000,Ts(end)+3000));
ratek
Ts
Ts(1)
Ts(end)
Ts(1)(1)
Range(Ts(1))
Qs=tsdArray(Qs);
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,k));
ratetotal=tsd(Range(ratek),sum(rate,2));
figure, plot(Data(ratetotal))
%%
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
idx=find(BasicNeuronInfo.neuroclass==1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,idx), ts(sw(1:200)), -1500,+1500,'BinSize',10);
idxI=find(BasicNeuronInfo.neuroclass==-1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,idxI), ts(sw(1:200)), -1500,+1500,'BinSize',10);
BasicNeuronInfo
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
Fil=FilterLFP(LFP,[5 10],1024);
QsTestPre = MakeQfromS(Restrict(Stsd,testPre),5000);  % 50ms !!!!!
rateTestPre = full(Data(QsTestPre));
figure, imagesc(zscore(rateTestPre)'), caxis([-5 5])
cd('~/download')
% C=cov(zscore(rateTestPre));
% [V,L]=pcacov(C);
% [BE,id]=sort(V(:,1));     % neurons indexed according to covariance
% id = [75,80,49,15,11,63,6,51,90,58,3,74,62,77,14,72,82] %  neurons indexed in order to see the theta sequences
% TODO :- put some
% indexes twice and
% see if it works
%       - Take only
%       a few to
%       see it
%       better
C=cov(zscore(rateTestPre));
figure; plot(C)
figure; plotcov(C)
C
size(C)
imagesc(C)
[V,L]=pcacov(C
[V,L]=pcacov(C)
[BE,id]=sort(V(:,1))
id = [60,37];
figure, imagesc(C(id,id)-diag(diag(C)))
C(id,id)
diag(C)
figure, imagesc(id,id)
figure, imagesc(C(id,id))
figure, RasterPlotid(Restrict(Stsd,testPre), id)
figure,
subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0)
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))
subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
figure,
subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
LossPredTsd=tsd(TimeStepsPred*1E4,LossPred);
LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);
LinearPredSleepTsd=tsd(TimeStepsPredSleep*1E4,LinearPredSleep);
BadEpoch=thresholdIntervals(LossPredTsd,-3,'Direction','Above');
GoodEpoch=thresholdIntervals(LossPredTsd,-5,'Direction','Below');
stim=ts(Start(StimEpoch));
figure,
subplot(3,1,1), hold on,
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')
subplot(3,1,2), hold on,
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
%plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')
subplot(3,1,3), hold on,
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
%plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),500);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),500);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),50);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),50);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),100);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),100);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),70);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),70);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
k=80;
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
V=Vtsd;
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
k=80;
PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
id=[80,44,49,58,60,62]; % indexes of the cells for which we want to see the spikes
figure,
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,testPre),id,0);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, testPre),'s'), Data(Restrict(LinearTrueTsd, testPre)),'r')
plot(Range(Restrict(LinearPredTsd,testPre),'s'),Data(Restrict(LinearPredTsd,testPre)),'b');
a=TimeStepsPred36(1);
l=10; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')
figure,
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,testPre),id,0);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, testPre),'s'), Data(Restrict(LinearTrueTsd, testPre)),'r')
plot(Range(Restrict(LinearPredTsd,testPre),'s'),Data(Restrict(LinearPredTsd,testPre)),'b');
a=TimeStepsPred(1);
l=10; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')
idx_shockZone_testPre = [44,62];
idx_shockZone_cond = [62]; % la PC62 garde une firing map axée sur la shock zone mais elle fire aussi à d'autres endroits
LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
condTime = Range(Restrict(LinearTrueTsd,cond),'s') %Time interval of the conditioning (for a)
LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
condTime = Range(Restrict(LinearTrueTsd,cond),'s'); %Time interval of the conditioning (for a)
figure,
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,cond),idx_shockZone_testPre,0);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, cond),'s'), Data(Restrict(LinearTrueTsd, cond)),'r')
plot(Range(Restrict(LinearPredTsd,cond),'s'),Data(Restrict(LinearPredTsd,cond)),'b');
hold on, plot(Range(tRipples,'sec'), 0.9,'r*') % We also plot the ripples because reactivations occur during ripples
subplot(5,1,5), ylim([0 1])
a=condTime(1);
l=10; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')
id = [60,37];
figure,
subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0)
subplot(5,1,4), plot(TimeStepsPredSleep, LinearPredSleep)
subplot(5,1,5), plot(Range(Restrict(LFP, sleep),'sec'), Data(Restrict(LFP, sleep)),'k'), ylim([-6000 6000]); hold on
LinearTrueTsd=tsd(TimeStepsPred36*1E4,LinearTrue);
LinearPredTsd=tsd(TimeStepsPred36*1E4,LinearPred);
LinearPredSleepTsd=tsd(TimeStepsPredSleep*1E4,LinearPredSleep);
figure,
subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0)
subplot(5,1,4), plot(TimeStepsPredSleep, LinearPredSleep)
subplot(5,1,5), plot(Range(Restrict(LFP, sleep),'sec'), Data(Restrict(LFP, sleep)),'k'), ylim([-6000 6000]); hold on
LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);
LinearPredSleepTsd=tsd(TimeStepsPredSleep*1E4,LinearPredSleep);
figure, hold on,
plot(TimeStepsPredSleep, LinearPredSleep,'color',[0.7 0.7 0.7])
plot(TimeStepsPredSleep, LinearPredSleep,'k.')
hold on, plot(TimeStepsPred36, LinearPred,'b.')
hold on, plot(TimeStepsPred36, LinearTrue,'r')
hold on, plot(TimeStepsPred36, LinearTrue,'r.','markersize',10)
hold on, plot(Range(tRipples,'s'),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')
figure, hold on,
plot(TimeStepsPredSleep, LinearPredSleep,'color',[0.7 0.7 0.7])
plot(TimeStepsPredSleep, LinearPredSleep,'k.')
hold on, plot(TimeStepsPred, LinearPred,'b.')
hold on, plot(TimeStepsPred, LinearTrue,'r')
hold on, plot(TimeStepsPred, LinearTrue,'r.','markersize',10)
hold on, plot(Range(tRipples,'s'),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')
figure, hold on,
plot(TimeStepsPredSleep, Data(LinearPredSleepTsd),'color',[0.7 0.7 0.7])
plot(TimeStepsPredSleep, Data(LinearPredSleepTsd),'k.')
hold on, plot(TimeStepsPred, Data(LinearPredTsd),'b.')
hold on, plot(TimeStepsPred, Data(LinearTrueTsd),'r')
hold on, plot(TimeStepsPred, Data(LinearTrueTsd),'r.','markersize',10)
hold on, plot(Range(tRipples,'s'),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')
figure, hold on,
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'color',[0.7 0.7 0.7])
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'k.')
hold on, plot(Range(LinearPredTsd), Data(LinearPredTsd),'b.')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r.','markersize',10)
hold on, plot(Range(tRipples),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')
[h1,b1]=hist(Data(Restrict(LinearTrueTsd,testPre)),50);
[h2,b2]=hist(Data(Restrict(LinearPredTsd,testPre)),50);
[h3,b3]=hist(Data(Restrict(LinearPredSleepTsd,postSleep)),50);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,preSleep)),50);
RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,RipEp)),50);
[h5,b5]=hist(Data(Restrict(LinearPredSleepTsd,REMEpoch)),50);
figure, plot(b1,h1/max(h1),'k')
hold on, plot(b2,h2/max(h2),'b'),
plot(b3,h3/max(h3),'r'),
plot(b4,h4/max(h4),'color',[0.6 0.6 0.6])
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
Ep=intervalSet(1.2327*1E8,1.5210*1E8);
k=k+1;
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},Ep),Restrict(X,Ep),Restrict(Y,Ep));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},Ep),Restrict(LinearTrueTsd,Ep),Restrict(LinearPredTsd,Ep));
k=k+1;
[m1,s1,t1]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearTrueTsd,testPre)),30,100);
[m2,s2,t2]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearPredTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)),30,100);
figure, hold on, plot(t1/1E3,s1,'k'), plot(t2/1E3,s2,'r'),ylim([0 1])
k
k=k-1
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},Ep),Restrict(X,Ep),Restrict(Y,Ep));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},Ep),Restrict(LinearTrueTsd,Ep),Restrict(LinearPredTsd,Ep));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},Ep),Restrict(LinearTrueTsd,Ep),Restrict(LinearPredTsd,Ep));
[m1,s1,t1]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearTrueTsd,testPre)),30,100);
[m2,s2,t2]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearPredTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)),30,100);
figure, hold on, plot(t1/1E3,s1,'k'), plot(t2/1E3,s2,'r'),ylim([0 1])
figure, hold on
plot(Range(Restrict(LinearPredTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)),'.')
plot(Range(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearTrueTsd,testPre)))
plot(Range(Restrict(LinearTrueTsd,Restrict(Stsd{k},testPre))),Data(Restrict(LinearPredTsd,Restrict(Stsd{k},testPre))),'r.','markersize',15)
figure, hold on
plot(Data(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)))
plot(Data(Restrict(LinearTrueTsd,Restrict(Stsd{k},testPre))),Data(Restrict(LinearPredTsd,Restrict(Stsd{k},testPre))),'r.')
figure,
subplot(1,2,1), plot(Data(LinearTrueTsd),Data(Restrict(X,LinearTrueTsd)))
subplot(1,2,2), plot(Data(LinearTrueTsd),Data(Restrict(Y,LinearTrueTsd)))
figure,
subplot(5,1,1:4), RasterPlot(S)
subplot(5,1,5),plot(Range(LinearPredTsd),LinearPred)
hold on, plot(Range(Restrict(X,ts(Start(StimEpoch)))),Data(Restrict(Y,ts(Start(StimEpoch)))),'r.','markersize',10)
figure, plot(Data(Restrict(X,cond)),Data(Restrict(Y,cond)));
hold on, plot(Data(Restrict(X,ts(Start(StimEpoch)))), Data(Restrict(Y,ts(Start(StimEpoch)))),'r.','markersize',10)
figure, plot(Data(Restrict(X,testPost)),Data(Restrict(Y,testPost)))
%-- 17/12/2024 18:16:03 --%
uiopen('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/M1199_20210408_UMaze.dat',1)
load('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/M1199_20210408_UMaze.dat')
%-- 17/12/2024 19:09:02 --%
3
%%
addpath(genpath('~/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('~/Dropbox/Kteam/Fra'))
addpath(genpath('~/Dropbox/Kteam/PrgMatlab'))
addpath('~/Dropbox/Kteam/PrgMatlab')
%%
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
mexGPUall
cd("..")
kilosort
irc2 compile
irc2 install
irc2
irc2phy
irc2
irc
%-- 19/12/2024 16:36:39 --%
cd "/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output"
cd("/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output")
kilosort2_5_master('/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output', '/home/mickey/Documents/Theotime/Kilosort')
%-- 19/12/2024 16:38:33 --%
run('/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output/kilosort2_5_master.m')
edit('/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output/kilosort2_5_master.m')
fpath '/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output'
fpath = '/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output'
kilosortPath = '/home/mickey/Documents/Theotime/Kilosort'
rez
do_correction
e datashift2
edit datashift2
if  getOr(rez.ops, 'nblocks', 1)==0
rez.iorig = 1:rez.temp.Nbatch;
return;
end
ops = rez.ops;
% The min and max of the y and x ranges of the channels
ymin = min(rez.yc);
ymax = max(rez.yc);
xmin = min(rez.xc);
xmax = max(rez.xc);
dmin = median(diff(unique(rez.yc)));
fprintf('pitch is %d um\n', dmin)
rez.ops.yup = ymin:dmin/2:ymax; % centers of the upsampled y positions
xrange = xmax - xmin;
npt = floor(xrange/16); % this would come out as 16um for Neuropixels probes, which aligns with the geometry.
rez.ops.xup = linspace(xmin, xmax, npt+1); % centers of the upsampled x positions
spkTh = 8; % same as the usual "template amplitude", but for the generic templates
% Extract all the spikes across the recording that are captured by the
% generic templates. Very few real spikes are missed in this way.
[st3, rez] = standalone_detector(rez, spkTh);
%%
% binning width across Y (um)
dd = 5;
% detected depths
dep = st3(:,2);
% min and max for the range of depths
dmin = ymin - 1;
dep = dep - dmin;
dmax  = 1 + ceil(max(dep)/dd);
Nbatches      = rez.temp.Nbatch;
% which batch each spike is coming from
batch_id = st3(:,5); %ceil(st3(:,1)/dt);
% preallocate matrix of counts with 20 bins, spaced logarithmically
F = zeros(dmax, 20, Nbatches);
batch_id = st3(:,5); %ceil(st3(:,1)/dt);
[st3, rez] = standalone_detector(rez, spkTh);
kilosort2_5_master(fpath, kilosortPath)
%-- 19/12/2024 16:44:52 --%
fpath = '/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output'
kilosortPath = '/home/mickey/Documents/Theotime/Kilosort'
kilosort2_5_master
%-- 19/12/2024 16:45:55 --%
fpath = '/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output'
kilosortPath = '/home/mickey/Documents/Theotime/Kilosort'
kilosort2_5_master
%-- 19/12/2024 16:47:18 --%
fpath = '/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output'
kilosortPath = '/home/mickey/Documents/Theotime/Kilosort'
kilosort2_5_master
%-- 19/12/2024 16:50:34 --%
fpath = '/home/mickey/download/20241121_puretones/kilosort2_5_output/ch31grp0/sorter_output'
kilosortPath = '/home/mickey/Documents/Theotime/Kilosort'
cd(fpath)
cd("../..")
cd(kilosortPath)
kilosort
%-- 28/12/2024 22:37:07 --%
edit SpikeSorting_Analysis_AG.m
%-- 07/01/2025 10:23:39 --%
cd('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/')
load behavResources.mat
load SpikeData.mat
load SWR
addpath(genpath('~/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('~/Dropbox/Kteam/Fra'))
addpath(genpath('~/Dropbox/Kteam/PrgMatlab'))
addpath('~/Dropbox/Kteam/PrgMatlab')
%%
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
load LFPData/LFP14
cd('~/download/')
%%
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
mice = 1199;
Dir = PathForExperiments_TC("Sub");
Dir = RestrictPathForExperiment_TC(Dir, 'nMice', mice);
csvLinearPred = csvread([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred(2:end,1);
LinearPred=csvLinearPred(2:end,2);
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = csvread([Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv']);
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
TimeStepsPred = csvTimeStepsPred(2:end,2);
save('timeStepsPred.mat', 'idxTimeStepsPred', 'TimeStepsPred')
csvLossPred = csvread([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
idxLossPred = csvLossPred(2:end,1);
LossPred=csvLossPred(2:end,2);
save('lossPred.mat', 'idxLossPred', 'LossPred')
csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
idxLinearTrue = csvLinearTrue(2:end,1);
LinearTrue=csvLinearTrue(2:end,2);
save('linearTrue.mat', 'idxLinearTrue', 'LinearTrue')
%importing decoded position during sleep
csvLinearPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/linearPred.csv']);
idxLinearPredSleep = csvLinearPredSleep(2:end,1);
LinearPredSleep=csvLinearPredSleep(2:end,2);
save('linearPredSleep.mat', 'idxLinearPredSleep', 'LinearPredSleep')
csvTimeStepsPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/timeStepsPred.csv']);
idxTimeStepsPredSleep = csvTimeStepsPredSleep(2:end,1);
TimeStepsPredSleep = csvTimeStepsPredSleep(2:end,2);
save('timeStepsPredSleep.mat', 'idxTimeStepsPredSleep', 'TimeStepsPredSleep')
idxLinearPredtot = [idxLinearPred; idxLinearPredSleep];
LinearPredtot=[LinearPred;LinearPredSleep];
save('linearPredtot.mat', 'idxLinearPredtot', 'LinearPredtot')
idxTimeStepsPredtot = [idxTimeStepsPred;idxTimeStepsPredSleep];
TimeStepsPredtot = [TimeStepsPred;TimeStepsPredSleep];
save('timeStepsPredtot.mat', 'idxTimeStepsPredtot', 'TimeStepsPredtot')
k=80;
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),30,Data(Restrict(V,Restrict(Y,testPre))),'filled')
disp('pause')
figure, RasterPlot(Restrict(Stsd,testPost))
disp('pause')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
% [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},tot),Restrict(X,tot),Restrict(Y,tot));
disp('pause')
k=28;
k=k+1;
% PlaceField(Restrict(Stsd{k},and(tot,SpeedEpoch)),Restrict(X,and(tot,SpeedEpoch)),Restrict(Y,and(tot,SpeedEpoch)));
PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
disp('pause')
k=1;
rg=Range(X,'s');
tend=rg(end)-rg(1);
T=poissonKB((length(Range(Stsd{k}))/(rg(end)-rg(1)))/1,tend)+rg(1);
Ts=tsd(T'*1E4,T'*1E4);
PlaceField(Restrict(Ts,and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
k=1;
k=k+1;
[C,B]=CrossCorr(Range(Stsd{k}),Range(Stsd{k+1}),10,100);
figure, bar(B/1E3,C,1,'k')
mexGPUall
mex
mex -setup
mexGPUall
kilosort
%-- 08/01/2025 10:55:22 --%
BasileStufff
fig
figure
clear fig10_1
clear figs
clear allfigures
clf
close all
k=80;
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),30,Data(Restrict(V,Restrict(Y,testPre))),'filled')
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),3,Data(Restrict(V,Restrict(Y,testPre))),'filled')
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),300,Data(Restrict(V,Restrict(Y,testPre))),'filled')
k=1;
k=k+1;
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
idx=find(BasicNeuronInfo.neuroclass==1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,idx), ts(sw(1:200)), -1500,+1500,'BinSize',10);
idxI=find(BasicNeuronInfo.neuroclass==-1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,idxI), ts(sw(1:200)), -1500,+1500,'BinSize',10);
Fil=FilterLFP(LFP,[5 10],1024);
QsTestPre = MakeQfromS(Restrict(Stsd,testPre),5000);  % 50ms !!!!!
rateTestPre = full(Data(QsTestPre));
figure, imagesc(zscore(rateTestPre)'), caxis([-5 5])
subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
figure,
% This subplot is plotting the true linear in red, and the predicted one
% either in blue if the confidence is high (high predicted loss) , or in
% green if it's low (low/negative predicted loss)
subplot(3,1,1), hold on,
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(tRipples),Range(LossPredTsd),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')

[C,B]=CrossCorr(Range(tRipples),Data(LossPredTsd),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')

figure, hold on,
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'color',[0.7 0.7 0.7])
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'k.')
hold on, plot(Range(LinearPredTsd), Data(LinearPredTsd),'b.')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r.','markersize',10)
hold on, plot(Range(tRipples),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')
[h5,b5]=hist(Data(Restrict(LinearPredSleepTsd,REMEpoch)),50);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,RipEp)),50);
[h6,b6]=hist(Data(Restrict(LossPredTsd,RipEp)),50);
plot(b5,h5/max(h5),'color',[0.6 1 0.6])
plot(b6,h6/max(h6),'color',[0.6 1 0.6])
figure, plot(b6,h6/max(h6),'color',[0.6 1 0.6])
b6
h6
figure, plot(Data(LossPredTsd, tRipples))
figure, plot(Data(LossPredTsd, RipplesEpoch))
figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch), Data(Restrict(LossPredTsd, RipplesEpoch)))
figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch)), Data(Restrict(LossPredTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearTrueTsd, RipplesEpoch)), Data(Restrict(LinearTrueTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearPred$Tsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearPredTsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)))
figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch)), Data(Restrict(LossPredTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearTrueTsd, RipplesEpoch)), Data(Restrict(LinearTrueTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearPred$Tsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearPredTsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)))
figure, hold on
plot(Range(Restrict(LinearPredTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)),'.')
plot(Range(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearTrueTsd,testPre)))
plot(Range(Restrict(LinearTrueTsd,Restrict(Stsd{k},testPre))),Data(Restrict(LinearPredTsd,Restrict(Stsd{k},testPre))),'r.','markersize',15)
figure,
subplot(5,1,1:4), RasterPlot(S)
subplot(5,1,5),plot(Range(LinearPredTsd),LinearPred)
hold on, plot(Range(Restrict(X,ts(Start(StimEpoch)))),Data(Restrict(Y,ts(Start(StimEpoch)))),'r.','markersize',10)
figure, plot(Data(Restrict(X,cond)),Data(Restrict(Y,cond)));
hold on, plot(Data(Restrict(X,ts(Start(StimEpoch)))), Data(Restrict(Y,ts(Start(StimEpoch)))),'r.','markersize',10)
figure, plot(Data(Restrict(X,testPost)),Data(Restrict(Y,testPost)))
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
caxis([0 30])
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
size(predi)
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure, hold on
plot(Data(Restrict(Restrict(LinearTrueTsd,testPre), GoodEpoch)),Data(Restrict(Restrict(LinearPredTsd,testPre), GoodEpoch)))
plot(Data(Restrict(LinearTrueTsd,Restrict(Stsd{k},testPre))),Data(Restrict(LinearPredTsd,Restrict(Stsd{k},testPre))),'r.')
plot(Data(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)))
figure, hold on
plot(Data(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)))
[m1,s1,t1]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearTrueTsd,testPre)),30,100);
[m2,s2,t2]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearPredTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)),30,100);
figure, hold on, plot(t1/1E3,s1,'k'), plot(t2/1E3,s2,'r'),ylim([0 1])
[h1,b1]=hist(Data(Restrict(LinearTrueTsd,testPre)),50);
[h2,b2]=hist(Data(Restrict(LinearPredTsd,testPre)),50);
[h3,b3]=hist(Data(Restrict(LinearPredSleepTsd,postSleep)),50);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,preSleep)),50);
RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,RipEp)),50);
[h5,b5]=hist(Data(Restrict(LinearPredSleepTsd,REMEpoch)),50);
figure, plot(b1,h1/max(h1),'k')
hold on, plot(b2,h2/max(h2),'b'),
plot(b3,h3/max(h3),'r'),
plot(b4,h4/max(h4),'color',[0.6 0.6 0.6])
plot(b5,h5/max(h5),'color',[0.6 1 0.6])
[h1,b1]=hist(Data(Restrict(LinearTrueTsd,testPre)),50);
[h2,b2]=hist(Data(Restrict(LinearPredTsd,testPre)),50);
[h3,b3]=hist(Data(Restrict(LinearPredSleepTsd,postSleep)),50);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,preSleep)),50);
RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,RipEp)),50);
[h5,b5]=hist(Data(Restrict(LinearPredSleepTsd,REMEpoch)),50);
figure, plot(b1,h1/max(h1),'k')
hold on, plot(b2,h2/max(h2),'b'),
plot(b3,h3/max(h3),'r'),
plot(b4,h4/max(h4),'color',[0.6 0.6 0.6])
[h1,b1]=hist(Data(Restrict(LinearTrueTsd,testPre)),50);
[h2,b2]=hist(Data(Restrict(LinearPredTsd,testPre)),50);
[h3,b3]=hist(Data(Restrict(LinearPredSleepTsd,postSleep)),50);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,preSleep)),50);
RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,RipEp)),50);
figure, plot(b1,h1/max(h1),'k')
hold on, plot(b2,h2/max(h2),'b'),
plot(b3,h3/max(h3),'r'),
plot(b4,h4/max(h4),'color',[0.6 0.6 0.6])
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),500);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),500);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),50);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),50);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),100);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),100);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),70);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),70);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
edit LinearizeTrack
edit linearized_position_KB
edit MorphMazeToSingleShape_EmbReact_DB.m
which -all readtable
% uiopen('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv',1)
help csvread
help readtable
% testcsv=uiopen('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
edit csvread
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
size(m)
figure, plot(m(:,1),m(:,2))
figure, plot(m(:,1),m(:,3))
figure, plot(m(:,2),m(:,3))
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
size(predi)
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
size(m)
figure, plot(m(:,1),m(:,2))
figure, plot(m(:,1),m(:,3))
figure, plot(m(:,2),m(:,3))
figure, plot(m(:,2),m(:,3))
figure, hist(m(:,2),m(:,3))
pts = linspace(0, 1, 101);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2)
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
figure, plot(m(:,2),m(:,3))
figure, plot(m(:,2),m(:,3), 'r.')
figure, hold on,
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'color',[0.7 0.7 0.7])
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'k.')
hold on, plot(Range(LinearPredTsd), Data(LinearPredTsd),'b.')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r.','markersize',10)
hold on, plot(Range(tRipples),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')
figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch)), Data(Restrict(LossPredTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearPredTsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)), 'ko', 'markerfacecolor','k')
hold on, plot(Range(Restrict(LinearTrueTsd, RipplesEpoch)), Data(Restrict(LinearTrueTsd, RipplesEpoch)), 'ko', 'markerfacecolor','y')
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi,1000)
predi
figure, hist(predi(:,2),1000)
load('nnBehavior.mat')
load('nnBehavior.mat', 'testt')
load('nnBehavior.mat', testt)
load('nnBehavior.mat')
a = load('nnBehavior.mat')
b = load('nnBehavior.mat')
nain = load("/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/nnBehavior.mat
nain = load("/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/nnBehavior.mat")
naion
nain
nain.behavior
nain.behavior.positions
load('nnBehavior.mat')
load('nnBehavior.mat', 'behavior')
load('nnBehavior.mat')
load('backupnnBehavior.mat')
load('nnBehavior.mat')
load('nnBehavior.mat', 'behavior')
c=load('nnBehavior.mat', 'behavior')
c
load('nnBehavior.mat', 'behavior')
load('nnBehavior.mat', 'behaviorv2')
behaviorv2 = load("behavResources.mat")
load('nnBehavior.mat', 'behavior')
clear all
close all
load('nnBehavior.mat')
clear all
load('nnBehavior.mat')
whos('-file', 'nnBehavior.mat''
whos('-file', 'nnBehavior.mat')
whos('-file', 'nnBehavior.mat', 'behavior')
whos('-file', 'nnBehavior.mat', 'behaviorrr')
whos('-file', 'nnBehavior.mat', 'behavior')
nain = load('nnBehavior.mat', 'behavior')
whos(nain)
load('nnBehavior.mat', 'behavior')
h5info('nnBehavior.mat')
h5disp('nnBehavior.mat')
%-- 13/01/2025 17:28:59 --%
edit BasileStufff.m
cd('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/')
load behavResources.mat
load SpikeData.mat
load SWR
try
% old fashion data
Range(S{1});
Stsd=S;
t=Range(AlignedXtsd);
X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
% Dima's style of data
clear Stsd
for i=1:length(S.C)
test=S.C{1,i};
Stsd{i}=ts(test.data);
end
Stsd=tsdArray(Stsd);
t = AlignedXtsd.data;
X = tsd(AlignedXtsd.t,AlignedXtsd.data);
Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
V = tsd(Vtsd.t,Vtsd.data);
hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
cond = or(or(cond1,cond2),or(cond3,cond4));
postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
sleep = or(preSleep,postSleep);
tot = or(testPre,sleep);
end
which -all readtable
help csvread
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
size(m)
figure, plot(m(:,1),m(:,2))
figure, plot(m(:,1),m(:,3))
figure, plot(m(:,2),m(:,3))
pts = linspace(0, 1, 101);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
figure, plot(m(:,2),m(:,3))
figure, plot(m(:,2),m(:,3), 'r.')
pts = linspace(0, 1, 101);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
figure, hist(predi(:,2),1000)
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')
k=80;
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);
[m,s,tps]=mETAverage(e,t,v,binsize,nbBins);
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
pts = linspace(0, 1, 101);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 1001);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 51);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 10);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 25);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 35);
N = histcounts2(m(:,2), m(:,3), pts, pts);
subplot(1, 2, 1);
x = m(:,2);
y=m(:,3);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts
pts = linspace(0, 1, 35);
x = m(:,2);
y=m(:,3);
N = histcounts2(x, y, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
N
pts = linspace(0, 1, 35);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 35);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
pts = linspace(0, 1, 35);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
imagesc(pts, pts, N, );
imagesc(pts, pts, N );
imagesc(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
image(pts, pts, N)
pts = linspace(0, 1, 35);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 45);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 15);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
%% Show the density of the prediction
pts = linspace(0, 1, 17);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
pts = linspace(0, 1, 17);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
pts = linspace(0, 1, 35);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
%% Show the density of the prediction
pts = linspace(0, 1, 25);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
% figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
pts = linspace(0, 1, 25);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch)), Data(Restrict(LossPredTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearPredTsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)), 'ko', 'markerfacecolor','k')
hold on, plot(Range(Restrict(LinearTrueTsd, RipplesEpoch)), Data(Restrict(LinearTrueTsd, RipplesEpoch)), 'ko', 'markerfacecolor','y')
BasileStufff
cd('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/')
Data(LinearDist)
figure, plot(Data(LinearDist))
figure, hist$(Data(LinearDist))
figure, hist(Data(LinearDist))
figure, hist(Data(LinearDist), 40)
figure, hist(Data(Restrict(LinearDist, hab)), 40)
figure, hist(Data(Restrict(LinearDist, hab)), 30)
hold on, hist(Data(Restrict(AlignedXtsd, hab)), 30)
figure, hist(Data(Restrict(LinearDist, hab)), 30)
hold on, hist(Data(Restrict(AlignedXtsd, hab)), 30)
figure, hist(Data(Restrict(LinearDist, hab)), 30, 'b')
hold on, hist(Data(Restrict(AlignedXtsd, hab)), 30, 'r')
figure, hist(Data(Restrict(LinearDist, hab)), 30, 'b')
hold on, hist(Data(Restrict(AlignedXtsd, hab)), 30, "FaceColor", 'r')
hold on, hist(Data(Restrict(AlignedXtsd, hab)), 30, "FaceColor", 'red')
(Data(Restrict(AlignedXtsd, hab), Data(Restrict(AlignedXtsd, hab))
[Data(Restrict(AlignedXtsd, hab), Data(Restrict(AlignedXtsd, hab)))]
size([Data(Restrict(AlignedXtsd, hab), Data(Restrict(AlignedXtsd, hab)))])
size([Data(Restrict(AlignedXtsd, hab); Data(Restrict(AlignedXtsd, hab)))])
figure, hist(Data(Restrict(LinearDist, hab)), 30, 'b')
figure, histogram(Data(Restrict(LinearDist, hab)), 30, 'b')
figure, histogram(Data(Restrict(LinearDist, hab)))
hold on, histogram(Data(Restrict(AlignedXtsd, hab)), "FaceColor", 'red')
hold on, histogram(Data(Restrict(AlignedYtsd, hab)), "FaceColor", 'red')
close
figure, histogram(Data(Restrict(LinearDist, hab)))
hold on, histogram(Data(Restrict(AlignedXtsd, hab)), "FaceColor", 'red')
hold on, histogram(Data(Restrict(AlignedYtsd, hab)), "FaceColor", 'yellow')
figure, histogram(Data(Restrict(LinearDist, hab)))
hold on, histogram(Data(Restrict(AlignedXtsd, hab)), "FaceColor", 'red', "FaceAlpha", 0.1)
hold on, histogram(Data(Restrict(AlignedYtsd, hab)), "FaceColor", 'yellow', "FaceAlpha", 0.1)
%-- 13/01/2025 19:55:43 --%
Correct_Subsampling_BM('mickey')
edit Correct_Subsampling_BM
Correct_Subsampling_BM('mickey')
BasileStufff
figure,,,plot(csvLinearTrue(:,2))
edit Post_PreProcess_BasicEphysComputations.m
figure,plot(Range(LinearTrueTsd), Data(LinearTrueTsd))
figure,histogram(Range(LinearTrueTsd), Data(LinearTrueTsd))
figure,histogram(Data(LinearTrueTsd))
figure,histogram(Data(Restrict(LinearTrueTsd, hab)))
figure,histogram(Data(Restrict(LinearTrueTsd, hab)), 'NumberBins', 20)
figure,histogram(Data(Restrict(LinearTrueTsd, hab)), 'NBINS', 20)
figure,histogram(Data(Restrict(LinearTrueTsd, hab)), 'NBins', 20)
cd('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/')
load('behavResources.mat', 'NewtsdZT')
edit HighSpectrum.m
%-- 14/01/2025 17:44:37 --%
Correct_Subsampling_BM('mickey')
%-- 15/01/2025 14:05:18 --%
edit PathForExperimentsBasalSleepSpike
cl
BasileStufff
%% Plot the network confidence around ripples events, and the predicted vs actual Linear predicted distance.
figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch)), Data(Restrict(LossPredTsd, RipplesEpoch)))
hold on, plot(Range(Restrict(LinearPredTsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)), 'ko', 'markerfacecolor','k')
hold on, plot(Range(Restrict(LinearTrueTsd, RipplesEpoch)), Data(Restrict(LinearTrueTsd, RipplesEpoch)), 'ko', 'markerfacecolor','y')
edit zscore
figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch)), zscore(Data(Restrict(LossPredTsd, RipplesEpoch))))
hold on, plot(Range(Restrict(LinearPredTsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)), 'ko', 'markerfacecolor','k')
hold on, plot(Range(Restrict(LinearTrueTsd, RipplesEpoch)), Data(Restrict(LinearTrueTsd, RipplesEpoch)), 'ko', 'markerfacecolor','y')
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),70);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
figure,
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,cond),idx_shockZone_testPre,0);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, cond),'s'), Data(Restrict(LinearTrueTsd, cond)),'r')
plot(Range(Restrict(LinearPredTsd,cond),'s'),Data(Restrict(LinearPredTsd,cond)),'b');
hold on, plot(Range(tRipples,'sec'), 0.9,'r*') % We also plot the ripples because reactivations occur during ripples
subplot(5,1,5), ylim([0 1])
a=condTime(1);
l=10; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')
pts = linspace(0, 1, 25);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
histogram(Data(Restrict(LinearPredTsd, RipplesEpoch)))
figure, histogram(Data(Restrict(LinearPredTsd, RipplesEpoch)))
figure, hist(Data(Restrict(LinearPredTsd, RipplesEpoch)))
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
sav = True
sav = true
dir_out = '/home/mickey/download/test';
fig_out1 = 'MeanOccupancyMap2';
fig_out2 = 'Example';
sav = 1;
% Numbers of mice to run analysis on
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];
Mice_to_analyze = [994 1239];
SessNames={'TestPre' 'TestPost' };
XLinPos = [0:0.05:1];
Dir = PathForExperiments_TC('Sub');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
for i = 1:length(Dir.path)
a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end
Dir = PathForExperiments_TC('Sub');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
for i = 1:length(Dir.path)
a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end
history
commandhistory