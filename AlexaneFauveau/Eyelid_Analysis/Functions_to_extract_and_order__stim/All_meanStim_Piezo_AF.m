
%% Load the FolderPath 
FolderPath_2Eyelid_Audiodream_AF


%% Choose the parameter
valueStim=2;        
bin1=20;bin2=10000;

nb_stim_wake  = 0;
nb_stim_sleep = 0;
for i = 1:length(FolderName)
    % Load
    cd(FolderName{i});
load('PiezoData_SleepScoring.mat')
load('behavResources.mat', 'TTLInfo')
Stim = Start(TTLInfo.StimEpoch,'s');
load('journal_stim.mat')
StimValue =  cell2mat(journal_stim(:,1));
load('journal_stim.mat')


%%
HighStim=Stim(find(StimValue>valueStim));
stim=ts(HighStim*1E4);
stimt=ts(Range(stim)-1E4);
piezzo=tsd(Range(Piezo_Mouse_tsd),abs(Data(Piezo_Mouse_tsd)-2.5));

%%

[m,s,tps]=mETAverage(Range(Restrict(stimt,SleepEpoch_Piezo)),Range(Piezo_Mouse_tsd),abs(Data(Piezo_Mouse_tsd)-2.5),bin1,bin2);
[mW,sW,tpsW]=mETAverage(Range(Restrict(stimt,WakeEpoch_Piezo)),Range(Piezo_Mouse_tsd),abs(Data(Piezo_Mouse_tsd)-2.5),bin1,bin2);

m_all(:,i) = m;
s_all(:,i) = s;
tps_all(:,i) = tps;

mW_all(:,i) = mW;
sW_all(:,i) = sW;
tpsW_all(:,i) = tpsW;

[h,b]=hist(Data(Restrict(piezzo,SleepEpoch_Piezo)),100);
[hW,bW]=hist(Data(Restrict(piezzo,WakeEpoch_Piezo)),100);

[M,T] = PlotRipRaw(piezzo, Range(Restrict(stimt,SleepEpoch_Piezo),'s')-1, [-bin2*bin1 bin2*bin1]);
try
M_all{i} = M;
T_all{i} = T;
end

%%
% figure, hold on, plot(bW,hW,'r'), plot(b,h,'k')

figure, 
subplot(3,1,1),
plot(Range(piezzo,'s'),Data(piezzo), 'color',[0.7 0.7 0.7])
hold on
plot(Range(Restrict(piezzo,SleepEpoch_Piezo),'s'),Data(Restrict(piezzo,SleepEpoch_Piezo)),'k')
try
    hold on, plot(Range(Restrict(stimt,SleepEpoch_Piezo),'s')-1,0.5,'ro','markerfacecolor','r')
    hold on, plot(Range(Restrict(stimt,WakeEpoch_Piezo),'s')-1,0.5,'bo','markerfacecolor','b')
subplot(3,1,2), area(tpsW/1E3-1,runmean(mW,4),'facecolor','k'), title(num2str(length(Range(Restrict(stimt,WakeEpoch_Piezo)))))
line([0 0],ylim,'color','b')
subplot(3,1,3), area(tps/1E3-1,runmean(m,4),'facecolor','k'), title(num2str(length(Range(Restrict(stimt,SleepEpoch_Piezo)))))
end
line([0 0],ylim,'color','r')

% figure, imagesc(M(:,1),1:length(Range(Restrict(stimt,SleepEpoch_Piezo),'s')),SmoothDec(T,[0.01 20]))
% line([0 0],ylim,'color','w','linewidth',2)


nb_stim_wake = nb_stim_wake + length(Range(Restrict(stimt,WakeEpoch_Piezo)));
nb_stim_sleep = nb_stim_sleep + length(Range(Restrict(stimt,SleepEpoch_Piezo)));

end

%%
for l = 1:length(m_all)
meanm_all(l,1) = nanmean(m_all(l,:));
stdm_all(l,1) = nanstd(m_all(l,:));
end
for l = 1:length(tps_all)
meantps_all(l,1) = nanmean(tps_all(l,:));
stdtps_all(l,1) = nanstd(tps_all(l,:));
end
for l = 1:length(mW_all)
meanmW_all(l,1) = nanmean(mW_all(l,:));
stdmW_all(l,1) = nanstd(mW_all(l,:));
end
for l = 1:length(tpsW_all)
meantpsW_all(l,1) = nanmean(tpsW_all(l,:));
stdtpsW_all(l,1) = nanstd(tpsW_all(l,:));
end

figure,
suptitle('Différence à la moyenne au moment de la stimulation électrique de 2 Volt')
subplot(211)
shadedErrorBar(tpsW_all(:,1),meanmW_all(:,1),stdmW_all(:,1));
line([0 0],ylim,'color','c')
ylabel('Valeur absolue de l écart à la moyenne')
title('Eveil')
subplot(212)
shadedErrorBar(tps_all(:,1),meanm_all(:,1),stdm_all(:,1));
line([0 0],ylim,'color','r')
title('Sommeil')
ylabel('Valeur absolue de l écart à la moyenne')



figure, 
subplot(2,1,1), area(tpsW_all/1E3-1,runmean(mW_all,4),'facecolor','k'), title(num2str(nb_stim_wake))
line([0 0],ylim,'color','b')
subplot(2,1,2), area(tps_all/1E3-1,runmean(m_all,4),'facecolor','k'), title(num2str(nb_stim_sleep))
line([0 0],ylim,'color','r')


