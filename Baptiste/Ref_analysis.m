% Reference wire analysis



imagesc(Spectro{2}, Spectro{3} , log10(Spectro{1})'), axis xy, colorbar, caxis([1.8 3.9])
xlabel('Time (s)')
ylabel('Frequency, Hz')
title('Reference wire spectrum in 0-20 Hz range. 21/12/2022 freely-moving')



Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

Sp_tsd_wake = Restrict(Sp_tsd , Wake);
Sp_tsd_S2 = Restrict(Sp_tsd , and(Sleep , Epoch_01_05));
Sp_tsd_S1  = Restrict(Sp_tsd , and(Sleep , Sleep-Epoch_01_05));


figure
plot(Spectro{3} , nanmean(log10(Data(Sp_tsd_wake))))
hold on 
plot(Spectro{3} , nanmean(log10(Data(Sp_tsd_S2))))
plot(Spectro{3} , nanmean(log10(Data(Sp_tsd_S1))))

xlabel('Frequency, Hz')
ylabel('Power (a.u.)')
title('Reference wire PSD. 21/12/2022 freely-moving')
legend({'Wake', 'S2', 'S1'})
makepretty












Hypnogram_LineColor_BM(19)


load('LFPData/LFP0.mat')
load('StateEpochSB.mat', 'Epoch_01_05','Sleep','Epoch','Wake')
t=Range(LFP);
begin=t(1)/(val*1e4);
endin=t(end)/(val*1e4);

line([begin endin],[thr thr],'linewidth',10,'color','w')
sleepstart=Start(and(ThetaEpoch,Sleep));
sleepstop=Stop(and(ThetaEpoch,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4)/1e4 sleepstop(k)/(val*1e4)],[thr thr],'color','g','linewidth',5);
end
sleepstart=Start(and(Epoch-ThetaEpoch,Sleep));
sleepstop=Stop(and(Epoch-ThetaEpoch,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','r','linewidth',5);
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','b','linewidth',5);
end






