bch=[10,13,5,2,6,9,1,7];
load(strcat('LFPData/LFP30.mat'))
Ripa=FindRipplesKarim(LFP,SWSEpoch-NoiseEpoch);
[Md,Td]=PlotRipRaw(LFP,Ripa(:,2),70);
figure(1)
subplot(4,1,1)
hold off
plot(Md(:,1),zscore(Td'),'k','linewidth',0.5)
hold on
plot(Md(:,1),mean(zscore(Td')'),'r','linewidth',3)
plot(Md(:,1),mean(zscore(Td')')+std(zscore(Td')'),'r','linewidth',1)
plot(Md(:,1),mean(zscore(Td')')-std(zscore(Td')'),'r','linewidth',1)
title(strcat('AuTh (30) - ',num2str(size(Ripa,1)), 'events' ))


load(strcat('LFPData/LFP17.mat'))
Riph=FindRipplesKarim(LFP,SWSEpoch);
[Md,Td]=PlotRipRaw(LFP,Riph(:,2),70);
figure(1)
subplot(4,1,2)
hold off
plot(Md(:,1),zscore(Td'),'k','linewidth',0.5)
hold on
plot(Md(:,1),mean(zscore(Td')'),'r','linewidth',3)
plot(Md(:,1),mean(zscore(Td')')+std(zscore(Td')'),'r','linewidth',1)
plot(Md(:,1),mean(zscore(Td')')-std(zscore(Td')'),'r','linewidth',1)
title(strcat('Hpc (18) - ',num2str(size(Riph,1)), 'events' ))


load(strcat('LFPData/LFP27.mat'))
Ripc1=FindRipplesKarim(LFP,SWSEpoch);
[Md,Td]=PlotRipRaw(LFP,Ripc1(:,2),70);
figure(1)
subplot(4,1,3)
plot(Md(:,1),zscore(Td'),'k','linewidth',0.5)
hold on
plot(Md(:,1),mean(zscore(Td')'),'r','linewidth',3)
plot(Md(:,1),mean(zscore(Td')')+std(zscore(Td')'),'r','linewidth',1)
plot(Md(:,1),mean(zscore(Td')')-std(zscore(Td')'),'r','linewidth',1)
title(strcat('Cx (27) - ',num2str(size(Ripc1,1)), 'events' ))


load(strcat('LFPData/LFP24.mat'))
Ripc2=FindRipplesKarim(LFP,SWSEpoch);
[Md,Td]=PlotRipRaw(LFP,Ripc2(:,2),70);
figure(1)
subplot(4,1,4)
plot(Md(:,1),zscore(Td'),'k','linewidth',0.5)
hold on
plot(Md(:,1),mean(zscore(Td')'),'r','linewidth',3)
plot(Md(:,1),mean(zscore(Td')')+std(zscore(Td')'),'r','linewidth',1)
plot(Md(:,1),mean(zscore(Td')')-std(zscore(Td')'),'r','linewidth',1)
title(strcat('Cx (24) - ',num2str(size(Ripc2,1)), 'events' ))

figure
for k=1:length(bch)
load(strcat('LFPData/LFP',num2str(bch(k)),'.mat'))
[Md,Td]=PlotRipRaw(LFP,Riph(:,2),200); close
subplot(length(bch),1,k)
% plot(Md(:,1),zscore(Td'),'k','linewidth',0.5)
hold on
plot(Md(:,1),mean(zscore(Td')'),'r','linewidth',3)
plot(Md(:,1),mean(zscore(Td')')+std(zscore(Td')'),'r','linewidth',1)
plot(Md(:,1),mean(zscore(Td')')-std(zscore(Td')'),'r','linewidth',1)
ylim([-3 3])
end

params.Fs=1/median(diff(Range(LFP,'s')));
        params.trialave=0;
        params.fpass=[20 200];
        params.tapers=[3 5];
        movingwin=[0.1 0.005];
        params.err=[1 0.0500];
        params.pad=2;
 for k=1:size(Td,2)
[S,f]=mtspectrumc(Td(k,:),params);
hold on
 plot(f,f'.*S)
 end
