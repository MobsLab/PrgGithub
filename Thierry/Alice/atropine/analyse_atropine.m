%% Figures Baseline 1 : sleep modes during sleep and sleep-wake proportions over all night

%On load les différentes données des différents fichiers

%Baseline 1 souris 923
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M923
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch923_B=REMEpoch;
Sleep923_B=Sleep;
SWSEpoch923_B=SWSEpoch;
Wake923_B=Wake;

%Baseline 1 souris 926
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M926
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch926_B=REMEpoch;
Sleep926_B=Sleep;
SWSEpoch926_B=SWSEpoch;
Wake926_B=Wake;

%Baseline 1 souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch927_B=REMEpoch;
Sleep927_B=Sleep;
SWSEpoch927_B=SWSEpoch;
Wake927_B=Wake;

%Baseline 1 souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch928_B=REMEpoch;
Sleep928_B=Sleep;
SWSEpoch928_B=SWSEpoch;
Wake928_B=Wake;

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep 923
PercREM_Sleep_923_Baseline1=(sum(Stop(REMEpoch923_B,'s')-Start(REMEpoch923_B,'s'))./sum(Stop(Sleep923_B,'s')-Start(Sleep923_B,'s'))).*100;
%SWS/Sleep 923
PercSWS_Sleep_923_Baseline1=(sum(Stop(SWSEpoch923_B,'s')-Start(SWSEpoch923_B,'s'))./sum(Stop(Sleep923_B,'s')-Start(Sleep923_B,'s'))).*100;
%Wake/Total 923
PercWake_Total_923_Baseline1=(sum(Stop(Wake923_B,'s')-Start(Wake923_B,'s'))./(sum(Stop(Wake923_B,'s')-Start(Wake923_B,'s'))+sum(Stop(Sleep923_B,'s')-Start(Sleep923_B,'s')))).*100;
%SWS/Total 923
PercSWS_Total_923_Baseline1=(sum(Stop(SWSEpoch923_B,'s')-Start(SWSEpoch923_B,'s'))./(sum(Stop(Wake923_B,'s')-Start(Wake923_B,'s'))+sum(Stop(Sleep923_B,'s')-Start(Sleep923_B,'s')))).*100;
%REM/Total 923
PercREM_Total_923_Baseline1=(sum(Stop(REMEpoch923_B,'s')-Start(REMEpoch923_B,'s')))/(sum(Stop(Wake923_B,'s')-Start(Wake923_B,'s'))+sum(Stop(Sleep923_B,'s')-Start(Sleep923_B,'s'))).*100;

%REM/Sleep 926
PercREM_Sleep_926_Baseline1=(sum(Stop(REMEpoch926_B,'s')-Start(REMEpoch926_B,'s'))./sum(Stop(Sleep926_B,'s')-Start(Sleep926_B,'s'))).*100;
%SWS/Sleep 926
PercSWS_Sleep_926_Baseline1=(sum(Stop(SWSEpoch926_B,'s')-Start(SWSEpoch926_B,'s'))./sum(Stop(Sleep926_B,'s')-Start(Sleep926_B,'s'))).*100;
%Wake/Total 926
PercWake_Total_926_Baseline1=(sum(Stop(Wake926_B,'s')-Start(Wake926_B,'s'))./(sum(Stop(Wake926_B,'s')-Start(Wake926_B,'s'))+sum(Stop(Sleep926_B,'s')-Start(Sleep926_B,'s')))).*100;
%SWS/Total 926
PercSWS_Total_926_Baseline1=(sum(Stop(SWSEpoch926_B,'s')-Start(SWSEpoch926_B,'s'))./(sum(Stop(Wake926_B,'s')-Start(Wake926_B,'s'))+sum(Stop(Sleep926_B,'s')-Start(Sleep926_B,'s')))).*100;
%REM/Total 926
PercREM_Total_926_Baseline1=(sum(Stop(REMEpoch926_B,'s')-Start(REMEpoch926_B,'s')))/(sum(Stop(Wake926_B,'s')-Start(Wake926_B,'s'))+sum(Stop(Sleep926_B,'s')-Start(Sleep926_B,'s'))).*100;

%REM/Sleep 927
PercREM_Sleep_927_Baseline1=(sum(Stop(REMEpoch927_B,'s')-Start(REMEpoch927_B,'s'))./sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s'))).*100;
%SWS/Sleep 927
PercSWS_Sleep_927_Baseline1=(sum(Stop(SWSEpoch927_B,'s')-Start(SWSEpoch927_B,'s'))./sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s'))).*100;
%Wake/Total 927
PercWake_Total_927_Baseline1=(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))./(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))+sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s')))).*100;
%SWS/Total 927
PercSWS_Total_927_Baseline1=(sum(Stop(SWSEpoch927_B,'s')-Start(SWSEpoch927_B,'s'))./(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))+sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s')))).*100;
%REM/Total 927
PercREM_Total_927_Baseline1=(sum(Stop(REMEpoch927_B,'s')-Start(REMEpoch927_B,'s')))/(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))+sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s'))).*100;

%REM/Sleep 928
PercREM_Sleep_928_Baseline1=(sum(Stop(REMEpoch928_B,'s')-Start(REMEpoch928_B,'s'))./sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s'))).*100;
%SWS/Sleep 928
PercSWS_Sleep_928_Baseline1=(sum(Stop(SWSEpoch928_B,'s')-Start(SWSEpoch928_B,'s'))./sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s'))).*100;
%Wake/Total 928
PercWake_Total_928_Baseline1=(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))./(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))+sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s')))).*100;
%SWS/Total 928
PercSWS_Total_928_Baseline1=(sum(Stop(SWSEpoch928_B,'s')-Start(SWSEpoch928_B,'s'))./(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))+sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s')))).*100;
%REM/Total 928
PercREM_Total_928_Baseline1=(sum(Stop(REMEpoch928_B,'s')-Start(REMEpoch928_B,'s')))/(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))+sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s'))).*100;


PercSWS_Total_Baseline1=[PercSWS_Total_923_Baseline1, PercSWS_Total_926_Baseline1, PercSWS_Total_927_Baseline1, PercSWS_Total_928_Baseline1];
PercREM_Total_Baseline1=[PercREM_Total_923_Baseline1, PercREM_Total_926_Baseline1, PercREM_Total_927_Baseline1, PercREM_Total_928_Baseline1];
PercWake_Total_Baseline1=[PercWake_Total_923_Baseline1, PercWake_Total_926_Baseline1, PercWake_Total_927_Baseline1, PercWake_Total_928_Baseline1];
PercSWS_Sleep_Baseline1=[PercSWS_Sleep_923_Baseline1, PercSWS_Sleep_926_Baseline1, PercSWS_Sleep_927_Baseline1, PercSWS_Sleep_928_Baseline1];
PercREM_Sleep_Baseline1=[PercREM_Sleep_923_Baseline1, PercREM_Sleep_926_Baseline1, PercREM_Sleep_927_Baseline1, PercREM_Sleep_928_Baseline1];



[PercWake_Total_Baseline1 PercSWS_Total_Baseline1 PercREM_Total_Baseline1];
PlotErrorBarN_KJ({PercWake_Total_Baseline1 PercSWS_Total_Baseline1 PercREM_Total_Baseline1});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions overall (Baseline1)')
xticklabels({' ',' ','Wake',' ','SWS',' ','REM'})

PlotErrorBarN_KJ({PercSWS_Sleep_Baseline1 PercREM_Sleep_Baseline1});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep modes during sleep (Baseline1)')
xticklabels({' ',' ','SWS',' ','REM'})

%% Figure M927-M928 : evolution of sleep modes with atropine for the 3 experiments

%Baseline 1 souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch927_B=REMEpoch;
Sleep927_B=Sleep;
SWSEpoch927_B=SWSEpoch;
Wake927_B=Wake;

%Baseline 1 souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch928_B=REMEpoch;
Sleep928_B=Sleep;
SWSEpoch928_B=SWSEpoch;
Wake928_B=Wake;

%Atropine souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch927_A=REMEpoch;
Sleep927_A=Sleep;
SWSEpoch927_A=SWSEpoch;
Wake927_A=Wake;

%Atropine souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch928_A=REMEpoch;
Sleep928_A=Sleep;
SWSEpoch928_A=SWSEpoch;
Wake928_A=Wake;

%Saline souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch927_S=REMEpoch;
Sleep927_S=Sleep;
SWSEpoch927_S=SWSEpoch;
Wake927_S=Wake;

%Saline souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch928_S=REMEpoch;
Sleep928_S=Sleep;
SWSEpoch928_S=SWSEpoch;
Wake928_S=Wake;

%REM/Sleep 927
PercREM_Sleep_927_Baseline1=(sum(Stop(REMEpoch927_B,'s')-Start(REMEpoch927_B,'s'))./sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s'))).*100;
%SWS/Sleep 927
PercSWS_Sleep_927_Baseline1=(sum(Stop(SWSEpoch927_B,'s')-Start(SWSEpoch927_B,'s'))./sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s'))).*100;
%Wake/Total 927
PercWake_Total_927_Baseline1=(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))./(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))+sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s')))).*100;
%SWS/Total 927
PercSWS_Total_927_Baseline1=(sum(Stop(SWSEpoch927_B,'s')-Start(SWSEpoch927_B,'s'))./(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))+sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s')))).*100;
%REM/Total 927
PercREM_Total_927_Baseline1=(sum(Stop(REMEpoch927_B,'s')-Start(REMEpoch927_B,'s')))/(sum(Stop(Wake927_B,'s')-Start(Wake927_B,'s'))+sum(Stop(Sleep927_B,'s')-Start(Sleep927_B,'s'))).*100;

%REM/Sleep 928
PercREM_Sleep_928_Baseline1=(sum(Stop(REMEpoch928_B,'s')-Start(REMEpoch928_B,'s'))./sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s'))).*100;
%SWS/Sleep 928
PercSWS_Sleep_928_Baseline1=(sum(Stop(SWSEpoch928_B,'s')-Start(SWSEpoch928_B,'s'))./sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s'))).*100;
%Wake/Total 928
PercWake_Total_928_Baseline1=(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))./(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))+sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s')))).*100;
%SWS/Total 928
PercSWS_Total_928_Baseline1=(sum(Stop(SWSEpoch928_B,'s')-Start(SWSEpoch928_B,'s'))./(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))+sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s')))).*100;
%REM/Total 928
PercREM_Total_928_Baseline1=(sum(Stop(REMEpoch928_B,'s')-Start(REMEpoch928_B,'s')))/(sum(Stop(Wake928_B,'s')-Start(Wake928_B,'s'))+sum(Stop(Sleep928_B,'s')-Start(Sleep928_B,'s'))).*100;


%REM/Sleep 927
PercREM_Sleep_927_atropine=(sum(Stop(REMEpoch927_A,'s')-Start(REMEpoch927_A,'s'))./sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s'))).*100;
%SWS/Sleep 927
PercSWS_Sleep_927_atropine=(sum(Stop(SWSEpoch927_A,'s')-Start(SWSEpoch927_A,'s'))./sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s'))).*100;
%Wake/Total 927
PercWake_Total_927_atropine=(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))./(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))+sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s')))).*100;
%SWS/Total 927
PercSWS_Total_927_atropine=(sum(Stop(SWSEpoch927_A,'s')-Start(SWSEpoch927_A,'s'))./(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))+sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s')))).*100;
%REM/Total 927
PercREM_Total_927_atropine=(sum(Stop
(REMEpoch927_A,'s')-Start(REMEpoch927_A,'s')))/(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))+sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s'))).*100;

%REM/Sleep 928
PercREM_Sleep_928_atropine=(sum(Stop(REMEpoch928_A,'s')-Start(REMEpoch928_A,'s'))./sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s'))).*100;
%SWS/Sleep 928
PercSWS_Sleep_928_atropine=(sum(Stop(SWSEpoch928_A,'s')-Start(SWSEpoch928_A,'s'))./sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s'))).*100;
%Wake/Total 928
PercWake_Total_928_atropine=(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))./(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))+sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s')))).*100;
%SWS/Total 928
PercSWS_Total_928_atropine=(sum(Stop(SWSEpoch928_A,'s')-Start(SWSEpoch928_A,'s'))./(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))+sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s')))).*100;
%REM/Total 928
PercREM_Total_load('H_Low_Spectrum.mat')
SpectroH=Spectro;
load('B_High_Spectrum.mat')
SpectroBH=Spectro;928_atropine=(sum(Stop(REMEpoch928_A,'s')-Start(REMEpoch928_A,'s')))/(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))+sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s'))).*100;


%REM/Sleep 927
PercREM_Sleep_927_saline=(sum(Stop(REMEpoch927_S,'s')-Start(REMEpoch927_S,'s'))./sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s'))).*100;
%SWS/Sleep 927
PercSWS_Sleep_927_saline=(sum(Stop(SWSEpoch927_S,'s')-Start(SWSEpoch927_S,'s'))./sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s'))).*100;
%Wake/Total 927
PercWake_Total_927_saline=(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))./(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))+sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s')))).*100;
%SWS/Total 927
PercSWS_Total_927_saline=(sum(Stop(SWSEpoch927_S,'s')-Start(SWSEpoch927_S,'s'))./(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))+sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s')))).*100;
%REM/Total 927
PercREM_Total_927_saline=(sum(Stop(REMEpoch927_S,'s')-Start(REMEpoch927_S,'s')))/(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))+sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s'))).*100;

%REM/Sleep 928
PercREM_Sleep_928_saline=(sum(Stop(REMEpoch928_S,'s')-Start(REMEpoch928_S,'s'))./sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s'))).*100;
%SWS/Sleep 928
PercSWS_Sleep_928_saline=(sum(Stop(SWSEpoch928_S,'s')-Start(SWSEpoch928_S,'s'))./sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s'))).*100;
%Wake/Total 928
PercWake_Total_928_saline=(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))./(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))+sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s')))).*100;
%SWS/Total 928
PercSWS_Total_928_saline=(sum(Stop(SWSEpoch928_S,'s')-Start(SWSEpoch928_S,'s'))./(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))+sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s')))).*100;
%REM/Total 928
PercREM_Total_928_saline=(sum(Stop(REMEpoch928_S,'s')-Start(REMEpoch928_S,'s')))/(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))+sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s'))).*100;


PercSWS_Total_Baseline1=[PercSWS_Total_927_Baseline1, PercSWS_Total_928_Baseline1];
PercREM_Total_Baseline1=[PercREM_Total_927_Baseline1, PercREM_Total_928_Baseline1];
PercWake_Total_Baseline1=[PercWake_Total_927_Baseline1, PercWake_Total_928_Baseline1];
PercSWS_Sleep_Baseline1=[PercSWS_Sleep_927_Baseline1, PercSWS_Sleep_928_Baseline1];
PercREM_Sleep_Baseline1=[PercREM_Sleep_927_Baseline1, PercREM_Sleep_928_Baseline1];

PercSWS_Total_atropine=[PercSWS_Total_927_atropine, PercSWS_Total_928_atropine];
PercREM_Total_atropine=[PercREM_Total_927_atropine, PercREM_Total_928_atropine];
PercWake_Total_atropine=[PercWake_Total_927_atropine, PercWake_Total_928_atropine];
PercSWS_Sleep_atropine=[PercSWS_Sleep_927_atropine, PercSWS_Sleep_928_atropine];
PercREM_Sleep_atropine=[PercREM_Sleep_927_atropine, PercREM_Sleep_928_atropine];

PercSWS_Total_saline=[PercSWS_Total_927_saline, PercSWS_Total_928_saline];
PercREM_Total_saline=[PercREM_Total_927_saline, PercREM_Total_928_saline];
PercWake_Total_saline=[PercWake_Total_927_saline, PercWake_Total_928_saline];
PercSWS_Sleep_saline=[PercSWS_Sleep_927_saline, PercSWS_Sleep_928_saline];
PercREM_Sleep_saline=[PercREM_Sleep_927_saline, PercREM_Sleep_928_saline];


PlotErrorBarN_KJ({PercWake_Total_Baseline1 PercSWS_Total_Baseline1 PercREM_Total_Baseline1 PercWake_Total_atropine PercSWS_Total_atropine PercREM_Total_atropine PercWake_Total_saline PercSWS_Total_saline PercREM_Total_saline});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions')
xticklabels({'Baseline Wake','Baseline SWS','Baseline REM','Atropine Wake','Atropine SWS','Atropine REM','Saline Wake','Saline SWS','Saline REM'})

PlotErrorBarN_KJ({PercSWS_Sleep_Baseline1 PercREM_Sleep_Baseline1 PercSWS_Sleep_atropine PercREM_Sleep_atropine PercSWS_Sleep_saline PercREM_Sleep_saline});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep modes during sleep')
xticklabels({'','SWS Baseline','REM Baseline','SWS Atropine','REM Atropine','SWS Saline','REM Saline'})

PlotErrorBarN_KJ({ PercREM_Sleep_Baseline1 PercREM_Sleep_atropine PercREM_Sleep_saline});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Percentage of SWS during sleep')
xticklabels({'','','REM Baseline','','REM Atropine','','REM Saline'})

%% Spectres


%Baseline 1 souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_B=REMEpoch;
Sleep927_B=Sleep;
SWSEpoch927_B=SWSEpoch;
Wake927_B=Wake;
TotalNoiseEpoch_927_B=TotalNoiseEpoch;
load('H_Low_Spectrum.mat')
SpectroH_927_B=Spectro;
load('B_High_Spectrum.mat')
SpectroB_927_B=Spectro;

%Baseline 1 souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_B=REMEpoch;
Sleep928_B=Sleep;
SWSEpoch928_B=SWSEpoch;
Wake928_B=Wake;
TotalNoiseEpoch_928_B=TotalNoiseEpoch;
load('H_Low_Spectrum.mat')
SpectroH_928_B=Spectro;

%Atropine souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_A=REMEpoch;
Sleep927_A=Sleep;
SWSEpoch927_A=SWSEpoch;
Wake927_A=Wake;
TotalNoiseEpoch_927_A=TotalNoiseEpoch;Spectro;
load('B_High_Spectrum.mat')
SpectroB_928_B=Spectro;

%Atropine souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_A=REMEpoch;
Sleep927_A=Sleep;
SWSEpoch927_A=SWSEpoch;
Wake927_A=Wake;
TotalNoiseEpoch_927_A=TotalNoiseEpoch;
load('H_Low_Spectrum.mat')
SpectroH_927_A=Spectro;
load('B_High_Spectrum.mat')
SpectroB_927_A=Spectro;

%Atropine souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_A=REMEpoch;
Sleep928_A=Sleep;
SWSEpoch928_A=SWSEpoch;
Wake928_A=Wake;
TotalNoiseEpoch_928_A=TotalNoiseEpoch;
load('H_Low_Spectrum.mat')
SpectroH_928_A=Spectro;
load('B_High_Spectrum.mat')
SpectroB_928_A=Spectro;

%Saline souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_S=REMEpoch;
Sleep927_S=Sleep;
SWSEpoch927_S=SWSEpoch;
Wake927_S=Wake;
TotalNoiseEpoch_927_S=TotalNoiseEpoch;
load('H_Low_Spectrum.mat')
SpectroH_927_S=Spectro;
load('B_High_Spectrum.mat')
SpectroB_927_S=Spectro;

%Saline souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_S=REMEpoch;
Sleep928_S=Sleep;
SWSEpoch928_S=SWSEpoch;
Wake928_S=Wake;
TotalNoiseEpoch_928_S=TotalNoiseEpoch;
load('H_Low_Spectrum.mat')
SpectroH_928_S=Spectro;
load('B_High_Spectrum.mat')
SpectroB_928_S=Spectro;

figure, 
subplot(2,1,1), imagesc(SpectroH_927_B{2},SpectroH_927_B{3},10*log10(SpectroH_927_B{1}')), axis xy
caxis([10 65])
colormap(jet)
subplot(2,1,2), imagesc(SpectroB_927_B{2},SpectroB_927_B{3},10*log10(SpectroB_927_B{1}')), axis xy
caxis([10 65])
colormap(jet)

size(Spectro{1})% taille;
%figure, imagesc(SpectroH_927_B{2},SpectroH_927_B{3},10*log10(SpectroH_927_B{1})'), axis xy
Spectrotsd_927_B=tsd(SpectroH_927_B{2}*1E4,10*log10(SpectroH_927_B{1}));
f_927_B=SpectroH_927_B{3};
Spectrotsd_927_A=tsd(SpectroH_927_A{2}*1E4,10*log10(SpectroH_927_A{1}));
f_927_A=SpectroH_927_A{3};
Spectrotsd_927_S=tsd(SpectroH_927_S{2}*1E4,10*log10(SpectroH_927_S{1}));
f_927_S=SpectroH_927_S{3};
Spectrotsd_928_B=tsd(SpectroH_928_B{2}*1E4,10*log10(SpectroH_928_B{1}));
f_928_B=SpectroH_928_B{3};
Spectrotsd_928_A=tsd(SpectroH_928_A{2}*1E4,10*log10(SpectroH_928_A{1}));
f_928_A=SpectroH_928_A{3};
Spectrotsd_928_S=tsd(SpectroH_928_S{2}*1E4,10*log10(SpectroH_928_S{1}));
f_928_S=SpectroH_928_S{3};

figure
subplot(3,2,1), plot(f_927_B,mean(Data(Restrict(Spectrotsd_927_B,REMEpoch927_B-TotalNoiseEpoch_927_B))),'r')
hold on, plot(f_927_B,mean(Data(Restrict(Spectrotsd_927_B,SWSEpoch927_B-TotalNoiseEpoch_927_B))),'b')
hold on, plot(f_927_B,mean(Data(Restrict(Spectrotsd_927_B,W
ake927_B-TotalNoiseEpoch_927_B))),'k')
legend('REM','SWS','Wake')
title('Hippocampus Low Spectrum for M927 Baseline')
xlabel('Frequency')
ylabel('Amplitude')
subplot(3,2,3), plot(f_927_A,mean(Data(Restrict(Spectrotsd_927_A,REMEpoch927_A-TotalNoiseEpoch_927_A))),'r')
hold on, plot(f_927_A,mean(Data(Restrict(Spectrotsd_927_A,SWSEpoch927_A-TotalNoiseEpoch_927_A))),'b')
hold on, plot(f_927_A,mean(Data(Restrict(Spectrotsd_927_A,Wake927_B-TotalNoiseEpoch_927_A))),'k')
legend('REM','SWS','Wake')
title('Hippocampus Low Spectrum for M927 Atropine')
xlabel('Frequency')
ylabel('Amplitude')
subplot(3,2,5), plot(f_927_S,mean(Data(Restrict(Spectrotsd_927_S,REMEpoch927_S-TotalNoiseEpoch_927_S))),'r')
hold on, plot(f_927_S,mean(Data(Restrict(Spectrotsd_927_S,SWSEpoch927_S-TotalNoiseEpoch_927_S))),'b')
hold on, plot(f_927_S,mean(Data(Restrict(Spectrotsd_927_S,Wake927_B-TotalNoiseEpoch_927_S))),'k')
legend('REM','SWS','Wake')
title('Hippocampus Low Spectrum for M927 Saline')
xlabel('Frequency')
ylabel('Amplitude')
subplot(3,2,2), plot(f_928_B,mean(Data(Restrict(Spectrotsd_928_B,REMEpoch928_B-TotalNoiseEpoch_928_B))),'r')
hold on, plot(f_928_B,mean(Data(Restrict(Spectrotsd_928_B,SWSEpoch928_B-TotalNoiseEpoch_928_B))),'b')
hold on, plot(f_928_B,mean(Data(Restrict(Spectrotsd_928_B,Wake927_B-TotalNoiseEpoch_928_B))),'k')
legend('REM','SWS','Wake')
title('Hippocampus Low Spectrum for M928 Baseline')
xlabel('Frequency')
ylabel('Amplitude')
subplot(3,2,4), plot(f_928_A,mean(Data(Restrict(Spectrotsd_928_A,REMEpoch928_A-TotalNoiseEpoch_928_A))),'r')
hold on, plot(f_928_A,mean(Data(Restrict(Spectrotsd_928_A,SWSEpoch928_A-TotalNoiseEpoch_928_A))),'b')
hold on, plot(f_928_A,mean(Data(Restrict(Spectrotsd_928_A,Wake927_B-TotalNoiseEpoch_928_A))),'k')
legend('REM','SWS','Wake')
title('Hippocampus Low Spectrum for M928 Atropine')
xlabel('Frequency')
ylabel('Amplitude')
subplot(3,2,6), plot(f_928_S,mean(Data(Restrict(Spectrotsd_928_S,REMEpoch928_S-TotalNoiseEpoch_928_S))),'r')
hold on, plot(f_928_S,mean(Data(Restrict(Spectrotsd_928_S,SWSEpoch928_S-TotalNoiseEpoch_928_S))),'b')
hold on, plot(f_928_S,mean(Data(Restrict(Spectrotsd_928_S,Wake928_B-TotalNoiseEpoch_928_S))),'k')
legend('REM','SWS','Wake')
title('Hippocampus Low Spectrum for M928 Saline')
xlabel('Frequency')
ylabel('Amplitude')

%% REM overtime M927

%Baseline 1 souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_B=REMEpoch;
Sleep927_B=Sleep;
SWSEpoch927_B=SWSEpoch;
Wake927_B=Wake;



try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimBaseline927=max([max(End(Wake927_B)),max(End(REMEpoch927_B)), max(End(SWSEpoch927_B))]);

numpointsBaseline927=floor(maxlimBaseline927/pas/1E4)+1;

for i=1:numpointsBaseline927
    perBaseline927(i)=FindPercREM(REMEpoch927_B,SWSEpoch927_B, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsBaseline927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%Atropine souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_A=REMEpoch;
Sleep927_A=Sleep;
SWSEpoch927_A=SWSEpoch;
Wake927_A=Wake;
TotalNoiseEpoch_927_A=TotalNoiseEpoch;


try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimAtropine927=max([max(End(Wake927_A)),max(End(REMEpoch927_A)), max(End(SWSEpoch927_A))]);

numpointsAtropine927=floor(maxlimAtropine927/pas/1E4)+1;

for i=1:numpointsAtropine927
    perAtropine927(i)=FindPercREM(REMEpoch927_A,SWSEpoch927_A, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsAtropine927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%Saline souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_S=REMEpoch;
Sleep927_S=Sleep;
SWSEpoch927_S=SWSEpoch;
Wake927_S=Wake;
TotalNoiseEpoch_927_S=TotalNoiseEpoch;


try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimSaline927=max([max(End(Wake927_S)),max(End(REMEpoch927_S)), max(End(SWSEpoch927_S))]);

numpointsSaline927=floor(maxlimSaline927/pas/1E4)+1;

for i=1:numpointsSaline927
    perSaline927(i)=FindPercREM(REMEpoch927_S,SWSEpoch927_S, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSaline927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%SleepStagesSaline=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
%hold on,
figure, plot(tpsBaseline927/1E4,perBaseline927,'ko-','LineWidth',2)
hold on, plot(tpsAtropine927/1E4,perAtropine927,'ro-','LineWidth',2)
hold on, plot(tpsSaline927/1E4,perSaline927,'bo-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M927')
legend('Baseline','Atropine','Saline')

%% REM overtime 928

%Baseline 1 souris 927
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Baseline1_24092019_190924_085150/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_B=REMEpoch;
Sleep928_B=Sleep;
SWSEpoch928_B=SWSEpoch;
Wake928_B=Wake;



try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimBaseline928=max([max(End(Wake928_B)),max(End(REMEpoch928_B)), max(End(SWSEpoch928_B))]);

numpointsBaseline928=floor(maxlimBaseline928/pas/1E4)+1;

for i=1:numpointsBaseline928
    perBaseline928(i)=FindPercREM(REMEpoch928_B,SWSEpoch928_B, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsBaseline928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%Atropine souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_atropine_26092019_190926_094820/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_A=REMEpoch;
Sleep928_A=Sleep;
SWSEpoch928_A=SWSEpoch;
Wake928_A=Wake;
TotalNoiseEpoch_928_A=TotalNoiseEpoch;


try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimAtropine928=max([max(End(Wake928_A)),max(End(REMEpoch928_A)), max(End(SWSEpoch928_A))]);

numpointsAtropine928=floor(maxlimAtropine928/pas/1E4)+1;

for i=1:numpointsAtropine928
    perAtropine928(i)=FindPercREM(REMEpoch928_A,SWSEpoch928_A, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsAtropine928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%Saline souris 928
cd /media/nas5/Thierry_DATA/Atropine_Treatment/923_926_927_928_Saline_27092019_190927_090819/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_S=REMEpoch;
Sleep928_S=Sleep;
SWSEpoch928_S=SWSEpoch;
Wake928_S=Wake;
TotalNoiseEpoch_928_S=TotalNoiseEpoch;


try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimSaline928=max([max(End(Wake928_S)),max(End(REMEpoch928_S)), max(End(SWSEpoch928_S))]);

numpointsSaline928=floor(maxlimSaline928/pas/1E4)+1;

for i=1:numpointsSaline928
    perSaline928(i)=FindPercREM(REMEpoch928_S,SWSEpoch928_S, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSaline928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%SleepStagesSaline=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
%hold on,
figure, plot(tpsBaseline928/1E4,perBaseline928,'ko-','LineWidth',2)
hold on, plot(tpsAtropine928/1E4,perAtropine928,'ro-','LineWidth',2)
hold on, plot(tpsSaline928/1E4,perSaline928,'bo-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M928')
legend('Baseline','Atropine','Saline')