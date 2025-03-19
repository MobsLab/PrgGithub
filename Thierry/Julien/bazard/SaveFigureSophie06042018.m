pf = mean(Spectro{1},1)
freq = SpectroH{3};
plot(freq,freq.*pf)
clear all
load('PFCx_deep_Low_Spectrum.mat')
sptsd = tsd(Spectro{2}*1e4, Spectro{1});
figure
imagesc(Data(sptsd))
imagesc(log(Data(sptsd)'))
axis xy
plot(mean(Data(Restrict(sptsd,)))
load('SleepScoring_OBGamma.mat')
plot(mean(Data(Restrict(sptsd,REMEpoch)))
plot(mean(Data(Restrict(sptsd,REMEpoch))))
plot(Spectro{3},mean(Data(Restrict(sptsd,REMEpoch))))
hold on
plot(Spectro{3},mean(Data(Restrict(sptsd,SWSEpoch))))
plot(Spectro{3},mean(Data(Restrict(sptsd,Wake))))
load('HPC_Low_Spectrum.mat')
load('H_Low_Spectrum.mat')
sptsd = tsd(Spectro{2}*1e4, Spectro{1});
plot(Spectro{3},mean(Data(Restrict(sptsd,REMEpoch))))
%%%%load des spectrums et variables (avoir fait les spectres avant)
clear all
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
events=Start(TTLEpoch_merged)/1E4;
%%%%%%%%%
%%Pour checker combien de Stilm par période
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
%%%Pour le VLPO
load('VLPO_Low_Spectrum')
SpectroV=Spectro
%%AveargeSpectre Stim REM (début stim en 0)
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
size(SV)
size(mv)
size(MV)
CLF
clf
imagesc(MV)
axis xy
find(Spectro{3}<9&Specotr{3}>6)
find(Spectro{3}<9&Spectro{3}>6)
MV(find(Spectro{3}<9&Spectro{3}>6),:)
lot(mean(MV(find(Spectro{3}<9&Spectro{3}>6),:))
plot(mean(MV(find(Spectro{3}<9&Spectro{3}>6),:)))
size(MV)
Spectrop
Spectro
size(MV)
imagesc(MV)
axis xy
plot(tV,mean(MV(find(Spectro{3}<9&Spectro{3}>6),:)))
hold on
line([0 0],ylim)
sptsd = tsd(Spectro{2}*1e4, Spectro{1});
i=1
[M(i,:),S(i,:),t]=mETAverage(events*1e4,Range(sptsd),Spectro{1}(:,i),500,300);
size(M)
size(S)
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300);
end
events(k)
ETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300)
mETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300)
clear M S
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300);
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300);
end
size(m)
size(M)
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300);
end
end
size(M)
plot(tV,mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))
plot(tV,squueeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
hold on
plot(tV,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))'))
plot(tV,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))))
plot(tV,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth';3)
plot(tV,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
clf
plot(tV,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
plot(tV,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))))
plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
hold on
plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
imagesc(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))))
imagesc(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
clf
imagesc(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
imagesc(t,1:length(events),squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);4.m
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300);
end
end
clear M S
events
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k)*1e4,Range(sptsd),Spectro{1}(:,i),500,300);
end
end
figure
plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
hold on
plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
figure
plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
hold on
plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
figure
imagesc(t,1:length(events),squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
figure
shadedErrorBar(t,Data_Mat,{@mean,@std},'-r',1);
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
figure
shadedErrorBar(t,Data_Mat,{@mean,@std},'-r',1);
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-r',1);
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,Wake);
events = Range(events);
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
figure
plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
hold on
plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,SWSEpoch);
events = Range(events);
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
figure
plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
hold on
plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-b',1);
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-k',1);
figure
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,Wake);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-k',1);
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,SWSEpoch);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-b',1);
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-r',1);
figure
load('dHPC_sup_Low_Spectrum')
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-r',1);
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,Wake);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-k',1);
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,SWSEpoch);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-b',1);
sptsd = tsd(Spectro{2}*1e4, Spectro{1});
figure
plot(Spectro{3},mean(Data(Restrict(sptsd,REMEpoch))))
line([0 0],ylim)
load('dHPC_sup_Low_Spectrum')
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
events=Start(TTLEpoch_merged)/1E4;
figure
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,SWSEpoch);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-b',1);
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-r',1);
events
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
sptsd = tsd(Spectro{2}*1e4, Spectro{1});
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M S
for i=1:length(Spectro{3})
for  k =1:length(events)
[M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
end
end
% figure
% plot(tV,squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:))))
% hold on
% plot(t,nanmean(squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)))),'linewidth',3)
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-r',1);
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-k',1);
events
clf
plot(Spectro{3},mean(Data(Restrict(sptsd,REMEpoch))))
hold on
line([7 7],ylim)