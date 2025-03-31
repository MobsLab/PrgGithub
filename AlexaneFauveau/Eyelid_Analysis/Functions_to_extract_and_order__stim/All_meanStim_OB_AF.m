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
load('SleepScoring_OBGamma.mat')
load('ChannelsToAnalyse/Bulb_deep.mat','channel')
load([cd,'/LFPData/LFP',num2str(channel)],'LFP');
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=tsd(Range(LFP),H);
load('behavResources.mat', 'TTLInfo')
Stim = Start(TTLInfo.StimEpoch,'s');
load('journal_stim.mat')
StimValue =  cell2mat(journal_stim(:,1));
load('journal_stim.mat')


%%
HighStim=Stim(find(StimValue>valueStim));
stim=ts(HighStim*1E4);
stimt=ts(Range(stim)-1E4);
gamma=tsd(Range(tot_ghi),abs(Data(tot_ghi)-2.5));

%%

[m,s,tps]=mETAverage(Range(Restrict(stimt,Sleep)),Range(tot_ghi),Data(tot_ghi),bin1,bin2);
[mW,sW,tpsW]=mETAverage(Range(Restrict(stimt,Wake)),Range(tot_ghi),Data(tot_ghi),bin1,bin2);

m_all(:,i) = m;
s_all(:,i) = s;
tps_all(:,i) = tps;

mW_all(:,i) = mW;
sW_all(:,i) = sW;
tpsW_all(:,i) = tpsW;

[h,b]=hist(Data(Restrict(gamma,Sleep)),100);
[hW,bW]=hist(Data(Restrict(gamma,Wake)),100);

[M,T] = PlotRipRaw(gamma, Range(Restrict(stimt,Sleep),'s')-1, [-bin2*bin1 bin2*bin1]);
try
M_all{i} = M;
T_all{i} = T;
end

%%
% figure, hold on, plot(bW,hW,'r'), plot(b,h,'k')

figure, 
subplot(3,1,1),
plot(Range(gamma,'s'),Data(gamma), 'color',[0.7 0.7 0.7])
hold on
plot(Range(Restrict(gamma,Sleep),'s'),Data(Restrict(gamma,Sleep)),'k')
try
    hold on, plot(Range(Restrict(stimt,Sleep),'s')-1,0.5,'ro','markerfacecolor','r')
    hold on, plot(Range(Restrict(stimt,Wake),'s')-1,0.5,'bo','markerfacecolor','b')
subplot(3,1,2), area(tpsW/1E3-1,runmean(mW,4),'facecolor','k'), title(num2str(length(Range(Restrict(stimt,Wake)))))
line([0 0],ylim,'color','b')
subplot(3,1,3), area(tps/1E3-1,runmean(m,4),'facecolor','k'), title(num2str(length(Range(Restrict(stimt,Sleep)))))
end
line([0 0],ylim,'color','r')

% figure, imagesc(M(:,1),1:length(Range(Restrict(stimt,Sleep),'s')),SmoothDec(T,[0.01 20]))
% line([0 0],ylim,'color','w','linewidth',2)


nb_stim_wake = nb_stim_wake + length(Range(Restrict(stimt,Wake)));
nb_stim_sleep = nb_stim_sleep + length(Range(Restrict(stimt,Sleep)));

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
suptitle('Evolution de la puissance du Gamma autour de la stimulation électrique de 2 Volt')
subplot(211)
shadedErrorBar(tpsW_all(:,1),meanmW_all(:,1),stdmW_all(:,1));
line([0 0],ylim,'color','c')
ylabel('Gamma')
title('Eveil')
subplot(212)
shadedErrorBar(tps_all(:,1),meanm_all(:,1),stdm_all(:,1));
line([0 0],ylim,'color','r')
title('Sommeil')
ylabel('Gamma')