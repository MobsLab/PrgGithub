%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ce fichier sert à analyser les donnée déjà pré processées de l'expérience
%box_rat effectuée avec les souris M927 et M928 les 08, 09 et 10 octobre 2019
%L'expérience consiste en 3 enregistrements :
%* BASELINE où la souris est mise dans un tupperware dans une cage de rat
%  vide pendant 1h avant d'être enregistrée dans sa propre cage
%* EXPOSURE où la souris est mise dans un tupperware avec nourriture dans
%  une cage de rat où se trouve un rat à jeun depuis 30h pendant 1h avant
%  d'être enregistrée dans sa cage à côté de celle du rat
%* BASELINE 2 où la souris est mise dans un tupperware dans une cage de rat
%  vide pendant 1h avant d'être enregistrée dans sa propre cage

%Le but de l'expérience est d'enregistrer une journée de sommeil en
%condition de stress, ce qui est censé se produire par une diminution de
%REM pour l'enregistrement EXPOSURE. Les souris n'ont cependant pas été observées
%stressées au cours de l'expérience.

%Plusieurs analyses et figures sont réalisées dans ce fichier, chacune dans
%une section différente :

%* Section 1 : Trace les figures de l'évolution des modes de sommeil pour les 3
%  expériences pour les 2 souris
%  Les figures tracées sont :
%    * Pourcentages de Wake, SWS & REM au cours de l'enregistrement pour
%      les 3 expériences pour les 2 souris
%    * Pourcentages de SWS & REM au cours du sommeil pour
%      les 3 expériences pour les 2 souris

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 1 : Evolution of sleep modes for the 3 experiments for M927 & M928

%B pour Baseline1
%A pour Exposure
%S pour Baseline2

%Load de tous les fichiers des 3 expérences pour les 2 souris

%Baseline 1 souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch927_B=REMEpoch;
Sleep927_B=Sleep;
SWSEpoch927_B=SWSEpoch;
Wake927_B=Wake;

%Baseline 1 souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch928_B=REMEpoch;
Sleep928_B=Sleep;
SWSEpoch928_B=SWSEpoch;
Wake928_B=Wake;

%Exposure souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch927_A=REMEpoch;
Sleep927_A=Sleep;
SWSEpoch927_A=SWSEpoch;
Wake927_A=Wake;

%Exposure souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch928_A=REMEpoch;
Sleep928_A=Sleep;
SWSEpoch928_A=SWSEpoch;
Wake928_A=Wake;

%Basline2 souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch927_S=REMEpoch;
Sleep927_S=Sleep;
SWSEpoch927_S=SWSEpoch;
Wake927_S=Wake;

%Baseline2 souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
REMEpoch928_S=REMEpoch;
Sleep928_S=Sleep;
SWSEpoch928_S=SWSEpoch;
Wake928_S=Wake;

%Calcul de pourcentages relatifs à Wake SWS et REM pour les 3 expériences
%pour les deux souris

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
PercREM_Sleep_927_exposure=(sum(Stop(REMEpoch927_A,'s')-Start(REMEpoch927_A,'s'))./sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s'))).*100;
%SWS/Sleep 927
PercSWS_Sleep_927_exposure=(sum(Stop(SWSEpoch927_A,'s')-Start(SWSEpoch927_A,'s'))./sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s'))).*100;
%Wake/Total 927
PercWake_Total_927_exposure=(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))./(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))+sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s')))).*100;
%SWS/Total 927
PercSWS_Total_927_exposure=(sum(Stop(SWSEpoch927_A,'s')-Start(SWSEpoch927_A,'s'))./(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))+sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s')))).*100;
%REM/Total 927
PercREM_Total_927_exposure=(sum(Stop(REMEpoch927_A,'s')-Start(REMEpoch927_A,'s')))/(sum(Stop(Wake927_A,'s')-Start(Wake927_A,'s'))+sum(Stop(Sleep927_A,'s')-Start(Sleep927_A,'s'))).*100;

%REM/Sleep 928
PercREM_Sleep_928_exposure=(sum(Stop(REMEpoch928_A,'s')-Start(REMEpoch928_A,'s'))./sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s'))).*100;
%SWS/Sleep 928
PercSWS_Sleep_928_exposure=(sum(Stop(SWSEpoch928_A,'s')-Start(SWSEpoch928_A,'s'))./sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s'))).*100;
%Wake/Total 928
PercWake_Total_928_exposure=(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))./(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))+sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s')))).*100;
%SWS/Total 928
PercSWS_Total_928_exposure=(sum(Stop(SWSEpoch928_A,'s')-Start(SWSEpoch928_A,'s'))./(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))+sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s')))).*100;
%REM/Total 928
PercREM_Total_928_exposure=(sum(Stop(REMEpoch928_A,'s')-Start(REMEpoch928_A,'s')))/(sum(Stop(Wake928_A,'s')-Start(Wake928_A,'s'))+sum(Stop(Sleep928_A,'s')-Start(Sleep928_A,'s'))).*100;


%REM/Sleep 927
PercREM_Sleep_927_Baseline2=(sum(Stop(REMEpoch927_S,'s')-Start(REMEpoch927_S,'s'))./sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s'))).*100;
%SWS/Sleep 927
PercSWS_Sleep_927_Baseline2=(sum(Stop(SWSEpoch927_S,'s')-Start(SWSEpoch927_S,'s'))./sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s'))).*100;
%Wake/Total 927
PercWake_Total_927_Baseline2=(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))./(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))+sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s')))).*100;
%SWS/Total 927
PercSWS_Total_927_Baseline2=(sum(Stop(SWSEpoch927_S,'s')-Start(SWSEpoch927_S,'s'))./(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))+sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s')))).*100;
%REM/Total 927
PercREM_Total_927_Baseline2=(sum(Stop(REMEpoch927_S,'s')-Start(REMEpoch927_S,'s')))/(sum(Stop(Wake927_S,'s')-Start(Wake927_S,'s'))+sum(Stop(Sleep927_S,'s')-Start(Sleep927_S,'s'))).*100;

%REM/Sleep 928
PercREM_Sleep_928_Baseline2=(sum(Stop(REMEpoch928_S,'s')-Start(REMEpoch928_S,'s'))./sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s'))).*100;
%SWS/Sleep 928
PercSWS_Sleep_928_Baseline2=(sum(Stop(SWSEpoch928_S,'s')-Start(SWSEpoch928_S,'s'))./sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s'))).*100;
%Wake/Total 928
PercWake_Total_928_Baseline2=(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))./(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))+sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s')))).*100;
%SWS/Total 928
PercSWS_Total_928_Baseline2=(sum(Stop(SWSEpoch928_S,'s')-Start(SWSEpoch928_S,'s'))./(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))+sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s')))).*100;
%REM/Total 928
PercREM_Total_928_Baseline2=(sum(Stop(REMEpoch928_S,'s')-Start(REMEpoch928_S,'s')))/(sum(Stop(Wake928_S,'s')-Start(Wake928_S,'s'))+sum(Stop(Sleep928_S,'s')-Start(Sleep928_S,'s'))).*100;


%Merge des données 2 souris dans des tableaux

PercSWS_Total_Baseline1=[PercSWS_Total_927_Baseline1, PercSWS_Total_928_Baseline1];
PercREM_Total_Baseline1=[PercREM_Total_927_Baseline1, PercREM_Total_928_Baseline1];
PercWake_Total_Baseline1=[PercWake_Total_927_Baseline1, PercWake_Total_928_Baseline1];
PercSWS_Sleep_Baseline1=[PercSWS_Sleep_927_Baseline1, PercSWS_Sleep_928_Baseline1];
PercREM_Sleep_Baseline1=[PercREM_Sleep_927_Baseline1, PercREM_Sleep_928_Baseline1];

PercSWS_Total_exposure=[PercSWS_Total_927_exposure, PercSWS_Total_928_exposure];
PercREM_Total_exposure=[PercREM_Total_927_exposure, PercREM_Total_928_exposure];
PercWake_Total_exposure=[PercWake_Total_927_exposure, PercWake_Total_928_exposure];
PercSWS_Sleep_exposure=[PercSWS_Sleep_927_exposure, PercSWS_Sleep_928_exposure];
PercREM_Sleep_exposure=[PercREM_Sleep_927_exposure, PercREM_Sleep_928_exposure];

PercSWS_Total_Baseline2=[PercSWS_Total_927_Baseline2, PercSWS_Total_928_Baseline2];
PercREM_Total_Baseline2=[PercREM_Total_927_Baseline2, PercREM_Total_928_Baseline2];
PercWake_Total_Baseline2=[PercWake_Total_927_Baseline2, PercWake_Total_928_Baseline2];
PercSWS_Sleep_Baseline2=[PercSWS_Sleep_927_Baseline2, PercSWS_Sleep_928_Baseline2];
PercREM_Sleep_Baseline2=[PercREM_Sleep_927_Baseline2, PercREM_Sleep_928_Baseline2];

% Tracé des figures

%Pourcentages de Wake, SWS & REM au cours de l'enregistrement pour les 3
%expériences pour les 2 souris
PlotErrorBarN_KJ({PercWake_Total_Baseline1 PercSWS_Total_Baseline1 PercREM_Total_Baseline1 PercWake_Total_exposure PercSWS_Total_exposure PercREM_Total_exposure PercWake_Total_Baseline2 PercSWS_Total_Baseline2 PercREM_Total_Baseline2});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions')
xticklabels({'Baseline1 Wake','Baseline1 SWS','Baseline1 REM','Exposure Wake','Exposure SWS','Exposure REM','Baseline2 Wake','Baseline2 SWS','Baseline2 REM'})

%Pourcentages de SWS & REM au cours du sommeil pour les 3 expériences pour
%les 2 souris
PlotErrorBarN_KJ({PercSWS_Sleep_Baseline1 PercREM_Sleep_Baseline1 PercSWS_Sleep_exposure PercREM_Sleep_exposure PercSWS_Sleep_Baseline2 PercREM_Sleep_Baseline2});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep modes during sleep')
xticklabels({'','SWS Baseline1','REM Baseline1','SWS Exposure','REM Exposure','SWS Baseline2','REM Baseline2'})

%Pourcentages de REM au cours du sommeil pour les 3 expériences pour les 2
%souris
PlotErrorBarN_KJ({ PercREM_Sleep_Baseline1 PercREM_Sleep_exposure PercREM_Sleep_Baseline2});
ylabel('Percentage (%)')
xlabel('Conditions')
title('Percentage of SWS during sleep')
xticklabels({'','','REM Baseline1','','REM Exposure','','REM Baseline2'})

%% Low frequency hypocampus spectrum

%B pour Baseline1
%A pour Exposure
%S pour Baseline2

%Baseline 1 souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M927
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
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_B=REMEpoch;
Sleep928_B=Sleep;
SWSEpoch928_B=SWSEpoch;
Wake928_B=Wake;
TotalNoiseEpoch_928_B=TotalNoiseEpoch;
load('H_Low_Spectrum.mat')
SpectroH_928_B=Spectro;

%Exposure souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_A=REMEpoch;
Sleep927_A=Sleep;
SWSEpoch927_A=SWSEpoch;
Wake927_A=Wake;
TotalNoiseEpoch_927_A=TotalNoiseEpoch;Spectro;
load('B_High_Spectrum.mat')
SpectroB_928_B=Spectro;

%Exposure souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M928
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

%Baseline2 souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M927
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

%Baseline2 souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M928
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

size(Spectro{1});% taille;
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
hold on, plot(f_927_B,mean(Data(Restrict(Spectrotsd_927_B,Wake927_B-TotalNoiseEpoch_927_B))),'k')
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
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M927
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


%Exposure souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M927
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

maxlimExposure927=max([max(End(Wake927_A)),max(End(REMEpoch927_A)), max(End(SWSEpoch927_A))]);

numpointsExposure927=floor(maxlimExposure927/pas/1E4)+1;

for i=1:numpointsExposure927
    perExposure927(i)=FindPercREM(REMEpoch927_A,SWSEpoch927_A, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsExposure927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

%Baseline2 souris 927
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M927
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch927_S=REMEpoch;
Sleep927_S=Sleep;
SWSEpoch927_S=SWSEpoch;
Wake927_S=Wake;


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

maxlimBaseline2_927=max([max(End(Wake927_S)),max(End(REMEpoch927_S)), max(End(SWSEpoch927_S))]);

numpointsBaseline2_927=floor(maxlimBaseline2_927/pas/1E4)+1;

for i=1:numpointsBaseline2_927
    perBaseline2_927(i)=FindPercREM(REMEpoch927_S,SWSEpoch927_S, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsBaseline2_927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%SleepStagesSaline=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
%hold on,
%figure, plot(tpsBaseline927/1E4,rescale(perBaseline927,-1,2),'ko-','LineWidth',2)
figure, plot(tpsBaseline927/1E4,perBaseline927,'ko-','LineWidth',2)
%hold on, plot(tpsExposure927/1E4,rescale(perExposure927,-1,2),'ro-','LineWidth',2)
hold on, plot(tpsExposure927/1E4,perExposure927,'ro-','LineWidth',2)
%hold on, plot(tpsBaseline2_927/1E4,rescale(perBaseline2_927,-1,2),'bo-','LineWidth',2)
hold on, plot(tpsBaseline2_927/1E4,perBaseline2_927,'bo-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M927')
legend('Baseline 1','Exposure','Baseline 2')


%% REM overtime M928

%Baseline 1 souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline1_box_rat_08102019_191008_103545/M928
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


%Exposure souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Exposure_box_rat_09102019_191009_100751/M928
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

maxlimExposure928=max([max(End(Wake928_A)),max(End(REMEpoch928_A)), max(End(SWSEpoch928_A))]);

numpointsExposure928=floor(maxlimExposure928/pas/1E4)+1;

for i=1:numpointsExposure928
    perExposure928(i)=FindPercREM(REMEpoch928_A,SWSEpoch928_A, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsExposure928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

%Baseline2 souris 928
cd /media/nas5/Thierry_DATA/Rat_box/927_928_Baseline2_box_rat_10102019_191010_100238/M928
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep','TotalNoiseEpoch')
REMEpoch928_S=REMEpoch;
Sleep928_S=Sleep;
SWSEpoch928_S=SWSEpoch;
Wake928_S=Wake;


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

maxlimBaseline2_928=max([max(End(Wake928_S)),max(End(REMEpoch928_S)), max(End(SWSEpoch928_S))]);

numpointsBaseline2_928=floor(maxlimBaseline2_928/pas/1E4)+1;

for i=1:numpointsBaseline2_928
    perBaseline2_928(i)=FindPercREM(REMEpoch928_S,SWSEpoch928_S, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsBaseline2_928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


%SleepStagesSaline=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
%hold on,
%figure, plot(tpsBaseline928/1E4,rescale(perBaseline928,-1,2),'ko-','LineWidth',2)
figure, plot(tpsBaseline928/1E4,perBaseline928,'ko-','LineWidth',2)
%hold on, plot(tpsExposure928/1E4,rescale(perExposure928,-1,2),'ro-','LineWidth',2)
hold on, plot(tpsExposure928/1E4,perExposure928,'ro-','LineWidth',2)
%hold on, plot(tpsBaseline2_928/1E4,rescale(perBaseline2_928,-1,2),'bo-','LineWidth',2)
hold on, plot(tpsBaseline2_928/1E4,perBaseline2_928,'bo-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M928')
legend('Baseline 1','Exposure','Baseline 2')


%% REM proportions 1st, 2nd & 3rd third
%Pour pouvoir lancer cette section, il faut avoir déjà lancé les sections 
%REM overtime M927 et REM overtime M928


%927
PercFirstHalfBaseline_927=nanmean(perBaseline927(1:length(perBaseline927)/2));
PercSecHalfBaseline_927=nanmean(perBaseline927(length(perBaseline927)/2:end));

PercFirstThirdBaseline_927=nanmean(perBaseline927(1:length(perBaseline927)/3));
PercSecThirdBaseline_927=nanmean(perBaseline927(length(perBaseline927)/3:2*length(perBaseline927)/3));
PercLastThirdBaseline_927=nanmean(perBaseline927(2*length(perBaseline927)/3:end));


PercFirstHalfExposure_927=nanmean(perExposure927(1:length(perExposure927)/2));
PercSecHalfExposure_927=nanmean(perExposure927(length(perExposure927)/2:end));

PercFirstThirdExposure_927=nanmean(perExposure927(1:length(perExposure927)/3));
PercSecThirdExposure_927=nanmean(perExposure927(length(perExposure927)/3:2*length(perExposure927)/3));
PercLastThirdExposure_927=nanmean(perExposure927(2*length(perExposure927)/3:end));


PercFirstHalfBaseline2_927=nanmean(perBaseline2_927(1:length(perBaseline2_927)/2));
PercSecHalfBaseline2_927=nanmean(perBaseline2_927(length(perBaseline2_927)/2:end));

PercFirstThirdBaseline2_927=nanmean(perBaseline2_927(1:length(perBaseline2_927)/3));
PercSecThirdBaseline2_927=nanmean(perBaseline2_927(length(perBaseline2_927)/3:2*length(perBaseline2_927)/3));
PercLastThirdBaseline2_927=nanmean(perBaseline2_927(2*length(perBaseline2_927)/3:end));

%928
PercFirstHalfBaseline_928=nanmean(perBaseline928(1:length(perBaseline928)/2));
PercSecHalfBaseline_928=nanmean(perBaseline928(length(perBaseline928)/2:end));

PercFirstThirdBaseline_928=nanmean(perBaseline928(1:length(perBaseline928)/3));
PercSecThirdBaseline_928=nanmean(perBaseline928(length(perBaseline928)/3:2*length(perBaseline928)/3));
PercLastThirdBaseline_928=nanmean(perBaseline928(2*length(perBaseline928)/3:end));


PercFirstHalfExposure_928=nanmean(perExposure928(1:length(perExposure928)/2));
PercSecHalfExposure_928=nanmean(perExposure928(length(perExposure928)/2:end));

PercFirstThirdExposure_928=nanmean(perExposure928(1:length(perExposure928)/3));
PercSecThirdExposure_928=nanmean(perExposure928(length(perExposure928)/3:2*length(perExposure928)/3));
PercLastThirdExposure_928=nanmean(perExposure928(2*length(perExposure928)/3:end));


PercFirstHalfBaseline2_928=nanmean(perBaseline2_928(1:length(perBaseline2_928)/2));
PercSecHalfBaseline2_928=nanmean(perBaseline2_928(length(perBaseline2_928)/2:end));

PercFirstThirdBaseline2_928=nanmean(perBaseline2_928(1:length(perBaseline2_928)/3));
PercSecThirdBaseline2_928=nanmean(perBaseline2_928(length(perBaseline2_928)/3:2*length(perBaseline2_928)/3));
PercLastThirdBaseline2_928=nanmean(perBaseline2_928(2*length(perBaseline2_928)/3:end));


%Merge
PercFirstHalfBaseline=[PercFirstHalfBaseline_927,PercFirstHalfBaseline_928];
PercSecHalfBaseline=[PercSecHalfBaseline_927,PercSecHalfBaseline_928];

PercFirstThirdBaseline=[PercFirstThirdBaseline_927,PercFirstThirdBaseline_928];
PercSecThirdBaseline=[PercSecThirdBaseline_927,PercSecThirdBaseline_928];
PercLastThirdBaseline=[PercLastThirdBaseline_927,PercLastThirdBaseline_928];

PercFirstHalfExposure=[PercFirstHalfExposure_927,PercFirstHalfExposure_928];
PercSecHalfExposure=[PercSecHalfExposure_927,PercSecHalfExposure_928];

PercFirstThirdExposure=[PercFirstThirdExposure_927,PercFirstThirdExposure_928];
PercSecThirdExposure=[PercSecThirdExposure_927,PercSecThirdExposure_928];
PercLastThirdExposure=[PercLastThirdExposure_927,PercLastThirdExposure_928];

PercFirstHalfBaseline2=[PercFirstHalfBaseline2_927,PercFirstHalfBaseline2_928];
PercSecHalfBaseline2=[PercSecHalfBaseline2_927,PercSecHalfBaseline2_928];

PercFirstThirdBaseline2=[PercFirstThirdBaseline2_927,PercFirstThirdBaseline2_928];
PercSecThirdBaseline2=[PercSecThirdBaseline2_927,PercSecThirdBaseline2_928];
PercLastThirdBaseline2=[PercLastThirdBaseline2_927,PercLastThirdBaseline2_928];


PlotErrorBarN_KJ({PercFirstHalfBaseline PercSecHalfBaseline PercFirstThirdBaseline PercSecThirdBaseline PercLastThirdBaseline})
hold on
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods BASELINE')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
ylim([0,12])
%set(gca,'FontSize',14)


PlotErrorBarN_KJ({PercFirstHalfExposure PercSecHalfExposure PercFirstThirdExposure PercSecThirdExposure PercLastThirdExposure})
hold on
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods EXPOSURE')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
ylim([0,12])
%set(gca,'FontSize',14)


PlotErrorBarN_KJ({PercFirstHalfBaseline2 PercSecHalfBaseline2 PercFirstThirdBaseline2 PercSecThirdBaseline2 PercLastThirdBaseline2})
hold on
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods BASELINE 2')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
ylim([0,12])
%set(gca,'FontSize',14)


%% Sleep/Wake proportions 1st, 2nd & 3rd third


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


%M927
maxlimHomecage927_B=max([max(End(Wake927_B)),max(End(REMEpoch927_B)),max(End(SWSEpoch927_B))]);
numpointsHomecage927_B=floor(maxlimHomecage927_B/pas/1E4)+1;

for i=1:numpointsHomecage927_B
    perSleepBaseline_927(i)=FindPercSleep(Wake927_B,REMEpoch927_B,SWSEpoch927_B, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSleepBaseline_927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

maxlimHomecage927_A=max([max(End(Wake927_A)),max(End(REMEpoch927_A)),max(End(SWSEpoch927_A))]);
numpointsHomecage927_A=floor(maxlimHomecage927_A/pas/1E4)+1;

for i=1:numpointsHomecage927_A
    perSleepExposure_927(i)=FindPercSleep(Wake927_A,REMEpoch927_A,SWSEpoch927_A, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSleepExposure_927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

maxlimHomecage927_S=max([max(End(Wake927_S)),max(End(REMEpoch927_S)),max(End(SWSEpoch927_S))]);
numpointsHomecage927_S=floor(maxlimHomecage927_S/pas/1E4)+1;

for i=1:numpointsHomecage927_S
    perSleepBaseline2_927(i)=FindPercSleep(Wake927_S,REMEpoch927_S,SWSEpoch927_S, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSleepBaseline2_927(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


PercSleepFirstHalfBaseline_927=nanmean(perSleepBaseline_927(1:length(perSleepBaseline_927)/2));
PercSleepSecHalfBaseline_927=nanmean(perSleepBaseline_927(length(perSleepBaseline_927)/2:end));

PercSleepFirstThirdBaseline_927=nanmean(perSleepBaseline_927(1:length(perSleepBaseline_927)/3));
PercSleepSecThirdBaseline_927=nanmean(perSleepBaseline_927(length(perSleepBaseline_927)/3:2*length(perSleepBaseline_927)/3));
PercSleepLastThirdBaseline_927=nanmean(perSleepBaseline_927(2*length(perSleepBaseline_927)/3:end));


PercSleepFirstHalfExposure_927=nanmean(perSleepExposure_927(1:length(perSleepExposure_927)/2));
PercSleepSecHalfExposure_927=nanmean(perSleepExposure_927(length(perSleepExposure_927)/2:end));

PercSleepFirstThirdExposure_927=nanmean(perSleepExposure_927(1:length(perSleepExposure_927)/3));
PercSleepSecThirdExposure_927=nanmean(perSleepExposure_927(length(perSleepExposure_927)/3:2*length(perSleepExposure_927)/3));
PercSleepLastThirdExposure_927=nanmean(perSleepExposure_927(2*length(perSleepExposure_927)/3:end));


PercSleepFirstHalfBaseline2_927=nanmean(perSleepBaseline2_927(1:length(perSleepBaseline2_927)/2));
PercSleepSecHalfBaseline2_927=nanmean(perSleepBaseline2_927(length(perSleepBaseline2_927)/2:end));

PercSleepFirstThirdBaseline2_927=nanmean(perSleepBaseline2_927(1:length(perSleepBaseline2_927)/3));
PercSleepSecThirdBaseline2_927=nanmean(perSleepBaseline2_927(length(perSleepBaseline2_927)/3:2*length(perSleepBaseline2_927)/3));
PercSleepLastThirdBaseline2_927=nanmean(perSleepBaseline2_927(2*length(perSleepBaseline2_927)/3:end));


%928
maxlimHomecage928_B=max([max(End(Wake928_B)),max(End(REMEpoch928_B)),max(End(SWSEpoch928_B))]);
numpointsHomecage928_B=floor(maxlimHomecage928_B/pas/1E4)+1;

for i=1:numpointsHomecage928_B
    perSleepBaseline_928(i)=FindPercSleep(Wake928_B,REMEpoch928_B,SWSEpoch928_B, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSleepBaseline_928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

maxlimHomecage928_A=max([max(End(Wake928_A)),max(End(REMEpoch928_A)),max(End(SWSEpoch928_A))]);
numpointsHomecage928_A=floor(maxlimHomecage928_A/pas/1E4)+1;

for i=1:numpointsHomecage928_A
    perSleepExposure_928(i)=FindPercSleep(Wake928_A,REMEpoch928_A,SWSEpoch928_A, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSleepExposure_928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

maxlimHomecage928_S=max([max(End(Wake928_S)),max(End(REMEpoch928_S)),max(End(SWSEpoch928_S))]);
numpointsHomecage928_S=floor(maxlimHomecage928_S/pas/1E4)+1;

for i=1:numpointsHomecage928_S
    perSleepBaseline2_928(i)=FindPercSleep(Wake928_S,REMEpoch928_S,SWSEpoch928_S, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSleepBaseline2_928(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

PercSleepFirstHalfBaseline_928=nanmean(perSleepBaseline_928(1:length(perSleepBaseline_928)/2));
PercSleepSecHalfBaseline_928=nanmean(perSleepBaseline_928(length(perSleepBaseline_928)/2:end));

PercSleepFirstThirdBaseline_928=nanmean(perSleepBaseline_928(1:length(perSleepBaseline_928)/3));
PercSleepSecThirdBaseline_928=nanmean(perSleepBaseline_928(length(perSleepBaseline_928)/3:2*length(perSleepBaseline_928)/3));
PercSleepLastThirdBaseline_928=nanmean(perSleepBaseline_928(2*length(perSleepBaseline_928)/3:end));


PercSleepFirstHalfExposure_928=nanmean(perSleepExposure_928(1:length(perSleepExposure_928)/2));
PercSleepSecHalfExposure_928=nanmean(perSleepExposure_928(length(perSleepExposure_928)/2:end));

PercSleepFirstThirdExposure_928=nanmean(perSleepExposure_928(1:length(perSleepExposure_928)/3));
PercSleepSecThirdExposure_928=nanmean(perSleepExposure_928(length(perSleepExposure_928)/3:2*length(perSleepExposure_928)/3));
PercSleepLastThirdExposure_928=nanmean(perSleepExposure_928(2*length(perSleepExposure_928)/3:end));


PercSleepFirstHalfBaseline2_928=nanmean(perSleepBaseline2_928(1:length(perSleepBaseline2_928)/2));
PercSleepSecHalfBaseline2_928=nanmean(perSleepBaseline2_928(length(perSleepBaseline2_928)/2:end));

PercSleepFirstThirdBaseline2_928=nanmean(perSleepBaseline2_928(1:length(perSleepBaseline2_928)/3));
PercSleepSecThirdBaseline2_928=nanmean(perSleepBaseline2_928(length(perSleepBaseline2_928)/3:2*length(perSleepBaseline2_928)/3));
PercSleepLastThirdBaseline2_928=nanmean(perSleepBaseline2_928(2*length(perBaseline2_928)/3:end));


%Merge
PercSleepFirstHalfBaseline=[PercSleepFirstHalfBaseline_927,PercSleepFirstHalfBaseline_928];
PercSleepSecHalfBaseline=[PercSleepSecHalfBaseline_927,PercSleepSecHalfBaseline_928];

PercSleepFirstThirdBaseline=[PercSleepFirstThirdBaseline_927,PercSleepFirstThirdBaseline_928];
PercSleepSecThirdBaseline=[PercSleepSecThirdBaseline_927,PercSleepSecThirdBaseline_928];
PercSleepLastThirdBaseline=[PercSleepLastThirdBaseline_927,PercSleepLastThirdBaseline_928];

PercSleepFirstHalfExposure=[PercSleepFirstHalfExposure_927,PercSleepFirstHalfExposure_928];
PercSleepSecHalfExposure=[PercSleepSecHalfExposure_927,PercSleepSecHalfExposure_928];

PercSleepFirstThirdExposure=[PercSleepFirstThirdExposure_927,PercSleepFirstThirdExposure_928];
PercSleepSecThirdExposure=[PercSleepSecThirdExposure_927,PercSleepSecThirdExposure_928];
PercSleepLastThirdExposure=[PercSleepLastThirdExposure_927,PercSleepLastThirdExposure_928];

PercSleepFirstHalfBaseline2=[PercSleepFirstHalfBaseline2_927,PercSleepFirstHalfBaseline2_928];
PercSleepSecHalfBaseline2=[PercSleepSecHalfBaseline2_927,PercSleepSecHalfBaseline2_928];

PercSleepFirstThirdBaseline2=[PercSleepFirstThirdBaseline2_927,PercSleepFirstThirdBaseline2_928];
PercSleepSecThirdBaseline2=[PercSleepSecThirdBaseline2_927,PercSleepSecThirdBaseline2_928];
PercSleepLastThirdBaseline2=[PercSleepLastThirdBaseline2_927,PercSleepLastThirdBaseline2_928];



PlotErrorBarN_KJ({PercSleepFirstHalfBaseline PercSleepSecHalfBaseline PercSleepFirstThirdBaseline PercSleepSecThirdBaseline PercSleepLastThirdBaseline})
hold on
ylabel('% Sleep')
xlabel('Periods')
title('Percentage Sleep in different periods BASELINE')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
%ylim([0,12])
%set(gca,'FontSize',14)


PlotErrorBarN_KJ({PercSleepFirstHalfExposure PercSleepSecHalfExposure PercSleepFirstThirdExposure PercSleepSecThirdExposure PercSleepLastThirdExposure})
hold on
ylabel('% Sleep')
xlabel('Periods')
title('Percentage Sleep in different periods EXPOSURE')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
%ylim([0,12])
%set(gca,'FontSize',14)


PlotErrorBarN_KJ({PercSleepFirstHalfBaseline2 PercSleepSecHalfBaseline2 PercSleepFirstThirdBaseline2 PercSleepSecThirdBaseline2 PercSleepLastThirdBaseline2})
hold on
ylabel('% Sleep')
xlabel('Periods')
title('Percentage Sleep in different periods BASELINE 2')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
%ylim([0,12])
%set(gca,'FontSize',14)
