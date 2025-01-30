cd /media/DataMOBSSlSc/SleepScoringMice/M251/21052015

load('B_Low_Spectrum.mat')
subplot(211)
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
xlim([7000 9500])
caxis([4 18])
set(gca,'YTick',[0:10:20])
load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake')
hold on
t=Spectro{2};
    begin=t(1)/1e4;
    endin=t(end)/1e4;

line([begin endin],[19 19],'linewidth',10,'color','w')
sleepstart=Start(REMEpoch);
sleepstop=Stop(REMEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[1 0.2 0.2],'linewidth',5);
end
sleepstart=Start(SWSEpoch);
sleepstop=Stop(SWSEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[0.4 0.5 1],'linewidth',5);
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[0.6 0.6 0.6],'linewidth',5);
end
line([9300 9480],[2 2],'linewidth',5,'color','k')
set(gca,'XTick',[])

load('H_Low_Spectrum.mat')
subplot(212)
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
xlim([7000 9500])
caxis([4 13])
set(gca,'YTick',[0:10:20])
load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake')
hold on
line([begin endin],[19 19],'linewidth',10,'color','w')
sleepstart=Start(REMEpoch);
sleepstop=Stop(REMEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[1 0.2 0.2],'linewidth',5);
end
sleepstart=Start(SWSEpoch);
sleepstop=Stop(SWSEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[0.4 0.5 1],'linewidth',5);
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[0.6 0.6 0.6],'linewidth',5);
end
set(gca,'XTick',[])
