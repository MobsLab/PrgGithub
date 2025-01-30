cd /media/nas4/ProjetMTZL/Mouse778/20181213
cd /media/nas4/ProjetMTZL/Mouse778/24102018

load IdFigureData2
load('IdFigureData','SleepStages','Epochs') 

subplot(211)
ylabel_substage = {'N3','N2','N1','REM','WAKE'};
ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
for ep=1:length(Epochs)
    plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
end
xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
title('Hypnogram'); xlabel('Time (h)')

subplot(212)
load('CleanedAcc/Acc33.mat')
plot(Range(LFPClean,'s')/3600 ,Data(LFPClean),'Color','k')
xlim([0 max(Range(SleepStages,'s')/3600)])


cd /media/nas4/ProjetMTZL/Mouse778/20181218
figure
load IdFigureData2
load('IdFigureData','SleepStages','Epochs') 

subplot(211)
ylabel_substage = {'N3','N2','N1','REM','WAKE'};
ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
for ep=1:length(Epochs)
    plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
end
xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
title('Hypnogram'); xlabel('Time (h)')

subplot(212)
load('CleanedAcc/Acc33.mat')
plot(Range(LFPClean,'s')/3600 ,Data(LFPClean),'Color','k')
xlim([0 max(Range(SleepStages,'s')/3600)])

