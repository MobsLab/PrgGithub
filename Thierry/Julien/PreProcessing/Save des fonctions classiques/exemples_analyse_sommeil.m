load('SleepScoring_OBGamma.mat')

% Nombre d'épisodes
length(Start(REMEpoch,'s'))
% durée de chaque épisode
Stop(REMEpoch,'s')-Start(REMEpoch,'s')
% pourcentage de rem sur tout sommeil
sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))
% transitions
[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
%length(Start(aft_cell{1,2}))--> SWS to wake transitions

% make plots
PlotErrorBarN_KJ


LowCohgramSB([cd filesep],14,'VLPO',1,'PFCx')

Cohtsd = tsd(Coherence{2}*1e4,Coherence{1});
Spectsd_PFC = tsd(SingleSpectro.ch2{2}*1e4,SingleSpectro.ch2{1});
Spectsd_VLPO = tsd(SingleSpectro.ch1{2}*1e4,SingleSpectro.ch1{1});

plot(Coherence{3},mean(Data(Restrict(Cohtsd,REMEpoch))))
hold on
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,SWSEpoch))))
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,Wake))))



%%%%%%%%%%% sauvegarde ligne de code Sophie 
%-- 29/01/2018 15:19:57 --%
loadPATHMobs
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/14122017/VLPO-648-optostim-day3_171214_093218/ChannelsToAnalyse/Bulb_deep.mat')
load('InfoLFP.mat')
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/12122017/VLPO-sleep Baseline day3_171212_093259/LFPData/InfoLFP.mat')
GetMouseInfo_Thierry
%-- 29/01/2018 15:33:08 --%
load('makedataBulbeInputs.mat', 'Questions')
load('makedataBulbeInputs.mat', 'answer')
load('ExpeInfo.mat', 'ExpeInfo')
ExecuteNDM_Thierry
GetBasicInfoRecord
read_Intan_RHD2000_file
GetBasicInfoRecord
Y
GetBasicInfoRecord
Y
GenChannelsToAnalyse
load('Bulb_deep.mat')
load('dHPC_rip.mat')
load('dHPC_rip.mat', 'channel')
load('PFCx_deltadeep.mat')
load('PFCx_spindle.mat')
load('VLPO.mat')
load('PFCx_deltadeep.mat')
load('dHPC_rip.mat')
GetMouseInfo_Thierry
load('makedataBulbeInputs.mat')
load('ExpeInfo.mat')
load('ExpeInfo.mat', 'ExpeInfo')
load('ExpeInfo.mat')
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/01122017/VLPO_648_stimopto_day1_171201_101253/LFPData/InfoLFP.mat')
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/01122017/VLPO_648_stimopto_day1_171201_101253/LFPData/InfoLFP.mat', 'InfoLFP')
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/01122017/VLPO_648_stimopto_day1_171201_101253/LFPData/InfoLFP.mat')
GetBasicInfoRecord
y
GetBasicInfoRecord
y
GetBasicInfoRecord
y
ExecuteNDM_Thierry
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/01122017/VLPO_648_stimopto_day1_171201_101253/ExpeInfo.mat')
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/01122017/VLPO_648_stimopto_day1_171201_101253/ExpeInfo.mat', 'ExpeInfo')
SetCurrentSession
load('InfoLFP.mat')
load('InfoLFP.mat', 'InfoLFP')
SetCurrentSession
SetCurrentSession('same')
MakeData_Main_Thierry
load('makedataBulbeInputs.mat')
if not(exist('spk') & exist('doaccelero') & exist('dodigitalin') )
spk=strcmp(answer{1},'yes');
doaccelero=strcmp(answer{2},'yes');
dodigitalin=strcmp(answer{3},'yes');
end
load('LFPData/InfoLFP.mat')
if exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])==0
MakeData_LFP
end
exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])==0
MakeData_LFP
foldername = pwd;
foldername(end+1) = filesep;
disp(' '); disp('LFP Data')
load([foldername 'LFPData/InfoLFP.mat'], 'InfoLFP');
length(InfoLFP.channel)
i=1
~exist(['LFPData/LFP' num2str(InfoLFP.channel(i)) '.mat'],'file')
['LFPData/LFP' num2str(InfoLFP.channel(i)) '.mat']
exist(['LFPData/LFP' num2str(InfoLFP.channel(i)) '.mat'],'file')
exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
clear
pwd
load('makedataBulbeInputs.mat')
if not(exist('spk') & exist('doaccelero') & exist('dodigitalin') )
spk=strcmp(answer{1},'yes');
doaccelero=strcmp(answer{2},'yes');
dodigitalin=strcmp(answer{3},'yes');
end
load('LFPData/InfoLFP.mat')
exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat']
%-- 30/01/2018 16:17:04 --%
loadPATHMobs
load('makedataBulbeInputs.mat')
if not(exist('spk') & exist('doaccelero') & exist('dodigitalin') )
spk=strcmp(answer{1},'yes');
doaccelero=strcmp(answer{2},'yes');
dodigitalin=strcmp(answer{3},'yes');
end
load('LFPData/InfoLFP.mat')
exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
load('LFPData/InfoLFP.mat')
if exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])==0
MakeData_LFP
end
foldername = pwd;
foldername(end+1) = filesep;
%load InfoLFP
disp(' '); disp('LFP Data')
load([foldername 'LFPData/InfoLFP.mat'], 'InfoLFP');
i=1
~exist(['LFPData/LFP' num2str(InfoLFP.channel(i)) '.mat'],'file')
LFP_temp = GetLFP(InfoLFP.channel(i));
cleare
clear
SetCurrentSession
MakeData_Main_Thierry
LFP_temp = GetLFP(InfoLFP.channel(i));
InfoLFP.channel(i)
read_Intan_RHD2000_file
MakeData_Main_Thierry
disp(['loading and saving LFP' num2str(InfoLFP.channel(i)) ' in LFPData...']);
LFP_temp = GetLFP(InfoLFP.channel(i));
i=2
LFP_temp = GetLFP(InfoLFP.channel(i));
SetCurrentSession
MakeData_Main_Thierry
SetCurrentSession
MakeData_Main_Thierry
keyboard
SetCurrentSession
MakeData_Main_Thierry
MakeData_Digin
MakeData_LFP
SetCurrentSession
same
'same'
Setcurrentsession
SetCurrentSession
MakeData_Main_Thierry
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/01122017/VLPO_648_stimopto_day1_171201_101253/Not to use/LFP1.mat')
%-- 30/01/2018 18:26:07 --%
loadPATHMobs
SetCurrentSession
MakeData_Main_Thierry
MakeData_Spikes
SleepScoringOBGamma
n
10000
y
n
600000
800000
n
800000
n
700000
y
n
1
edit
load('SleepScoring_OBGamma.mat')
REMEPoch
Start(REMEpoch,'s')
Stop(REMEpoch,'s')
length(Start(REMEpoch,'s'))
Stop(REMEpoch,'s')-Start(REMEpoch,'s')
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s')
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s'),1000)
histogram(Stop(REMEpoch,'s')-Start(REMEpoch,'s'),100)
sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))
[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
length(Start(aft_cell{1,2}))
edit PlotErrorBarN_KJ
LowCohgramSB([cd filesep],14,'VLPO',1,'PFCx')
load('VLPO_PFCx_Low_Coherence.mat')
figure
Coherence
imagesc(Coherence{2},Coherence{3},Coherence{1})
imagesc(Coherence{2},Coherence{3},Coherence{1}')
ax
axis xy
colorbar
Cohtsd = tsd(                LowCohgramSB(filename,chH,'H',chB,'B',1)
)
Cohtsd = tsd(Coherence{2}*1e4,Coherence{1});;
Cohtsd = tsd(Coherence{2}*1e4,Coherence{1});
Range(Cohstd,'h')
Range(Cohtsd,'h')
Coherence
plot(Cohernece{3},mean(Data(Restrict(Cohtsd,REMEpoch))))
plot(Coherence{3},mean(Data(Restrict(Cohtsd,REMEpoch))))
hold on
plot(Coherence{3},mean(Data(Restrict(Cohtsd,SWSEpoch))))
plot(Coherence{3},mean(Data(Restrict(Cohtsd,Wake))))
mean(Data(Restrict(Cohtsd,Wake)))
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,Wake))))
clf
imagesc(Coherence{2},Coherence{3},Coherence{1}')
plot(Coherence{3},mean(Data(Restrict(Cohtsd,REMEpoch))))
imagesc(Coherence{2},Coherence{3},Coherence{1}')
axis xy
hold on
plot(Start(REMEpoch,'s'),15,'x*')
plot(Start(REMEpoch,'s'),15,'w*')
plot(Start(Wak,'s'),15,'k*')
plot(Start(Wake,'s'),15,'k*')
load('H_Low_Spectrum.mat')
figure
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
xlim([9000 95000])
xlim([9000 9500])
ylim([0 20])
plot(Start(Wake,'s'),15,'k*')
plot(Start(Wake,'s'),15,'ko')
plot(Start(Wake,'s'),15,'ko','MarkerSize',15)
plot(Start(Wake,'s'),15,'r.','MarkerSize',15)
colormap gray
plot(Start(Wake,'s'),15,'r.','MarkerSize',15)
plot(Start(REMEpoch,'s'),15,'w*')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
hold on
axis xy
plot(Start(REMEpoch,'s'),15,'w*')
xlim([9000 9500])
load('SleepScoring_OBGamma.mat')
plot(Start(REMEpoch,'s'),15,'k*')
clf
plot(Coherence{3},mean(Data(Restrict(Cohtsd,REMEpoch))))
hold on
plot(Coherence{3},mean(Data(Restrict(Cohtsd,SWSEpoch))))
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,SWSEpoch))))
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,Wake))))
SingleSpectro
Spectsd_PFC = tsd(SingleSpectro.ch2{2}*1e4,SingleSpectro.ch2{1});
Spectsd_VLPO = tsd(SingleSpectro.ch1{2}*1e4,SingleSpectro.ch1{1});
clf
plot(Coherence{3},mean(Data(Restrict(Spectsd_PFC,REMEpoch))))
hold on
plot(Coherence{3},mean(Data(Restrict(Spectsd_VLPO,REMEpoch))))
cl
clf
plot(Coherence{3},mean(Data(Restrict(Spectsd_VLPO,SWSEpoch))))
hold on
plot(Coherence{3},mean(Data(Restrict(Spectsd_VLPO,Wake))))
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_VLPO,Wake)))))
clf
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_VLPO,Wake)))))
hold on
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_VLPO,SWSEpoch)))))
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_VLPO,REMEpoch)))))
legend('Wake','SWS','REM')
clf
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_PFCx,SWSEpoch)))))
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_PFC,SWSEpoch)))))
hold on
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_PFC,REMEpoch)))))
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_PFC,Wake)))))
sum(Stop(Wake,'s')-Start(Wake,'s'))
sum(Stop(Wake,'s')-Start(Wake,'s'))/60
plot(Coherence{3},log(mean(Data(Restrict(Spectsd_PFC,Wake)))))
plot(Coherence{3},log(nanmean(Data(Restrict(Spectsd_PFC,Wake)))))
plot(Coherence{3},log((Data(Restrict(Spectsd_PFC,Wake)))))
clf
load('/media/mobsmorty/dataMOBS70/Souris 648-TG108/29112017/VLPO-648-baseline1_171129_090338/LFPData/DigInfo1.mat')
plot(Range(DigTSD),Data(DIgTSD))
plot(Range(DigTSD),Data(DigTSD))