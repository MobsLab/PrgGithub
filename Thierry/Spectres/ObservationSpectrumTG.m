%%ObservationSpectrumTG
%Spectral analysis
%%
load('SleepScoring_Accelero.mat', 'Wake')
load('SleepScoring_Accelero.mat', 'REMEpoch')
load('SleepScoring_Accelero.mat', 'SWSEpoch')

%%%%% Spectres SomatoCx %%%%%%%%%
%load the LFP related to SUP signal
[Sp,t,f]=LoadSpectrumML(4,pwd,'newlow');%calcul spectrum low
StsdSomCxsupL=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL';
oldname = 'Spectrum4.mat';
newname = 'SpectrumSomCxsupL.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

[Sp,t,f]=LoadSpectrumML(4,pwd,'high');%calcul spectrum high
StsdSomCxsupH=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH';
oldname = 'Spectrum4.mat';
newname = 'SpectrumSomCxsupH.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);
%figure, imagesc(t,f,10*log10(Sp')), axis xy

%load the LFP related to DEEP signal 
[Sp,t,f]=LoadSpectrumML(3,pwd,'newlow');%calcul spectrum low
StsdSomCxdeepL=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL';
oldname = 'Spectrum3.mat';
newname = 'SpectrumSomCxdeepL.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

[Sp,t,f]=LoadSpectrumML(3,pwd,'high');%calcul spectrum high
StsdSomCxdeepH=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH';
oldname = 'Spectrum3.mat';
newname = 'SpectrumSomCxdeepH.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);
%figure, imagesc(t,f,10*log10(Sp')), axis xy

%%%%% Spectres PFC %%%%%%%%%%%%%%%%%%%%%
%load the LFP related to SUP signal

[Sp,t,f]=LoadSpectrumML(30,pwd,'newlow');%calcul spectrum low
StsdPFCsupL=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL';
oldname = 'Spectrum30.mat';
newname = 'SpectrumPFCsupL.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);
%figure, imagesc(t,f,10*log10(Sp')), axis xy
%Stsd=tsd(Spectro{2}*1E4,Spectro{1});f=Spectro{3};
%load the LFP related to deep signal

[Sp,t,f]=LoadSpectrumML(30,pwd,'high');%calcul spectrum high
StsdPFCsupH=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH';
oldname = 'Spectrum30.mat';
newname = 'SpectrumPFCsupH.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);
%figure, imagesc(t,f,10*log10(Sp')), axis xy
%Stsd=tsd(Spectro{2}*1E4,Spectro{1});f=Spectro{3};
%load the LFP related to deep signal

%load the LFP related to DEEP signal
[Sp,t,f]=LoadSpectrumML(29,pwd,'newlow');%calcul spectrum low
StsdPFCdeepL=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL';
oldname = 'Spectrum29.mat';
newname = 'SpectrumPFCdeepL.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

[Sp,t,f]=LoadSpectrumML(29,pwd,'high');%calcul spectrum high
StsdPFCdeepH=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH';
oldname = 'Spectrum29.mat';
newname = 'SpectrumPFCdeepH.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);
%figure, imagesc(t,f,10*log10(Sp')), axis xy

%%%%% Spectres HPC %%%%%%%%%%%%%%
%load the LFP related to rip signal
[Sp,t,f]=LoadSpectrumML(5,pwd,'newlow');%calcul spectrum low
StsdHPCripL=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL';
oldname = 'Spectrum5.mat';
newname = 'SpectrumHPCripL.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

[Sp,t,f]=LoadSpectrumML(5,pwd,'high');%calcul spectrum high
StsdHPCripH=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH';
oldname = 'Spectrum5.mat';
newname = 'SpectrumHPCripH.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

%load the LFP related to deep signal
[Sp,t,f]=LoadSpectrumML(7,pwd,'newlow');%calcul spectrum low
StsdHPCdeepL=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL';
oldname = 'Spectrum7.mat';
newname = 'SpectrumHPCdeepL.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

[Sp,t,f]=LoadSpectrumML(7,pwd,'high');%calcul spectrum high
StsdHPCdeepH=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH';
oldname = 'Spectrum7.mat';
newname = 'SpectrumHPCdeepH.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

%%%%% Spectres OB %%%%%%%%%%%%%%
%load the LFP related 
[Sp,t,f]=LoadSpectrumML(19,pwd,'newlow');%calcul spectrum low
StsdOBL=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL';
oldname = 'Spectrum19.mat';
newname = 'SpectrumOBL.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);

[Sp,t,f]=LoadSpectrumML(19,pwd,'high');%calcul spectrum high
StsdOBH=tsd(t*1E4,Sp);
folder = '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH';
oldname = 'Spectrum19.mat';
newname = 'SpectrumOBH.mat';
oldpath = fullfile(folder, oldname);
newpath = fullfile(folder, newname);
status = movefile(oldpath, newpath);
%%


a=2;
figure, 
subplot(1,4,1), hold on,
plot(f,mean(Data(Restrict(StsdOBHM1,Wake))),'k')
plot(f,mean(Data(Restrict(StsdOBHM1,SWSEpoch))),'b')
plot(f,mean(Data(Restrict(StsdOBHM1,REMEpoch))),'r')
subplot(1,4,2), hold on,title(['normalized a=',num2str(a)])
plot(f,f.^a.*mean(Data(Restrict(StsdOBHM1,Wake))),'k')
plot(f,f.^a.*mean(Data(Restrict(StsdOBHM1,SWSEpoch))),'b')
plot(f,f.^a.*mean(Data(Restrict(StsdOBHM1,REMEpoch))),'r')
subplot(1,4,3),hold on, 
plot(f,10*log10(mean(Data(Restrict(StsdOBHM1,Wake)))),'k')
plot(f,10*log10(mean(Data(Restrict(StsdOBHM1,SWSEpoch)))),'b')
plot(f,10*log10(mean(Data(Restrict(StsdOBHM1,REMEpoch)))),'r')
subplot(1,4,4),hold on,
plot(10*log10(f),10*log10(mean(Data(Restrict(StsdOBHM1,Wake)))),'k')
plot(10*log10(f),10*log10(mean(Data(Restrict(StsdOBHM1,SWSEpoch)))),'b')
plot(10*log10(f),10*log10(mean(Data(Restrict(StsdOBHM1,REMEpoch)))),'r')

%
%
i=0;
figure, 
clf, i=i+1;
hold on, plot(f,f.^a.*mean(Data(Restrict(Stsd,Wake))),'r','linewidth',2)
plot(f,f.^a.*mean(Data(Restrict(Stsd,subset(Wake,i)))),'k'), title(num2str(i))

%
Stsd2=Stsd;
f2=f;t2=t;
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataL/Spectrum1.mat')
Stsd=tsd(t*1E4,Sp);

figure, imagesc(t,f,10*log10(Sp')), axis xy

a=2;
figure, 
subplot(1,4,1), hold on,
plot(f,mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,2), hold on,title(['normalized a=',num2str(a)])
plot(f,f.^a.*mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,f.^a.*mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,f.^a.*mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,3),hold on, 
plot(f,10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(f,10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')
subplot(1,4,4),hold on,
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')
%
[Sp,t,f]=LoadSpectrumML(16,pwd,'high');
Stsd=tsd(t*1E4,Sp);
figure, imagesc(t,f,10*log10(Sp')), axis xy

a=2;
figure,
subplot(1,4,1), hold on,
plot(f,mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,2), hold on,title(['normalized a=',num2str(a)])
plot(f,f.^a.*mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,f.^a.*mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,f.^a.*mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,3),hold on,
plot(f,10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(f,10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')
subplot(1,4,4),hold on,
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')

%HPC Low
load('H_Low_Spectrum.mat')
Stsd=tsd(Spectro{2}*1E3,Spectro{1});
f=Spectro{3};
a=2;
figure,
a=2;
figure,
subplot(1,4,1), hold on,
plot(f,mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,2), hold on,title(['normalized a=',num2str(a)])
plot(f,f.^a.*mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,f.^a.*mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,f.^a.*mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,3),hold on,
plot(f,10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(f,10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')
subplot(1,4,4),hold on,
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')

% channel=11;
% load('dHPC_rip.mat')
% channel=12;
% save dHPC_deep channel
% channel=17;
% save SomCx_deep channel

%%%%%%%
% Spectro Sophie
% load('SpectrumSomCxsupH.mat')
% imagesc(t,f,log(Sp))
% figure,imagesc(t,f,log(Sp)')
% axis xy
% plot(nanmean(Sp))
% load('/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M5/SpectrumDataH/SpectrumSomCxsupH.mat')
% plot(nanmean(Sp))
% plot(nanmean(log(Sp)))
% plot(nanmean(log(Sp)))
% figure,imagesc(t,f,log(Sp)')
% Sptsd = tsd(t*1e4,log(Sp'));


%OB High
load('B_High_Spectrum.mat')
Stsd=tsd(Spectro{2}*1E4,Spectro{1});f=Spectro{3};
a=2;
figure,
subplot(1,4,1), hold on,
plot(f,mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,2), hold on,title(['normalized a=',num2str(a)])
plot(f,f.^a.*mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,f.^a.*mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,f.^a.*mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,3),hold on,
plot(f,10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(f,10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')
subplot(1,4,4),hold on,
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')

%SOM LFP1 High
[Sp,t,f]=LoadSpectrumML(1,pwd,'high');
Stsd=tsd(t*1E4,Sp);
a=2;
figure,
subplot(1,4,1), hold on,
plot(f,mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,2), hold on,title(['normalized a=',num2str(a)])
plot(f,f.^a.*mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,f.^a.*mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,f.^a.*mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,3),hold on,
plot(f,10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(f,10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')
subplot(1,4,4),hold on,
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')

%HPC High
[Sp,t,f]=LoadSpectrumML(5,pwd,'high');
Stsd=tsd(t*1E4,Sp);
a=2;
figure,
subplot(1,4,1), hold on,
plot(f,mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,2), hold on,title(['normalized a=',num2str(a)])
plot(f,f.^a.*mean(Data(Restrict(Stsd,Wake))),'k')
plot(f,f.^a.*mean(Data(Restrict(Stsd,SWSEpoch))),'b')
plot(f,f.^a.*mean(Data(Restrict(Stsd,REMEpoch))),'r')
subplot(1,4,3),hold on,
plot(f,10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(f,10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')
subplot(1,4,4),hold on,
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,Wake)))),'k')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'b')
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'r')

%%%%%%SleepStages
%%percentage /total session
SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(Wake,SWSEpoch,REMEpoch);
percWAKE_totSess = SleepStagePerc_totSess(1,1); percWAKE_totSess(percWAKE_totSess==0)=NaN;
percSWS_totSess = SleepStagePerc_totSess(2,1); percSWS_totSess(percSWS_totSess==0)=NaN;
percREM_totSess = SleepStagePerc_totSess(3,1); percREM_totSess(percREM_totSess==0)=NaN;
%%percentage /total sleep

SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(Wake,SWSEpoch,REMEpoch);
percREM_totSleep = SleepStagePerc_totSleep(3,1); percREM_totSleep(percREM_totSleep==0)=NaN;

figure, 
PlotErrorBarN_KJ({percWAKE_totSess percSWS_totSess percREM_totSess},'newfig',0,'paired',0);
xticks([1:3]); xticklabels({'Wake','NREM','REM'})
ylabel('% (/ total session)')
ylim([0 105])
makepretty

%%total duration of stages
        TOTsleep = or(SWSEpoch,REMEpoch); %%define all sleep
        %%total duration for all sleep session
        [durTOTsleep,durTTOTsleep]=DurationEpoch(TOTsleep);
        totDur_TOTsleep = (durTTOTsleep/1e4)/3600; totDur_TOTsleep(totDur_TOTsleep==0)=NaN; %%total duration in sec (and convertion in hour)
        [durSWS,durTSWS]=DurationEpoch(SWSEpoch); totDur_SWS = (durTSWS/1e4)/3600; totDur_SWS(totDur_SWS==0)=NaN;
        [durREM,durTREM]=DurationEpoch(REMEpoch); totDur_REM = (durTREM/1e4)/3600; totDur_REM(totDur_REM==0)=NaN;
        [durWAKE,durTWAKE]=DurationEpoch(Wake); totDur_WAKE = (durTWAKE/1e4)/3600; totDur_WAKE(totDur_WAKE==0)=NaN;
        
%%latency
        [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_v2_MC(Wake,SWSEpoch,REMEpoch,1,1);
        firstSWS_basal= (tpsFirstSWS/1e4)/3600; firstSWS_basal(firstSWS_basal==0)=NaN; firstSWS_basal(firstSWS_basal<0)=NaN;
        firstREM_basal= (tpsFirstREM/1e4)/3600; firstREM_basal(firstREM_basal==0)=NaN; firstREM_basal(firstREM_basal<0)=NaN;

%%%% figures Sleep
figure, 
subplot(331), PlotErrorBarN_KJ({percWAKE_totSess percSWS_totSess percREM_totSess},'newfig',0,'paired',0);
xticks([1:3]); xticklabels({'Wake','NREM','REM'})
ylabel('% (/ total session)')
ylim([0 105])
makepretty

subplot(332), PlotErrorBarN_KJ({percSWS_totSleep percREM_totSleep},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'NREM','REM'})
ylabel('% (/ total sleep)')
ylim([0 105])
makepretty

subplot(334), PlotErrorBarN_KJ({totDur_WAKE totDur_TOTsleep},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'Wake','Total sleep'})
ylabel('Total duration (hour)')
ylim([0 15])
makepretty

subplot(335), PlotErrorBarN_KJ({totDur_SWS totDur_REM},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'NREM','REM'})
ylabel('Total duration (hour)')
ylim([0 15])
makepretty

% subplot(336), PlotErrorBarN_KJ({durWAKE_totSess durSWS_totSess durREM_totSess},'newfig',0,'paired',0);
% xticks([1:3]); xticklabels({'Wake','NREM','REM'})
% ylabel('Mean duration of bouts (s)')
% 
% subplot(337), PlotErrorBarN_KJ({NumWAKE_totSess NumSWS_totSess NumREM_totSess},'newfig',0,'paired',0);
% xticks([1:3]); xticklabels({'Wake','NREM','REM'})
% ylabel('Numbers of bouts')
% ylim([0 1750])
% makepretty

subplot(338), PlotErrorBarN_KJ({firstSWS_basal firstREM_basal},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'NREM','REM'})
ylabel('Latency (hour)')
% ylim([0 30000])
makepretty


% A trier phase gamma with theta
[Sp,t,f]=LoadSpectrumML(5,pwd,'high');
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(Restrict(LFP,subset(REMEpoch,1)),subset(REMEpoch,1)),Sp,t,f,[5 10],1024);
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(Restrict(LFP,subset(REMEpoch,1)),subset(REMEpoch,1)),f.^2.*Sp,t,f,[5 10],1024);
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,2)),f.^2.*Sp,t,f,[5 10],1024);
caxis
caxis([50000 1000000])
caxis([50000 4000000])
caxis([100000 4000000])
caxis([1000000 4000000])
caxis([1000000 3000000])

[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,2)),f.^2.*Sp,t,f,[5 10],30);
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,1:4)),f.^2.*Sp,t,f,[5 10],30);
caxis
caxis([1000000 3000000])
caxis([1000000 1000000])
caxis([1000000 2000000])
caxis([1000000 1500000])
caxis([500000 1500000])
%%%%%
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,1:20)),f.^2.*Sp,t,f,[5 10],30);
caxis([500000 1500000])
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/ChannelsToAnalyse/dHPC_deep.mat')
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,1:20)),f.^2.*Sp,t,f,[5 10],30);
caxis([500000 1500000])
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/LFPData/LFP15.mat')
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/LFPData/LFP7.mat')
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,1:20)),f.^2.*Sp,t,f,[5 10],30);
caxis([500000 1500000])
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/LFPData/LFP15.mat')
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,1:20)),f.^2.*Sp,t,f,[5 10],30);
caxis([500000 1500000])
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/LFPData/LFP5.mat')
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/SpectrumDataH/Spectrum1.mat')
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,1:20)),f.^2.*Sp,t,f,[5 10],30);
caxis([500000 1500000])
caxis([100000 500000])
caxis([50000 500000])
caxis([100000 500000])
caxis([200000 500000])
caxis([200000 400000])
caxis([200000 800000])
caxis([200000 600000])
caxis([200000 500000])
load('/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343/LFPData/LFP19.mat')
[P,f,VBinnedPhase]=PrefPhaseSpectrum(Restrict(LFP,subset(REMEpoch,1:20)),f.^2.*Sp,t,f,[5 10],30);
caxis([200000 500000])
%-- 12/09/2024 18:01:33 --%
load('SleepScoring_Accelero.mat', 'Wake')
load('SleepScoring_Accelero.mat', 'REMEpoch')
load('SleepScoring_Accelero.mat', 'SWSEpoch')
load('H_Low_Spectrum.mat')
[Sp,t,f]=LoadSpectrumML(1,pwd,'newlow');
[Sp,t,f]=LoadSpectrumML(1,pwd,'high');