% work25janvier

load('H_Low_Spectrum.mat')
load SleepScoring_OBGamma REMEpoch Wake SWSEpoch TotalNoiseEpoch

figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);  % 10 pour que l'hypnogramme parte de la valeur 10 avec une échelle a 2

rg=Range(SleepStages);  % donne tous les temps de sleepstages 
vect=find(Data(SleepStages)==3); % vect est le numero des valeurs de sleepstages poru lesquelles sleepstages vaut 3 

[h1,b1]=hist(rg/1E4,[0:30:3E4]);  % ca permet d'avoir les temps pour toutes les valeurs de sleepstages en 30s. (de 0 a 3E4 secondes poru al fin du fichier)
[h,b]=hist(rg(vect)/1E4,[0:30:3E4]); % ca permet d'avoir les temps pour toutes les valeurs de sleepstages qui valent 3 (pour REM) en 30s.

[h1,b1]=hist(rg/1E4,[0:30:length(Spectro{1})]);  % ca permet d'avoir les temps pour toutes les valeurs de sleepstages en 30s. (de 0 a 3E4 secondes poru al fin du fichier)
[h,b]=hist(rg(vect)/1E4,[0:30:length(Spectro{1})]);
hold on, plot(b,h./h1*10,'r*')


%% tracer les spectres de l'hippocampe pour chaque stages

load('H_Low_Spectrum.mat')
size(Spectro{1})% taille 
figure, imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1})'), axis xy
Spectrotsd=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Spectrotsd)))
figure, plot(f,mean(Data(Restrict(Spectrotsd,REMEpoch))),'r')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,SWSEpoch))),'b')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,Wake))),'k')

load('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_REM_or_wake_5s_01102018/LFPData/LFP7.mat')
figure, plot(Range(LFP,'s'),Data(LFP))
hold on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
figure, plot(Data(Restrict(LFP,REMEpoch)))

%% superposer hypnogramme et spectrogramme
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
%Wake=Wake-TotalNoiseEpoch; Wake=mergeCloseIntervals(Wake,0);

figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
caxis([20 55])
hold on, SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
vect=find(Data(SleepStages)==3);
figure, hist(vect,1E4)
figure, hist(vect,1E2)
vect(1:100)

st=Start(REMEpoch);
rg=Range(SleepStages);
rg(vect(1))
figure, hist(rg(vect)/1E4,1E2)
[h,b]=hist(rg(vect)/1E4,[0:30:3E4]);

hold on, plot(b,h,'k')
hold on, plot(b,h/10,'k')
hold on, plot(b,h/100,'k')
figure, bar(b,h)

figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
hold on, plot(b,h./h1*10,'r')
hold on, plot(b,h./h1*10,'k*')


 





% figure, plot(cumsum(Start(REMEpoch)))
% figure, plot(Start(REMEpoch))
% load('sleepstage.mat')
% figure, plot(allresult)
% figure, plot(allresult(:,1),allresult(:,2))
% figure, plot(allresult(:,end),allresult(:,2))
% figure, plot(allresult(:,2),allresult(:,end))
% figure, plot(allresult(:,2),allresult(:,end))
% figure, plot(allresult(:,2),allresult(:,1))
% figure, plot(allresult(:,2),allresult(:,end))
% figure, plot(allresult(:,2),allresult(:,end-1))
% figure, plot(allresult(:,2),allresult(:,end-2))
% figure, plot(allresult(:,2),allresult(:,end-3))
% figure, plot(allresult(:,2),allresult(:,end-4))
% figure, plot(allresult(:,2),allresult(:,end-5))
% figure, plot(allresult(:,2),allresult(:,end-6))
% figure, plot(allresult(:,2),allresult(:,end))
% polysomno=tsd(allresult(:,2),allresult(:,end));
% figure, plot(Range(polysomno,'s'),Data(polysomno))
% hold on, plot(Range(Restrict(polysomno,REMEpoch),'s'),Data(Restrict(polysomno,REMEpoch)),'r')
% polysomno=tsd(allresult(:,2)*1E4,allresult(:,end));
% figure, plot(Range(polysomno,'s'),Data(polysomno))
% hold on, plot(Range(Restrict(polysomno,REMEpoch),'s'),Data(Restrict(polysomno,REMEpoch)),'r')
% hold on, plot(Range(Restrict(polysomno,Wake),'s'),Data(Restrict(polysomno,Wake)),'k')
