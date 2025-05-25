cd C:\Users\sbagur\Dropbox\Mobs_member\SophieBagur\Figures\Revision4HZ\LockingLaserLFP

AllDur = []; AllProp = [];
for mm=1:length(DurEp)
    AllDur = [AllDur,DurEp{mm}]; 
    AllProp = [AllProp,PropPhase{mm}];
end

figure
subplot(121)
plot(2:2:40,PercLightOn_All{1}'*200,'color',[0.4 0.4 0.4]*2)
hold on
errorbar(2:2:40,nanmean(PercLightOn_All{1}*200),std(PercLightOn_All{1}*200),'color','k','linewidth',2)
set(gca,'LineWidth',2,'FontSize',12), box off
ylim([0 1]*100)
title('4Hz stimulation')
xlabel('Fz episode dur')
ylabel('% stim in phase')

subplot(122)
plot(2:2:40,PercLightOn_All{2}'*200,'color',[0.4 0.4 0.4]*2)
hold on
errorbar(2:2:40,nanmean(PercLightOn_All{2}*200),std(PercLightOn_All{2}*200),'color','k','linewidth',2)
set(gca,'LineWidth',2,'FontSize',12), box off
ylim([0 1]*100)
plot(AllDur,100*AllProp,'r.')
xlim([0 40])
title('13Hz stimulation')
xlabel('Fz episode dur')
ylabel('% stim in phase')


figure
Freq = 5;
StimFreq = 13;
clf
subplot(3,1,1)
tps = [0:0.0001:5];
Sig = sin(tps*2*pi*Freq+pi);
Ph = mod(tps*2*pi*Freq+pi,2*pi);
plot(tps,Sig,'color','k','linewidth',2)
hold on
plot(tps(Ph>pi & Ph<2*pi),Sig(Ph>pi & Ph<2*pi),'.r','linewidth',2)
Las = sin(tps*2*pi*StimFreq);
Las = double(Las>0);
Las(Las==0) = NaN;
Las2 = Las;
Las2(Ph<pi | Ph>2*pi) = NaN;
plot(tps,Las2/4 +0.8,'color','b','linewidth',5)
plot(tps,Las/4 +1.1,'color','c','linewidth',5)
xlim([0 3])
ylim([-1.5 1.5])
set(gca,'LineWidth',2,'FontSize',12), box off
set(gca,'YTick',[],'YColor','w','XTick',[],'XColor','w')

subplot(3,1,3)
Las2(isnan(Las2))=0;
Las(isnan(Las))=0;
plot(tps,100*cumsum(Las2)./cumsum(Las),'linewidth',2,'color','k')
xlim([0 3])
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time (s)')
ylabel('% stim in phase')
ylim([0 100])

subplot(3,1,2)
tps = [0:0.0001:5];
Sig = sin(tps*2*pi*Freq);
Ph = mod(tps*2*pi*Freq,2*pi);
plot(tps,Sig,'color',[0.4 0.4 0.4],'linewidth',2)
hold on
plot(tps(Ph>pi & Ph<2*pi),Sig(Ph>pi & Ph<2*pi),'.r','linewidth',2)
Las = sin(tps*2*pi*StimFreq);
Las = double(Las>0);
Las(Las==0) = NaN;
Las2 = Las;
Las2(Ph<pi | Ph>2*pi) = NaN;
plot(tps,Las2/4 +0.8,'color','b','linewidth',5)
plot(tps,Las/4 +1.1,'color','c','linewidth',5)
xlim([0 3])
ylim([-1.5 1.5])
set(gca,'LineWidth',2,'FontSize',12), box off
set(gca,'YTick',[],'YColor','w','XTick',[],'XColor','w')
subplot(3,1,3)
Las2(isnan(Las2))=0;
Las(isnan(Las))=0;
hold on
plot(tps,100*cumsum(Las2)./cumsum(Las),'linewidth',2,'color',[0.4 0.4 0.4])
xlim([0 3])
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time (s)')
ylabel('% stim in phase')
ylim([0 100])
makepretty


Freq = 4;
StimFreq = 4;
clf
subplot(2,1,1)
tps = [0:0.0001:2];
Sig = sin(tps*2*pi*Freq+pi);
Ph = mod(tps*2*pi*Freq+pi,2*pi);
plot(tps,Sig,'color',[0.4 0.4 0.4],'linewidth',4)
hold on
plot(tps(Ph>pi & Ph<2*pi),Sig(Ph>pi & Ph<2*pi),'.r','MarkerSize',12)
Las = sin(tps*2*pi*StimFreq);
Las = double(Las>0);
Las(Las==0) = NaN;
Las2 = Las;
Las2(Ph<pi | Ph>2*pi) = NaN;
plot(tps,Las/4 +1.1,'color','c','linewidth',5)
xlim([0 1])
ylim([-1.5 1.5])
set(gca,'LineWidth',2,'FontSize',12), box off
set(gca,'YTick',[],'YColor','w','XTick',[],'XColor','w')


subplot(212)
tps = [0:0.0001:2];
Sig = sin(tps*2*pi*Freq);
Ph = mod(tps*2*pi*Freq,2*pi);
plot(tps,Sig,'color',[0.4 0.4 0.4],'linewidth',4)
hold on
plot(tps(Ph>pi & Ph<2*pi),Sig(Ph>pi & Ph<2*pi),'.r','MarkerSize',12)
Las = sin(tps*2*pi*StimFreq);
Las = double(Las>0);
Las(Las==0) = NaN;
Las2 = Las;
Las2(Ph<pi | Ph>2*pi) = NaN;
plot(tps,Las/4 +1.1,'color','c','linewidth',5)
xlim([0 1])
ylim([-1.5 1.5])
set(gca,'LineWidth',2,'FontSize',12), box off
set(gca,'YTick',[],'YColor','w','XTick',[],'XColor','w')
