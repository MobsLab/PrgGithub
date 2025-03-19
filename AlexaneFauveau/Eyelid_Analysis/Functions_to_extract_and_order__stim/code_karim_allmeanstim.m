
load('PiezoData_SleepScoring.mat')
load('behavResources.mat', 'TTLInfo')
Stim = Start(TTLInfo.StimEpoch,'s');
load('journal_stim.mat')
StimValue =  cell2mat(journal_stim(:,1));
load('journal_stim.mat')

%%
thStim=1.5;
bin1=20;bin2=10000;

%%
HighStim=Stim(find(StimValue>thStim));
stim=ts(HighStim*1E4);
stimt=ts(Range(stim)-1E4);
piezzo=tsd(Range(Piezo_Mouse_tsd),abs(Data(Piezo_Mouse_tsd)-2.5));

%%

[m,s,tps]=mETAverage(Range(Restrict(stimt,SleepEpoch_Piezo)),Range(Piezo_Mouse_tsd),abs(Data(Piezo_Mouse_tsd)-2.5),bin1,bin2);
[mW,sW,tpsW]=mETAverage(Range(Restrict(stimt,WakeEpoch_Piezo)),Range(Piezo_Mouse_tsd),abs(Data(Piezo_Mouse_tsd)-2.5),bin1,bin2);

[h,b]=hist(Data(Restrict(piezzo,SleepEpoch_Piezo)),100);
[hW,bW]=hist(Data(Restrict(piezzo,WakeEpoch_Piezo)),100);

[M,T] = PlotRipRaw(piezzo, Range(Restrict(stimt,SleepEpoch_Piezo),'s')-1, [-bin2*bin1 bin2*bin1]);


%%


figure, hold on, plot(bW,hW,'r'), plot(b,h,'k')

figure, 
subplot(3,1,1),
plot(Range(piezzo,'s'),Data(piezzo), 'color',[0.7 0.7 0.7])
hold on
plot(Range(Restrict(piezzo,SleepEpoch_Piezo),'s'),Data(Restrict(piezzo,SleepEpoch_Piezo)),'k')
hold on, plot(Range(stimt,'s')-1,0.5,'ro','markerfacecolor','r')
hold on, plot(Range(Restrict(stimt,SleepEpoch_Piezo),'s')-1,0.5,'ro','markerfacecolor','r')
try
    hold on, plot(Range(Restrict(stimt,WakeEpoch_Piezo),'s')-1,0.5,'bo','markerfacecolor','b')

subplot(3,1,2), area(tpsW/1E3-1,runmean(mW,4),'facecolor','k'), title(num2str(length(Range(Restrict(stimt,WakeEpoch_Piezo)))))
line([0 0],ylim,'color','b')
end
subplot(3,1,3), area(tps/1E3-1,runmean(m,4),'facecolor','k'), title(num2str(length(Range(Restrict(stimt,SleepEpoch_Piezo)))))
line([0 0],ylim,'color','r')

figure, imagesc(M(:,1),1:length(Range(Restrict(stimt,SleepEpoch_Piezo),'s')),SmoothDec(T,[0.01 20]))
line([0 0],ylim,'color','w','linewidth',2)

