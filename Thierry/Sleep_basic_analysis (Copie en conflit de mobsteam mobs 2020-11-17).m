load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%% Ouvrir et nommer les spectro de hip et OB*
load('H_Low_Spectrum.mat')
SpectroH=Spectro;
load('B_Low_Spectrum.mat')
SpectroBL=Spectro;
load('B_High_Spectrum.mat')
SpectroBH=Spectro;

%%Figures des spectres
figure, 
subplot(2,1,1), imagesc(SpectroH{2},SpectroH{3},10*log10(SpectroH{1}')), axis xy
caxis([10 65])
colormap(jet)
subplot(2,1,2), imagesc(SpectroBL{2},SpectroBL{3},10*log10(SpectroBL{1}')), axis xy
caxis([10 65])
subplot(2,1,2), imagesc(SpectroBH{2},SpectroBH{3},10*log10(SpectroBH{1}')), axis xy
caxis([10 65])
colormap(jet)
%% 
% *Nombre d'épisodes*

%%length(Start(REMEpoch,'s'))
length(Start(SWSEpoch,'s'))
length(Start(Wake,'s'))
length(Start(REMEpoch,'s'))


% *Durée de chaque épisode*

Stop(REMEpoch,'s')-Start(REMEpoch,'s');
Stop(SWSEpoch,'s')-Start(SWSEpoch,'s');
Stop(Wake,'s')-Start(Wake,'s');

% *Pourcentage de rem/SWS/Wake sur tout sommeil*

%REM/Sleep
sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))
%SWS/Sleep
sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))
%Wake/Total
sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))
%SWS/Total
sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))
%REM/Total
(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))


% *Transitions SWS to wake*

[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
length(Start(aft_cell{1,2}))

% *Transitions SWS to REM*

[aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
length(Start(aft_cell{1,2}))

% *Transitions REM to SWS*

[aft_cell,bef_cell]=transEpoch(REMEpoch,SWSEpoch);
length(Start(aft_cell{1,2}))

% *Transitions Wake to REM*

[aft_cell,bef_cell]=transEpoch(Wake,REMEpoch);
length(Start(aft_cell{1,2}))

%%%% tracer les spectres de l'hippocampe pour chaque stage

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M923_Baseline2
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

%%Superposer hypnogramme et spectrogramme

SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);

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


%% *Faire l'hypnogramme*

SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]) 
% 10 pour que l'hypnogramme parte de la valeur 10 avec une échelle a 2
rg=Range(SleepStages);  
% donne tous les temps de sleepstages 
vect=find(Data(SleepStages)==3); 
% vect est le numero des valeurs de sleepstages pour lesquelles sleepstages vaut 3=REM
[h1,b1]=hist(rg/1E4,[0:30:3E4]);  
% ca permet d'avoir les temps pour toutes les valeurs de sleepstages en 30s. (de 0 a 3E4 secondes pour la fin du fichier par exemple)
[h,b]=hist(rg(vect)/1E4,[0:30:3E4]); 
% ca permet d'avoir les temps pour toutes les valeurs de sleepstages qui valent 3 (pour REM) en 30s.
[h,b]=hist(rg(vect)/1E4,[0:30:length(Spectro{1})]);
% ca permet d'avoir les temps pour toutes les valeurs de sleepstages qui valent 3 (pour REM) en 30s.
[h1,b1]=hist(rg/1E4,[0:30:length(Spectro{1})]);  
% ca permet d'avoir les temps pour toutes les valeurs de sleepstages en 30s. (de 0 a la fin du fichier)
hold on, plot(b,h./h1*10,'r*')
%% 
%%*????? Calculer le % de REM*

function PercREM=FindPercREM(REMEpoch,SWSEpoch, Epoch)
    
REM=and(REMEpoch,Epoch);
SWS=and(SWSEpoch,Epoch);
REMdur=sum(End(REM,'s')-Start(REM,'s'));
SWSdur=sum(End(SWS,'s')-Start(SWS,'s'));
PercREM=REMdur/(REMdur+SWSdur)*100

end
%% 
% *?????*

function [PercFirstHalf, PercSecHalf, PercFirstThird,PercSecThird,PercLastThird]=PercREMFirstSecHalf(REMEpoch,SWSEpoch,Wake,pas,plo)
    
try
    pas;
catch
    pas=1000;
end

try
    plo;
catch
    plo=0;
end

maxlim=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
numpoints=floor(maxlim/pas/1E4)+1;

for i=1:numpoints
    per(i)=FindPercREM(REMEpoch,SWSEpoch,intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tps(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

% for i=1:5000
% per(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*1000E4,i*1000E4));
% tps(i)=(i*1000E4+(i-1)*1000E4)/2;
% end

if plo
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0.1)
hold on, plot(tps/1E4,rescale(per,-1,100),'ro-')

end
%% 
% *Calul du % de REM dans les 2 premières parties de la session*

PercFirstHalf=nanmean(per(1:length(per)/2));
PercSecHalf=nanmean(per(length(per)/2:end));
%% 
% *Calul du % de REM dans les 3 premières parties de la session*

PercFirstThird=nanmean(per(1:length(per)/3));
PercSecThird=nanmean(per(length(per)/3:2*length(per)/3));
PercLastThird=nanmean(per(2*length(per)/3:end));
%% 
% 
% 
% *Spectre du OB sur toute la session*

load SleepScoring_OBGamma REMEpoch Wake SWSEpoch
Spectrotsd=tsd(Spectro{2},10*log10(Spectro{1}));
figure, plot(mean(Data(Spectrotsd)))
hold on, plot(mean(Data(Restrict(Spectrotsd,REMEpoch))),'r')
f=Spectro{3};
hold on, plot(f,mean(Data(Restrict(Spectrotsd,REMEpoch))),'r')

figure, plot(mean(Data(Spectrotsd)))
hold on, plot(f,mean(Data(Restrict(Spectrotsd,SWSEpoch))),'r')
Spectrotsd=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
figure, plot(mean(Data(Spectrotsd)))
hold on, plot(f,mean(Data(Restrict(Spectrotsd,SWSEpoch))),'r')
figure, plot(f,mean(Data(Spectrotsd)))
hold on, plot(f,mean(Data(Restrict(Spectrotsd,SWSEpoch))),'r')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,REMEpoch))),'r')
figure
hold on, plot(f,mean(Data(Restrict(Spectrotsd,SWSEpoch))),'k')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,REMEpoch))),'r')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,Wake))),'b')
load('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_REM_or_wake_5s_01102018/LFPData/LFP7.mat')
figure, plot(Range(LFP,'s'),Data(LFP))
holod on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
Undefined function or variable 'holod'.
 
hold on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
figure, plot(Data(Restrict(LFP,REMEpoch)))
figure, cumsum(Start(REMEpoch));

figure, plot(cumsum(Start(REMEpoch)))
figure, plot(Start(REMEpoch))

load('sleepstage.mat')
figure, plot(allresult)
figure, plot(allresult(:,1),allresult(:,2))
figure, plot(allresult(:,end),allresult(:,2))
figure, plot(allresult(:,2),allresult(:,end))
 figure, plot(,allresult(:,2),allresult(:,end))
              ↑
Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
 
figure, plot(allresult(:,2),allresult(:,end))
figure, plot(allresult(:,2),allresult(:,1))
figure, plot(allresult(:,2),allresult(:,end))
figure, plot(allresult(:,2),allresult(:,end-1))
figure, plot(allresult(:,2),allresult(:,end-2))
figure, plot(allresult(:,2),allresult(:,end-3))
figure, plot(allresult(:,2),allresult(:,end-4))
figure, plot(allresult(:,2),allresult(:,end-5))
figure, plot(allresult(:,2),allresult(:,end-6))
figure, plot(allresult(:,2),allresult(:,end))
polysomno=tsd(allresult(:,2),allresult(:,end));
figure, plot(Range(polysomno,'s'),Data(polysomno))
hold on, plot(Range(Restrict(polysomno,REMEpoch),'s'),Data(Restrict(polysomno,REMEpoch)),'r')
polysomno=tsd(allresult(:,2)*1E4,allresult(:,end));
figure, plot(Range(polysomno,'s'),Data(polysomno))
hold on, plot(Range(Restrict(polysomno,REMEpoch),'s'),Data(Restrict(polysomno,REMEpoch)),'r')
hold on, plot(Range(Restrict(polysomno,Wake),'s'),Data(Restrict(polysomno,Wake)),'k')
Spectrotsd=tsd(Spectro{2}*1E4,(Spectro{1}));
figure, plot(f,mean(Data(Spectrotsd)))
hold on, plot(f,mean(Data(Restrict(Spectrotsd,Wake))),'k')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,SWSEpoch))),'b')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,REMEpoch))),'r')
edit PlotSleepStage
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
figure, plot(Range(SleepStages),Data(SleepStages))
load SleepScoring_OBGamma REMEpoch Wake SWSEpoch TotalNoiseEpoch
Wake=Wake-TotalNoiseEpoch;
Warning: timestamps are not sorted 
> In intervalSet/diff (line 53)
  In  -  (line 10) 
Wake=Wake-TotalNoiseEpoch; Wake=mergeCloseIntervals(Wake,0);
Warning: timestamps are not sorted 
> In intervalSet/diff (line 53)
  In  -  (line 10) 
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
figure
hold on, plot(f,mean(Data(Restrict(Spectrotsd,Wake))),'k')
hold on, plot(f,mean(Data(Restrict(Spectrotsd,REMEpoch))),'r')
load SleepScoring_OBGamma REMEpoch Wake SWSEpoch TotalNoiseEpoch
Wake2=Wake-TotalNoiseEpoch; Wake2=mergeCloseIntervals(Wake,0);
Warning: timestamps are not sorted 
> In intervalSet/diff (line 53)
  In  -  (line 10) 
hold on, plot(f,mean(Data(Restrict(Spectrotsd,Wake2))),'b')
figure, imagesc(Spectro{2}*1E4,Spectro{3},10*log10(Spectro{1})'), axis xy
hold on, plot(Range(SleepStages),Data(SleepStages)*4,'k')
figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
 SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[70 4]);
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[20 4]);
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[20 0]);
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
vect=find(Data(SleepStages)==3);
figure, hist(vect,1E4)
figure, hist(vect,1E2)
vect(1:100)

st=Start(REMEpoch);
rg=Range(SleepStages);
rg(vect(1))

figure, hist(rg(vect),1E2)
figure, hist(rg(vect),1E1)
figure, hist(rg(vect),1E2)
figure, hist(rg(vect)/1E4,1E2)
[h,b]=hist(rg(vect)/1E4,1E2);
hold on, plot(b;h,'k')
 hold on, plot(b;h,'k')
                ↑
Error: Unbalanced or unexpected parenthesis or bracket.
 
hold on, plot(b,h,'k')
hold on, plot(b,h/10,'k')
hold on, plot(b,h/100,'k')
figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
hold on, bar(b,h/100,'k')
figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
hold on, bar(b,h/200,'k')
[h,b]=hist(rg(vect)/1E4,50);
figure, bar(h)
figure, bar(b,h)
[h,b]=hist(rg(vect)/1E4,[0 3E4]);
figure, bar(b,h)
[h,b]=hist(rg(vect)/1E4,[0:0.03E4:3E4]);
figure, bar(b,h)
[h,b]=hist(rg(vect)/1E4,[0:0.3E4:3E4]);
figure, bar(b,h)
[h,b]=hist(rg(vect)/1E4,[0:30:3E4]);
figure, bar(b,h)
figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
hold on, bar(b,h/100)
[h1,b1]=hist(rg/1E4,[0:30:3E4]);
[h,b]=hist(rg(vect)/1E4,[0:30:3E4]);
figure, plot(b,h./h1)*100)
 figure, plot(b,h./h1)*100)
                          ↑
Error: Unbalanced or unexpected parenthesis or bracket.
 
figure, plot(b,h./h1*100)
figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
hold on, plot(b,h./h1)*10,'k')
 hold on, plot(b,h./h1)*10,'k')
                              ↑
Error: Unbalanced or unexpected parenthesis or bracket.
 
hold on, plot(b,h./h1*10,'k')
hold on, plot(b,h./h1*10,'k*')
vect=find(Data(SleepStages)==3);