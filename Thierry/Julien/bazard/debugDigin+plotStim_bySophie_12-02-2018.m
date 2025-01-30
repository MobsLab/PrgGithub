loadPATHMobs
clear all
SetCurrentSession
disp('Get INTAN DigitalInput')
chanDig=eval(answerdigin{1});
clear a
if not(exist('LFPData/DigInfo1.mat'))
load('makedataBulbeInputs.mat')
disp('Get INTAN DigitalInput')
chanDig=eval(answerdigin{1});
clear a
if not(exist('LFPData/DigInfo1.mat'))
not(exist('LFPData/DigInfo1.mat'))
load('LFPData/InfoLFP.mat')
load(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
Tmax=max(Range(LFP,'s'));
LongFile=Tmax>3600;
LongFile
disp('progressive loading')
DigIN=[];TimeIN=[];
tt=1
disp(num2str(tt/ceil(Tmax/1000)))
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1000*tt,Tmax)]) ;
figure
plot(LFP_temp)
plot(LFP_temp(1,:))
plot(LFP_temp(:,2))
plot(LFP_temp(:,1),LFP_temp(:,2))
size(LFP_temp)
for tt=1:ceil(Tmax/1000)
disp(num2str(tt/ceil(Tmax/1000)))
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
LFP_temp(end-20000:end,:)=[];
LFP_temp=LFP_temp(1:16:end,:);
DigIN=[DigIN;LFP_temp(:,2)];
TimeIN=[TimeIN;LFP_temp(:,1)];
end
plot(TimeIN,DigIN)
DigINSave=DigIN;
answerdigin
2⁸
2^8
answerdigin{2} = '7'
answerdigin{2} = '8'
DigOUT=[];
for k=0:15
a(k+1)=2^k-0.1;
end
for k=eval(answerdigin{2}):-1:1
DigOUT(k,:)=double(DigIN>a(k));
DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
end
k
answerdigin{2} = '7'
DigIN=DigINSave;
for k=eval(answerdigin{2}):-1:1
DigOUT(k,:)=double(DigIN>a(k));
DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
end
k
2^7
eval(answerdigin{2})
DigOUT(k,:)=double(DigIN>a(k));
DigOUT=[];
for k=0:15
a(k+1)=2^k-0.1;
end
for k=eval(answerdigin{2}):-1:1
DigOUT(k,:)=double(DigIN>a(k));
DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
end
k
DigOUT=[];
for k=0:15
a(k+1)=2^k-0.1;
end
k
eval(answerdigin{2})
k=eval(answerdigin{2})
DigOUT(k,:)=double(DigIN>a(k));
a(7)
a(8)
a(9)
answerdigin{2} = '8'
DigOUT=[];
DigOUT(k,:)=double(DigIN>a(k));
DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
plot(timestamps)
plot(TimeIN)
plot(TimeIN(1:1000))
plot(TimeIN(1:10000))
plot(TimeIN(1:1000))
plot(TimeIN(1:10000))
plot(TimeIN(1:100000))
plot(TimeIN(1:1000000))
plot(LFP_temp(:,1))
TimeIN(end-10:end)
TimeIN(1:10)
plot(diff(TimeIN))
20000*1000*16
20000*1000/16
tt=1
disp(num2str(tt/ceil(Tmax/1000)))
% we load 1001 seconds of data
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
plot(LFP_temp(:,1),LFP_temp(:,2))
LFP_temp(end-20000:end,:)=[];
plot(LFP_temp(:,1),LFP_temp(:,2))
hold on
tt=2
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
plot(LFP_temp(:,1),LFP_temp(:,2))
plot(LFP_temp(:,1)+1,LFP_temp(:,2))
DigIN=[];TimeIN=[];
for tt=1:ceil(Tmax/1000)
disp(num2str(tt/ceil(Tmax/1000)))
% we load 1001 seconds of data
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
% just keep 1000 seconds of data - there are sometimes problems
% at the end
LFP_temp(end-20001:end,:)=[];
LFP_temp=LFP_temp(1:16:end,:);
DigIN=[DigIN;LFP_temp(:,2)];
TimeIN=[TimeIN;LFP_temp(:,1)];
end
DigIN=[];TimeIN=[];
for tt=1:ceil(Tmax/1000)
disp(num2str(tt/ceil(Tmax/1000)))
% we load 1001 seconds of data
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
% just keep 1000 seconds of data - there are sometimes problems
% at the end
LastToKeep = find(LFP_temp(:,1)==min(1000*tt,Tmax))-1;
LFP_temp(LastToKeep:end,:)=[];
LFP_temp=LFP_temp(1:16:end,:);
DigIN=[DigIN;LFP_temp(:,2)];
TimeIN=[TimeIN;LFP_temp(:,1)];
end
end
plot(TimeIN,DigIN)
LastToKeep
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
LastToKeep = find(LFP_temp(:,1)==min(1000*tt,Tmax))-1;
LastToKeep
max(LFP_temp(:,1))
1000*tt
find(LFP_temp(:,1)==min(1000*tt,Tmax))
find(LFP_temp(:,1)>min(1000*tt,Tmax),1,'first')
DigIN=[];TimeIN=[];
for tt=1:ceil(Tmax/1000)
disp(num2str(tt/ceil(Tmax/1000)))
% we load 1001 seconds of data
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
% just keep 1000 seconds of data - there are sometimes problems
% at the end
LastToKeep =  find(LFP_temp(:,1)>min(1000*tt,Tmax),1,'first')-1;
LFP_temp(LastToKeep:end,:)=[];
LFP_temp=LFP_temp(1:16:end,:);
DigIN=[DigIN;LFP_temp(:,2)];
TimeIN=[TimeIN;LFP_temp(:,1)];
end
plot(TimeIN,DigIN)
DigOUT=[];
for k=0:15
a(k+1)=2^k-0.1;
end
for k=eval(answerdigin{2}):-1:1
DigOUT(k,:)=double(DigIN>a(k));
DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
%         save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
end
plot(DigTSD)
plot(Data(DigTSD))
DigIN=[];TimeIN=[];
%         keyboard
for tt=1:ceil(Tmax/1000)
disp(num2str(tt/ceil(Tmax/1000)))
% we load 1001 seconds of data
LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
% just keep 1000 seconds of data - there are sometimes problems
% at the end
LastToKeep =  find(LFP_temp(:,1)>min(1000*tt,Tmax),1,'first')-1;
LFP_temp(LastToKeep:end,:)=[];
LFP_temp=LFP_temp(1:16:end,:);
DigIN=[DigIN;LFP_temp(:,2)];
TimeIN=[TimeIN;LFP_temp(:,1)];
end
plot(TimeIN,DigIN)
DigINSave=DigIN;
DigOUT=[];
for k=0:15
a(k+1)=2^k-0.1;
end
for k=eval(answerdigin{2}):-1:1
DigOUT(k,:)=double(DigIN>a(k));
DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
end
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo1.mat')
plot(Range(DigTSD,'s'),Data(DigTSD))
edit TrackingSleepStimulation_IRComp_ObjectOrientated.m
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo2.mat')
plot(Range(DigTSD,'s'),Data(DigTSD))
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo3.mat')
figure
plot(Range(DigTSD,'s'),Data(DigTSD))
title('3')
title('2')
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo4.mat')
figure
plot(Range(DigTSD,'s'),Data(DigTSD))
title('4')
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo5.mat')
figure
plot(Range(DigTSD,'s'),Data(DigTSD))
title('5')
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo6.mat')
figure
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo6.mat')
re-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo6.mat')
>> plot(Range(DigTSD,'s'),Data(DigTSD
plot(Range(DigTSD,'s'),Data(DigTSD))
clf
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo4.mat')
plot(Range(DigTSD,'s'),Data(DigTSD))
DigIN=DigINSave;
MaxVal = max(DigIN);
MaxVal
a
a>MaxVal
a<MaxVal
find(a<MaxVal)
answerdigin
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo2.mat')
figure
plot(Range(DigTSD,'s'),Data(DigTSD))
plot(Range(DigTSD,'s'),Data(DigTSD),'.')
xlim([400 800])
xlim([400 800]+400)
TTLEpoch = thresholdEpoch(DigTSD,0.99,'Direction','Above')
edit BulbSleepScript
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above')
Start(TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above'))
Start(TTLEpoch)
clf
plot(Range(DigTSD,'s'),Data(DigTSD),'.')
hold on
plot(Range(Restrict(DigTSD,TTLEpoch),'s'),Data(Restrict(DigTSD,TTLEpoch)),'r.')
clf
median(diff(Start(TTLEpoch,'s')))
hist(diff(Start(TTLEpoch,'s')))
hist(diff(Start(TTLEpoch,'s')),1000)
del= diff(Start(TTLEpoch,'s');
del= diff(Start(TTLEpoch,'s'));
clf
plot(del)
del(del>100)=[];
hist(del)
hist(del,100)
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
clf
plot(Range(Restrict(DigTSD,TTLEpoch),'s'),Data(Restrict(DigTSD,TTLEpoch)),'r.')
edit GetGammaThresh.m
edit FindGammaEpoch.m
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,10e4);
plot(Range(Restrict(DigTSD,TTLEpoch),'s'),Data(Restrict(DigTSD,TTLEpoch)),'r.')
plot(Range(Restrict(DigTSD,TTLEpoch_merged),'s'),Data(Restrict(DigTSD,TTLEpoch_merged)),'r.')
Start(TTLEpoch_merged)
size(Start(TTLEpoch_merged))
load('SleepScoring_OBGamma.mat','REMEpoch')
size(Start(and(TTLEpoch_merged,REMEpoch)))
load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Wake')
size(Start(and(TTLEpoch_merged,Wake)))
size(Start(and(TTLEpoch_merged,SWSEpoch)))
Start(and(TTLEpoch,LittleEpoch))
k = 1
LittleEpoch = subset(TTLEpoch_merged,k);
Start(and(TTLEpoch,LittleEpoch))
diff(Start(and(TTLEpoch,LittleEpoch)))
hist(diff(Start(and(TTLEpoch,LittleEpoch))))
median(diff(Start(and(TTLEpoch,LittleEpoch))))
round(median(diff(Start(and(TTLEpoch,LittleEpoch),'s'))))
(median(diff(Start(and(TTLEpoch,LittleEpoch),'s'))))
1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s'))))
for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
end
plot(Freq)
for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
plot(Time_Stim,Freq_Stim))
plot(Time_Stim/1e4,Freq_Stim)
plot((Time_Stim/60)/1e4,Freq_Stim)
set(gca,'XTick',[0:10:500])
clf
hist(diff(Time_Stim))
hist(diff(Time_Stim/1e4))
plot((Time_Stim/60)/1e4,Freq_Stim)
plot((Time_Stim/60)/1e4,Freq_Stim,'*')
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/LFP14.mat')
LowSpectrumSB([cd filesep],14,'VLPO');
load('VLPO_Low_Spectrum.mat')
Spectro
imagesc(Spectro{2},Spectro{3},log(Spectro{1}))
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
hold on
plot((Time_Stim)/1e4,Freq_Stim,'*')
Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}'));
Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
Freq_Stim
find(Freq_Stim == 4)
LittleEpoch = subset(TTLEpoch_merged,k);
find(Freq_Stim == 4)
LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == 4));
plot(nanmean(Sptsd,LittleEpoch))
plot(nanmean(Data(Restrict(Sptsd,LittleEpoch))))
cl
clf
plot(nanmean(Data(Restrict(Sptsd,LittleEpoch))))
for h = [2,4,10]
LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
plot(nanmean(Data(Restrict(Sptsd,LittleEpoch)))), hold on
end
LittleEpoch = subset(TTLEpoch_merclged,find(Freq_Stim == 4));
clf
for h = [2,4,10]
LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
plot(nanmean(Data(Restrict(Sptsd,LittleEpoch)))), hold on
end
legend('2','4','10')
clf
for h = [2,4,10]
LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,LittleEpoch)))), hold on
end
legend('2','4','10')
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,LittleEpoch)))), hold on
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,REMEpoch)))), hold on
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/LFPData/DigInfo2.mat')
load('/media/mobsmorty/DataMOBS81/Pre-processing/M647/22012018/VLPO-647-675-baseline_180122_092958/ChannelsToAnalyse/VLPO.mat')
load('LFPData/DigInfo2.mat')function tsa = tsd(t, Data, varargin)
load('ChannelsToAnalyse/VLPO.mat')
LowSpectrumSB([cd filesep],channel,'VLPO');
load('VLPO_Low_Spectrum.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
for h = [2,4,10]
LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,LittleEpoch)))), hold on
end