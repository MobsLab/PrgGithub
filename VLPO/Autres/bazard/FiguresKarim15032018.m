%-- 14/03/2018 15:51:02 --%
loadPATHMobs
read_Intan_RHD2000_file
cd('/media/mobsmorty/DataMOBS81/Pre-processing/M675/New proto sleep/?/08032018/M675_baseline_protoWakeStim_08032018_180308_101811')
read_Intan_RHD2000_file
GetBasicInfoRecord
y
GetMouseInfo_Thierry
ExecuteNDM_Thierry
%% check your files
SetCurrentSession
MakeData_Main_Thierry
SleepScoringOBGamma
y
n
200000
y
n
y
n
1
%%load les fichiers nécessaires (DiGInfo2 est le la digitale du laser)
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
load('ChannelsToAnalyse/VLPO.mat')
%Fait le spectre pour le VLPO
LowSpectrumSB([cd filesep],channel,'VLPO');
load('VLPO_Low_Spectrum.mat')
%%Définition des variables nécessaires pour les figures
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
%Nb de stim
Stim=size(Start(TTLEpoch_merged))
%Nb de stim pendant le REM
StimREM=size(Start(and(TTLEpoch_merged,REMEpoch)))
%Nb de stim pendant le SWS
StimSWS=size(Start(and(TTLEpoch_merged,SWSEpoch)))
%Nb de stim pendant Wake
StimWAKE=size(Start(and(TTLEpoch_merged,Wake)))
%Matrice contenant les 4 valeurs précédentes
MStim=[Stim StimREM StimSWS StimWAKE]
load('LFPData/LFP14.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
%load les fichiers nécessaires (DiGInfo2 est le la digitale du laser)
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
load('ChannelsToAnalyse/VLPO.mat')
%Fait le spectre pour le VLPO
LowSpectrumSB([cd filesep],channel,'VLPO');
load('VLPO_Low_Spectrum.mat')
%%Définition des variables nécessaires pour les figures
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
load('LFPData/LFP14.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
load('LFPData/LFP1.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
load('LFPData/LFP1.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 1800, 0, 1);
load('LFPData/LFP1.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 800, 0, 1);
load('LFPData/LFP1.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 1800, 0, 1);
load('LFPData/LFP6.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 1800, 0, 1);
load('LFPData/LFP6.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
load('LFPData/LFP1.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
load('LFPData/LFP1.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 1800, 0, 1);
load('LFPData/LFP2.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
load('LFPData/LFP14.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
load('LFPData/LFP2.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);
[M,T] = PlotRipRaw(LFP, events, 500, 0, 1);
[M,T] = PlotRipRaw(LFP, events, 500);
[M,T] = PlotRipRaw(LFP, events, 5000);
load('H_Low_Spectrum.mat')
edit AverageSpectrogram.m
[M,S,t]=AverageSpectrogram(tsd(Spectro{1},Spectro{3}),Spectro{3},events,10,1000);
figure, imagesc(Spectro{1})
[M,S,t]=AverageSpectrogram(tsd(Spectro{2},Spectro{1}),Spectro{3},events,10,1000);
figure, imagesc(Spectro{2},Spectro{3},Spectro{1})
figure, imagesc(Spectro{2},Spectro{3},Spectro{1}')
[M,S,t]=AverageSpectrogram(tsd(Spectro{2},Spectro{1}),Spectro{3},events,10,1000);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2},Spectro{1}),ts(Spectro{3}),events,10,1000);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2},Spectro{1}),ts(Spectro{3}),ts(events*1E4),10,1000);
events
figure, imagesc(Spectro{2},Spectro{3},Spectro{1}')
[M,S,t]=AverageSpectrogram(tsd(Spectro{3},Spectro{1}),ts(Spectro{2}),ts(events*1E4),10,1000);
[M,S,t]=AverageSpectrogram(tsd(Spectro{3},Spectro{1}'),ts(Spectro{2}),ts(events*1E4),10,1000);
figure, imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1})')
axis xy
[M,S,t]=AverageSpectrogram(tsd(Spectro{3}*1E4,Spectro{1}'),ts(Spectro{2}),ts(events*1E4),10,1000);
[M,S,t]=AverageSpectrogram(tsd(Spectro{3}*1E4,Spectro{1}'),ts(Spectro{2}),ts(events(1:2)*1E4),10,1000);
hold on, line([events events],ylim,'color','k')
figure, plot(Range(LFP,'s'),Data(LFP)
figure, plot(Range(LFP,'s'),Data(LFP))
hold on, line([events events],ylim,'color','k')
load('/media/mobsmorty/DataMOBS81/Pre-processing/M675/21022018/M675_OptoStim20Hz_21022018_180221_101353/LFPData/LFP14.mat')
LFPv=LFP;
load('/media/mobsmorty/DataMOBS81/Pre-processing/M675/21022018/M675_OptoStim20Hz_21022018_180221_101353/LFPData/LFP1.mat')
LFPp=LFP;
figure, plot(Range(LFPp,'s'),Data(LFPp))
hold on, plot(Range(LFPV,'s'),Data(LFPv)+3000,'K')
hold on, plot(Range(LFPv,'s'),Data(LFPv)+3000,'K')
yl=ylim;
hold on, line([events events],yl,'color','r')
load('VLPO_Low_Spectrum.mat')
figure, imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1})'), axis xy
hold on, line([events events],yl,'color','r')
[M,S,t]=AverageSpectrogram(tsd(Spectro{3}*1E4,Spectro{1}'),ts(Spectro{2}),ts(events(1:2)*1E4),100,100);
[M,S,t]=AverageSpectrogram(tsd(Spectro{3}*1E4,Spectro{1}'),Spectro{2},ts(events(1:2)*1E4),100,100);
size(Spectro{2})
size(Spectro{3})
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,Spectro{1}'),Spectro{3},ts(events(1:2)*1E4),100,100);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,Spectro{1}),Spectro{3},ts(events(1:2)*1E4),100,100);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,Spectro{1}),Spectro{3},ts(events(1:2)*1E4),1000,100);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events(1:2)*1E4),1000,100);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),1000,100);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),1000,1000);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),1000,300);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),1000,100);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),1000,200);
SpectroV=Spectro;
load('PFCx_deep_Low_Spectrum.mat')
SpectroP=Spectro;
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),1000,200);
load('B_High_Spectrum.mat')
SpectroBh=Spectro;
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),1000,200);
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),500,200);
load('Bulb_deep_Low_Spectrum.mat')
SpectroBl=Spectro;
[M,S,t]=AverageSpectrogram(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(events*1E4),500,200);
[M,S,t]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},ts(events*1E4),500,200);
[Mv,Sv,tv]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},ts(events*1E4),500,300);
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},ts(events*1E4),500,300);
hold on, line([0 30],[10 10],'linewidth',5)
load('dHPC_deep_Low_Spectrum.mat')
SpectroHl=Spectro;
[Mhl,Shl,thl]=AverageSpectrogram(tsd(SpectroHl{2}*1E4,10*log10(SpectroHl{1})),SpectroHl{3},ts(events*1E4),500,300);
hold on, line([0 30],[10 10],'linewidth',5)
load('SleepScoring_OBGamma.mat')
[Mv,Sv,tv]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
[Mv,Sv,tv]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
[Mhl,Shl,thl]=AverageSpectrogram(tsd(SpectroHl{2}*1E4,10*log10(SpectroHl{1})),SpectroHl{3},Restrict(ts(events*1E4),REMEpoch),500,300);
hold on, line([0 30],[10 10],'linewidth',5)
[Mhl,Shl,thl]=AverageSpectrogram(tsd(SpectroHl{2}*1E4,10*log10(SpectroHl{1})),SpectroHl{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
hold on, line([0 30],[10 10],'linewidth',5)
[Mhl,Shl,thl]=AverageSpectrogram(tsd(SpectroHl{2}*1E4,10*log10(SpectroHl{1})),SpectroHl{3},Restrict(ts(events*1E4),Wake),500,300);
[Mv,Sv,tv]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
[Mv,Sv,tv]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),Wake),500,300);
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBulb{1})),SpectroBl{3},Restrict(ts(events*1E4),REMEpoch),500,300);
figure, plot(Range(LFPp,'s'),Data(LFPp))
hold on, plot(Range(Restrict(LFPp,REMEpoch),'s'),Data(Restrict(LFPp,REMEpoch)),'r')
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),Wake),500,300);
[Mv,Sv,tv]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),Wake),500,300);