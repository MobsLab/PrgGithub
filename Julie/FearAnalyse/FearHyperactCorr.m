function FearHyperactCorr(manipname)

hab='envA';
StepName{1}=['HAB ' hab];
StepName{2}='COND';
if strcmp(manipname,'ManipDec14Bulbectomie')
    StepName{3}='EXT pleth';
elseif strcmp(manipname,'ManipFeb15Bulbectomie')
    StepName{3}='EXT envC';
end
StepName{4}='EXT envB';

load shamAllMiceBilan_1_envA.mat
table=[];
for i=1:4 % 4 step HAB COND EXT1 EXT2
    table=[table nanmean(bilan{1,i}, 2)];
end
Freezing{1,1}=table;


load bulbAllMiceBilan_1_envA.mat
table=[];
for i=1:4 % 4 step HAB COND EXT1 EXT2
    table=[table nanmean(bilan{1,i}, 2)];
end
Freezing{1,2}=table;

save freezing.mat Freezing


load Hyperactivity_8.mat

list{'MeanDistFromTheCenterTable';'NbEntriesCenterNormTable';'NbEntriesCenterTable';...
    'PercentTimeCenterTable';'PercentTimePeriphTable';'StopNbTable';'TotalDistanceTable';
    'TotalTimeTable';}



