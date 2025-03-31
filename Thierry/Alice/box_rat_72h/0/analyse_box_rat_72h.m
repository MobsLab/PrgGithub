%% Chargement des données

close all
clear all
pas = 500;
Dir_figures='/media/nas5/Thierry_DATA/Rat_box_72h/Figures/'

%Load Baseline
Dir_Baseline1=PathForExperiments_TG('box_rat_72h_Baseline1');

for i=1:length(Dir_Baseline1.path);
    cd(Dir_Baseline1.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep');
    Wake_Baseline1(i)=Wake;
    REMEpoch_Baseline1(i)=REMEpoch;
    NREMEpoch_Baseline1(i)=SWSEpoch;
    PercNREM_Total_Baseline1(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercREM_Total_Baseline1(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercWake_Total_Baseline1(i)=sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercNREM_Sleep_Baseline1(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;
    PercREM_Sleep_Baseline1(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;  
    NbNREM_Baseline1(i)=length(length(SWSEpoch));
    NbREM_Baseline1(i)=length(length(REMEpoch));
    NbWake_Baseline1(i)=length(length(Wake));
    
    maxlim_Baseline1(i)=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
    numpoints_Baseline1(i)=floor(maxlim_Baseline1(i)/pas/1E4)+1;
    for j=1:numpoints_Baseline1(i)
        [perWake_Baseline1(i,j),perNREM_Baseline1(i,j),perREM_Baseline1(i,j)]=FindPerc_Wake_SWS_REM_Total(Wake,SWSEpoch,REMEpoch, intervalSet((j-1)*pas*1E4,j*pas*1E4));
        tpsREM_Baseline1(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
        tpsNREM_Baseline1(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
        tpsWake_Baseline1(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
    end
    PercREMFirstThird_Baseline1(i)=nanmean(perREM_Baseline1(1:length(perREM_Baseline1)/3));
    PercREMSecThird_Baseline1(i)=nanmean(perREM_Baseline1(length(perREM_Baseline1)/3:2*length(perREM_Baseline1)/3));
    PercREMLastThird_Baseline1(i)=nanmean(perREM_Baseline1(2*length(perREM_Baseline1)/3:end));
    PercNREMFirstThird_Baseline1(i)=nanmean(perNREM_Baseline1(1:length(perNREM_Baseline1)/3));
    PercNREMSecThird_Baseline1(i)=nanmean(perNREM_Baseline1(length(perNREM_Baseline1)/3:2*length(perNREM_Baseline1)/3));
    PercNREMLastThird_Baseline1(i)=nanmean(perNREM_Baseline1(2*length(perNREM_Baseline1)/3:end));
    PercWakeFirstThird_Baseline1(i)=nanmean(perWake_Baseline1(1:length(perWake_Baseline1)/3));
    PercWakeSecThird_Baseline1(i)=nanmean(perWake_Baseline1(length(perWake_Baseline1)/3:2*length(perWake_Baseline1)/3));
    PercWakeLastThird_Baseline1(i)=nanmean(perWake_Baseline1(2*length(perWake_Baseline1)/3:end));
   
    fprintf('Loading hippocampus low spectrum Baseline 1 %d/%d...\n',[i,length(Dir_Baseline1.path)])
    load('H_Low_Spectrum.mat')
    SpectroH_Baseline1{i}=Spectro;
    Spectrotsd_LH_Baseline1(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_LH_Baseline1{i}=Spectro{3};
    fprintf('Loading OB high spectrum Baseline 1 %d/%d...\n',[i,length(Dir_Baseline1.path)])
    load('B_High_Spectrum.mat')
    SpectroB_Baseline1{i}=Spectro;
    Spectrotsd_HB_Baseline1(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_HB_Baseline1{i}=Spectro{3};
    
end

%Load Exposure
Dir_Exposure=PathForExperiments_TG('box_rat_72h_Exposure');

for i=1:length(Dir_Exposure.path);
    cd(Dir_Exposure.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','SWSEpoch','SWSEpoch','Sleep');
    Wake_Exposure(i)=Wake;
    REMEpoch_Exposure(i)=REMEpoch;
    NREMEpoch_Exposure(i)=SWSEpoch;
    PercNREM_Total_Exposure(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercREM_Total_Exposure(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercWake_Total_Exposure(i)=sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercNREM_Sleep_Exposure(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;
    PercREM_Sleep_Exposure(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;  
    NbNREM_Exposure(i)=length(length(SWSEpoch));
    NbREM_Exposure(i)=length(length(REMEpoch));
    NbWake_Exposure(i)=length(length((Wake)));
    
    maxlim_Exposure(i)=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
    numpoints_Exposure(i)=floor(maxlim_Exposure(i)/pas/1E4)+1;
    for j=1:numpoints_Exposure(i)
        [perWake_Exposure(i,j),perNREM_Exposure(i,j),perREM_Exposure(i,j)]=FindPerc_Wake_SWS_REM_Total(Wake,SWSEpoch,REMEpoch, intervalSet((j-1)*pas*1E4,j*pas*1E4));
        tpsREM_Exposure(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
        tpsNREM_Exposure(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
        tpsWake_Exposure(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
    end
    PercREMFirstThird_Exposure(i)=nanmean(perREM_Exposure(1:length(perREM_Exposure)/3));
    PercREMSecThird_Exposure(i)=nanmean(perREM_Exposure(length(perREM_Exposure)/3:2*length(perREM_Exposure)/3));
    PercREMLastThird_Exposure(i)=nanmean(perREM_Exposure(2*length(perREM_Exposure)/3:end));
    PercNREMFirstThird_Exposure(i)=nanmean(perNREM_Exposure(1:length(perNREM_Exposure)/3));
    PercNREMSecThird_Exposure(i)=nanmean(perNREM_Exposure(length(perNREM_Exposure)/3:2*length(perNREM_Exposure)/3));
    PercNREMLastThird_Exposure(i)=nanmean(perNREM_Exposure(2*length(perNREM_Exposure)/3:end));
    PercWakeFirstThird_Exposure(i)=nanmean(perWake_Exposure(1:length(perWake_Exposure)/3));
    PercWakeSecThird_Exposure(i)=nanmean(perWake_Exposure(length(perWake_Exposure)/3:2*length(perWake_Exposure)/3));
    PercWakeLastThird_Exposure(i)=nanmean(perWake_Exposure(2*length(perWake_Exposure)/3:end));

    fprintf('Loading hippocampus low spectrum Exposure %d/%d...\n',[i,length(Dir_Baseline1.path)])
    load('H_Low_Spectrum.mat')
    SpectroH_Exposure{i}=Spectro; 
    Spectrotsd_LH_Exposure(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_LH_Exposure{i}=Spectro{3};
    fprintf('Loading OB high spectrum Exposure %d/%d...\n',[i,length(Dir_Baseline1.path)])
    load('B_High_Spectrum.mat')
    SpectroB_Exposure{i}=Spectro;    
    Spectrotsd_HB_Exposure(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_HB_Exposure{i}=Spectro{3};
    
end

%Load Baseline2
Dir_Baseline2=PathForExperiments_TG('box_rat_72h_Baseline2');

for i=1:length(Dir_Baseline2.path);
    cd(Dir_Baseline2.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep');
    Wake_Baseline2(i)=Wake;
    REMEpoch_Baseline2(i)=REMEpoch;
    NREMEpoch_Baseline2(i)=SWSEpoch;
    PercNREM_Total_Baseline2(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercREM_Total_Baseline2(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercWake_Total_Baseline2(i)=sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercNREM_Sleep_Baseline2(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;
    PercREM_Sleep_Baseline2(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;  
    NbNREM_Baseline2(i)=length(length(SWSEpoch));
    NbREM_Baseline2(i)=length(length(REMEpoch));
    NbWake_Baseline2(i)=length(length((Wake)));
    
    maxlim_Baseline2(i)=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
    numpoints_Baseline2(i)=floor(maxlim_Baseline2(i)/pas/1E4)+1;
     for j=1:numpoints_Baseline2(i)
        [perWake_Baseline2(i,j),perNREM_Baseline2(i,j),perREM_Baseline2(i,j)]=FindPerc_Wake_SWS_REM_Total(Wake,SWSEpoch,REMEpoch, intervalSet((j-1)*pas*1E4,j*pas*1E4));
        tpsREM_Baseline2(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
        tpsNREM_Baseline2(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
        tpsWake_Baseline2(i,j)=(j*pas*1E4+(j-1)*pas*1E4)/2;
    end
    PercREMFirstThird_Baseline2(i)=nanmean(perREM_Baseline2(1:length(perREM_Baseline2)/3));
    PercREMSecThird_Baseline2(i)=nanmean(perREM_Baseline2(length(perREM_Baseline2)/3:2*length(perREM_Baseline2)/3));
    PercREMLastThird_Baseline2(i)=nanmean(perREM_Baseline2(2*length(perREM_Baseline2)/3:end));
    PercNREMFirstThird_Baseline2(i)=nanmean(perNREM_Baseline2(1:length(perNREM_Baseline2)/3));
    PercNREMSecThird_Baseline2(i)=nanmean(perNREM_Baseline2(length(perNREM_Baseline2)/3:2*length(perNREM_Baseline2)/3));
    PercNREMLastThird_Baseline2(i)=nanmean(perNREM_Baseline2(2*length(perNREM_Baseline2)/3:end));
    PercWakeFirstThird_Baseline2(i)=nanmean(perWake_Baseline2(1:length(perWake_Baseline2)/3));
    PercWakeSecThird_Baseline2(i)=nanmean(perWake_Baseline2(length(perWake_Baseline2)/3:2*length(perWake_Baseline2)/3));
    PercWakeLastThird_Baseline2(i)=nanmean(perWake_Baseline2(2*length(perWake_Baseline2)/3:end));
    
    fprintf('Loading hippocampus low spectrum Baseline 2 %d/%d...\n',[i,length(Dir_Baseline1.path)])
    load('H_Low_Spectrum.mat')
    SpectroH_Baseline2{i}=Spectro;
    Spectrotsd_LH_Baseline2(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_LH_Baseline2{i}=Spectro{3};
    fprintf('Loading OB high spectrum Baseline 2 %d/%d...\n',[i,length(Dir_Baseline1.path)])
    load('B_High_Spectrum.mat')
    SpectroB_Baseline2{i}=Spectro;
    Spectrotsd_HB_Baseline2(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_HB_Baseline2{i}=Spectro{3};
    
end


%% Tracé des figures Mean percentage of different states Wake NREM & REM Total

%Pourcentages de Wake, NREM & REM au cours de l'enregistrement pour les 3
%conditions pour les 2 souris
%* Wake
figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({PercWake_Total_Baseline1 PercWake_Total_Exposure PercWake_Total_Baseline2},'newfig',0);

%* REM
subplot(1,3,2);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({PercREM_Total_Baseline1 PercREM_Total_Exposure PercREM_Total_Baseline2},'newfig',0);

%* NREM
subplot(1,3,3);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({PercNREM_Total_Baseline1 PercNREM_Total_Exposure PercNREM_Total_Baseline2},'newfig',0);

cd (Dir_figures)
savefig(fullfile('Percentage of states during the wole experiments.fig'))

%% Tracé des figures Mean percentage of different states NREM & REM Sleep

%Pourcentages de Wake, NREM & REM au cours du sommeil pour les 3
%conditions pour les 2 souris

%* REM
figure
subplot(1,2,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Sleep')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({PercREM_Sleep_Baseline1 PercREM_Sleep_Exposure PercREM_Sleep_Baseline2},'newfig',0);

%* NREM
subplot(1,2,2);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Sleep')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({PercNREM_Sleep_Baseline1 PercNREM_Sleep_Exposure PercNREM_Sleep_Baseline2},'newfig',0);

cd (Dir_figures)
savefig(fullfile('Percentage of states during the sleep.fig'))

%% Tracé des figures number of different states

%Nombre d'épisodes de Wake, NREM & REM au cours de l'enregistrement pour les 3
%conditions pour les 2 souris
%* Wake
figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of Wake bouts')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({NbWake_Baseline1 NbWake_Exposure NbWake_Baseline2},'newfig',0);

%* REM
subplot(1,3,2);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of NREM bouts')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({NbREM_Baseline1 NbREM_Exposure NbREM_Baseline2},'newfig',0);

%* NREM
subplot(1,3,3);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of REM bouts')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({NbNREM_Baseline1 NbNREM_Exposure NbNREM_Baseline2},'newfig',0);
cd (Dir_figures)
savefig(fullfile('Mean number of bouts for different states for the 3 conditions.fig'))


%% Tracé %REM overtime

%M923
figure, plot(tpsREM_Baseline1(1,:)/1E4,perREM_Baseline1(1,:),'ko-','LineWidth',2)
hold on, plot(tpsREM_Exposure(1,:)/1E4,perREM_Exposure(1,:),'ro-','LineWidth',2)
hold on, plot(tpsREM_Baseline2(1,:)/1E4,perREM_Baseline2(1,:),'bo-','LineWidth',2)
%set(gca,'FontSize',14)
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M923')
legend('Baseline 1','Exposure','Baseline 2')
cd (Dir_figures)
savefig(fullfile('% REM overtime M923.fig'))

%M926
figure, plot(tpsREM_Baseline1(2,:)/1E4,perREM_Baseline1(2,:),'ko-','LineWidth',2)
hold on, plot(tpsREM_Exposure(2,:)/1E4,perREM_Exposure(2,:),'ro-','LineWidth',2)
hold on, plot(tpsREM_Baseline2(2,:)/1E4,perREM_Baseline2(2,:),'bo-','LineWidth',2)
%set(gca,'FontSize',14)
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M926')
legend('Baseline 1','Exposure','Baseline 2')
cd (Dir_figures)
savefig(fullfile('% REM overtime M926.fig'))

%% Histograms 1st, 2nd and last third Wake

%* Wake 1st third
figure
subplot(1,3,1);
ylabel('Percentage of Wake')
xlabel('Conditions')
title('% of Wake/Total during the First Third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
ylim([0,80])
PlotErrorBarN_KJ({PercWakeFirstThird_Baseline1 PercWakeFirstThird_Exposure PercWakeFirstThird_Baseline2},'newfig',0);

%* Wake 2nd third
subplot(1,3,2);
ylabel('Percentage of Wake')
xlabel('Conditions')
title('% of Wake/Total during the Second Third')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
ylim([0,80])
PlotErrorBarN_KJ({PercWakeSecThird_Baseline1 PercWakeSecThird_Exposure PercWakeSecThird_Baseline2},'newfig',0);

%* Wake LAST third
subplot(1,3,3);
ylabel('Percentage of Wake')
xlabel('Conditions')
title('% of Wake/Total during the Last Third')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
ylim([0,80])
PlotErrorBarN_KJ({PercWakeLastThird_Baseline1 PercWakeLastThird_Exposure PercWakeLastThird_Baseline2},'newfig',0);

cd (Dir_figures)
savefig(fullfile('% of Wake over Total for the 3 thirds.fig'))

%% Histograms 1st, 2nd and last third NREM

%* NREM 1st third
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage of NREM')
xlabel('Conditions')
title('% of NREM/Total during the First Third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
ylim([0,90])
PlotErrorBarN_KJ({PercNREMFirstThird_Baseline1 PercNREMFirstThird_Exposure PercNREMFirstThird_Baseline2},'newfig',0);

%* NREM 2nd third
subplot(1,3,2);
ylabel('Percentage of NREM')
xlabel('Conditions')
title('% of NREM/Total during the Second Third')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
ylim([0,90])
PlotErrorBarN_KJ({PercNREMSecThird_Baseline1 PercNREMSecThird_Exposure PercNREMSecThird_Baseline2},'newfig',0);

%* NREM LAST third
subplot(1,3,3);
ylabel('Percentage of NREM')
xlabel('Conditions')
title('% of NREM/Total during the Last Third')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
ylim([0,90])
PlotErrorBarN_KJ({PercNREMLastThird_Baseline1 PercNREMLastThird_Exposure PercNREMLastThird_Baseline2},'newfig',0);

cd (Dir_figures)
savefig(fullfile('% of NREM over Total for the 3 thirds.fig'))

%% Histograms 1st, 2nd and last third REM

%* REM 1st third
subplot(1,3,1);
ylabel('Percentage of REM')
xlabel('Conditions')
title('% of REM/Total during the First Third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
ylim([0,12])
PlotErrorBarN_KJ({PercREMFirstThird_Baseline1 PercREMFirstThird_Exposure PercREMFirstThird_Baseline2},'newfig',0);

%* REM 2nd third
subplot(1,3,2);
ylabel('Percentage of REM')
xlabel('Conditions')
title('% of REM/Total during the Second Third')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
ylim([0,12])
PlotErrorBarN_KJ({PercREMSecThird_Baseline1 PercREMSecThird_Exposure PercREMSecThird_Baseline2},'newfig',0);

%* REM LAST third
subplot(1,3,3);
ylabel('Percentage of REM')
xlabel('Conditions')
title('% of REM/Total during the Last Third')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
ylim([0,12])
PlotErrorBarN_KJ({PercREMLastThird_Baseline1 PercREMLastThird_Exposure PercREMLastThird_Baseline2},'newfig',0);

cd (Dir_figures)
savefig(fullfile('% of REM over Total for the 3 thirds'))

%% Spectres Low Hippocampus

%M923
figure
subplot(3,1,1)
imagesc(SpectroH_Baseline1{1}{2},SpectroH_Baseline1{1}{3},10*log10(SpectroH_Baseline1{1}{1}')), axis xy
title('Low frequency spectrum of the hippocampus Baseline 1 M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
caxis([25,50])  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis

subplot(3,1,2)
imagesc(SpectroH_Exposure{1}{2},SpectroH_Exposure{1}{3},10*log10(SpectroH_Exposure{1}{1})'), axis xy
title('Low frequency spectrum of the hippocampus Exposure M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
caxis([25,50])

subplot(3,1,3)
imagesc(SpectroH_Baseline2{1}{2},SpectroH_Baseline2{1}{3},10*log10(SpectroH_Baseline2{1}{1})'), axis xy
title('Low frequency spectrum of the hippocampus Baseline 2 M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
caxis([25,50])

cd (Dir_figures)
savefig(fullfile('Low frequency spectrum of the hippocampus M923.fig'))

%M926
figure
subplot(3,1,1)
imagesc(SpectroH_Baseline1{2}{2},SpectroH_Baseline1{2}{3},10*log10(SpectroH_Baseline1{2}{1})'), axis xy
title('Low frequency spectrum of the hippocampus Baseline 1 M926')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
caxis([25,58])       %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis

subplot(3,1,2)
imagesc(SpectroH_Exposure{2}{2},SpectroH_Exposure{2}{3},10*log10(SpectroH_Exposure{2}{1})'), axis xy
title('Low frequency spectrum of the hippocampus Exposure M926')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
caxis([25,58])

subplot(3,1,3)
imagesc(SpectroH_Baseline2{2}{2},SpectroH_Baseline2{2}{3},10*log10(SpectroH_Baseline2{2}{1})'), axis xy
title('Low frequency spectrum of the hippocampus Baseline 2 M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
caxis([25,58])

cd (Dir_figures)
savefig(fullfile('Low frequency spectrum of the hippocampus M926.fig'))



%% Spectrogrammes Low Hippocampus

figure
subplot(2,4,1), plot(f_LH_Baseline1{1},mean(Data(Restrict(Spectrotsd_LH_Baseline1(1),REMEpoch_Baseline1(1)))),'b')
hold on, plot(f_LH_Exposure{1},mean(Data(Restrict(Spectrotsd_LH_Exposure(1),REMEpoch_Exposure(1)))),'r')
hold on, plot(f_LH_Baseline2{1},mean(Data(Restrict(Spectrotsd_LH_Baseline2(1),REMEpoch_Baseline2(1)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC REM (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,2), plot(f_LH_Baseline1{1},mean(Data(Restrict(Spectrotsd_LH_Baseline1(1),NREMEpoch_Baseline1(1)))),'b')
hold on, plot(f_LH_Exposure{1},mean(Data(Restrict(Spectrotsd_LH_Exposure(1),NREMEpoch_Exposure(1)))),'r')
hold on, plot(f_LH_Baseline2{1},mean(Data(Restrict(Spectrotsd_LH_Baseline2(1),NREMEpoch_Baseline2(1)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC NREM (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,3), plot(f_LH_Baseline1{1},mean(Data(Restrict(Spectrotsd_LH_Baseline1(1),Wake_Baseline1(1)))),'b')
hold on, plot(f_LH_Exposure{1},mean(Data(Restrict(Spectrotsd_LH_Exposure(1),Wake_Exposure(1)))),'r')
hold on, plot(f_LH_Baseline2{1},mean(Data(Restrict(Spectrotsd_LH_Baseline2(1),Wake_Baseline2(1)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC Wake (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,4), plot(f_LH_Baseline1{1},mean(Data(Spectrotsd_LH_Baseline1(1))),'b')
hold on, plot(f_LH_Exposure{1},mean(Data(Spectrotsd_LH_Exposure(1))),'r')
hold on, plot(f_LH_Baseline2{1},mean(Data(Spectrotsd_LH_Baseline2(1))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC All (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,5), plot(f_LH_Baseline1{2},mean(Data(Restrict(Spectrotsd_LH_Baseline1(2),REMEpoch_Baseline1(2)))),'b')
hold on, plot(f_LH_Exposure{2},mean(Data(Restrict(Spectrotsd_LH_Exposure(2),REMEpoch_Exposure(2)))),'r')
hold on, plot(f_LH_Baseline2{2},mean(Data(Restrict(Spectrotsd_LH_Baseline2(2),REMEpoch_Baseline2(2)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC REM (M926)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,6), plot(f_LH_Baseline1{2},mean(Data(Restrict(Spectrotsd_LH_Baseline1(2),NREMEpoch_Baseline1(2)))),'b')
hold on, plot(f_LH_Exposure{2},mean(Data(Restrict(Spectrotsd_LH_Exposure(2),NREMEpoch_Exposure(2)))),'r')
hold on, plot(f_LH_Baseline2{2},mean(Data(Restrict(Spectrotsd_LH_Baseline2(2),NREMEpoch_Baseline2(2)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC NREM (M926)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,7), plot(f_LH_Baseline1{2},mean(Data(Restrict(Spectrotsd_LH_Baseline1(2),Wake_Baseline1(2)))),'b')
hold on, plot(f_LH_Exposure{2},mean(Data(Restrict(Spectrotsd_LH_Exposure(2),Wake_Exposure(2)))),'r')
hold on, plot(f_LH_Baseline2{2},mean(Data(Restrict(Spectrotsd_LH_Baseline2(2),Wake_Baseline2(2)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC Wake (M926)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,8), plot(f_LH_Baseline1{2},mean(Data(Spectrotsd_LH_Baseline1(2))),'b')
hold on, plot(f_LH_Exposure{2},mean(Data(Spectrotsd_LH_Exposure(2))),'r')
hold on, plot(f_LH_Baseline2{2},mean(Data(Spectrotsd_LH_Baseline2(2))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('HPC All (M926)')
xlabel('Frequency')
ylabel('Amplitude')

cd (Dir_figures)
savefig(fullfile('Low frequency spectrograms HPC.fig'))


%% Spectres High OB

%M923
figure
subplot(3,1,1)
imagesc(SpectroB_Baseline1{1}{2},SpectroB_Baseline1{1}{3},10*log10(SpectroB_Baseline1{1}{1}')), axis xy
title('High frequency spectrum of the OB Baseline 1 M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
subplot(3,1,2)
imagesc(SpectroB_Exposure{1}{2},SpectroB_Exposure{1}{3},10*log10(SpectroB_Exposure{1}{1})'), axis xy
title('High frequency spectrum of the OB Exposure M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
subplot(3,1,3)
imagesc(SpectroB_Baseline2{1}{2},SpectroB_Baseline2{1}{3},10*log10(SpectroB_Baseline2{1}{1})'), axis xy
title('High frequency spectrum of the OB Baseline 2 M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
cd (Dir_figures)
savefig(fullfile('High frequency spectrum of the OB M923.fig'))
close all

%M926
figure
subplot(3,1,1)
imagesc(SpectroB_Baseline1{2}{2},SpectroB_Baseline1{2}{3},10*log10(SpectroB_Baseline1{2}{1})'), axis xy
title('High frequency spectrum of the OB Baseline 1 M926')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
subplot(3,1,2)
imagesc(SpectroB_Exposure{2}{2},SpectroB_Exposure{2}{3},10*log10(SpectroB_Exposure{2}{1})'), axis xy
title('High frequency spectrum of the OB Exposure M926')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
subplot(3,1,3)
imagesc(SpectroB_Baseline2{2}{2},SpectroB_Baseline2{2}{3},10*log10(SpectroB_Baseline2{2}{1})'), axis xy
title('High frequency spectrum of the OB Baseline 2 M923')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
cd (Dir_figures)
savefig(fullfile('High frequency spectrum of the OB M926.fig'))


%% Spectrogrammes High OB

figure
subplot(2,4,1), plot(f_HB_Baseline1{1},mean(Data(Restrict(Spectrotsd_HB_Baseline1(1),REMEpoch_Baseline1(1)))),'b')
hold on, plot(f_HB_Exposure{1},mean(Data(Restrict(Spectrotsd_HB_Exposure(1),REMEpoch_Exposure(1)))),'r')
hold on, plot(f_HB_Baseline2{1},mean(Data(Restrict(Spectrotsd_HB_Baseline2(1),REMEpoch_Baseline2(1)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB REM (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,2), plot(f_HB_Baseline1{1},mean(Data(Restrict(Spectrotsd_HB_Baseline1(1),NREMEpoch_Baseline1(1)))),'b')
hold on, plot(f_HB_Exposure{1},mean(Data(Restrict(Spectrotsd_HB_Exposure(1),NREMEpoch_Exposure(1)))),'r')
hold on, plot(f_HB_Baseline2{1},mean(Data(Restrict(Spectrotsd_HB_Baseline2(1),NREMEpoch_Baseline2(1)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB NREM (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,3), plot(f_HB_Baseline1{1},mean(Data(Restrict(Spectrotsd_HB_Baseline1(1),Wake_Baseline1(1)))),'b')
hold on, plot(f_HB_Exposure{1},mean(Data(Restrict(Spectrotsd_HB_Exposure(1),Wake_Exposure(1)))),'r')
hold on, plot(f_HB_Baseline2{1},mean(Data(Restrict(Spectrotsd_HB_Baseline2(1),Wake_Baseline2(1)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB Wake (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,4), plot(f_HB_Baseline1{1},mean(Data(Spectrotsd_HB_Baseline1(1))),'b')
hold on, plot(f_HB_Exposure{1},mean(Data(Spectrotsd_HB_Exposure(1))),'r')
hold on, plot(f_HB_Baseline2{1},mean(Data(Spectrotsd_HB_Baseline2(1))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB All (M923)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,5), plot(f_HB_Baseline1{2},mean(Data(Restrict(Spectrotsd_HB_Baseline1(2),REMEpoch_Baseline1(2)))),'b')
hold on, plot(f_HB_Exposure{2},mean(Data(Restrict(Spectrotsd_HB_Exposure(2),REMEpoch_Exposure(2)))),'r')
hold on, plot(f_HB_Baseline2{2},mean(Data(Restrict(Spectrotsd_HB_Baseline2(2),REMEpoch_Baseline2(2)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB REM (M926)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,6), plot(f_HB_Baseline1{2},mean(Data(Restrict(Spectrotsd_HB_Baseline1(2),NREMEpoch_Baseline1(2)))),'b')
hold on, plot(f_HB_Exposure{2},mean(Data(Restrict(Spectrotsd_HB_Exposure(2),NREMEpoch_Exposure(2)))),'r')
hold on, plot(f_HB_Baseline2{2},mean(Data(Restrict(Spectrotsd_HB_Baseline2(2),NREMEpoch_Baseline2(2)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB NREM (M926)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,7), plot(f_HB_Baseline1{2},mean(Data(Restrict(Spectrotsd_HB_Baseline1(2),Wake_Baseline1(2)))),'b')
hold on, plot(f_HB_Exposure{2},mean(Data(Restrict(Spectrotsd_HB_Exposure(2),Wake_Exposure(2)))),'r')
hold on, plot(f_HB_Baseline2{2},mean(Data(Restrict(Spectrotsd_HB_Baseline2(2),Wake_Baseline2(2)))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB Wake (M926)')
xlabel('Frequency')
ylabel('Amplitude')

subplot(2,4,8), plot(f_HB_Baseline1{2},mean(Data(Spectrotsd_HB_Baseline1(2))),'b')
hold on, plot(f_HB_Exposure{2},mean(Data(Spectrotsd_HB_Exposure(2))),'r')
hold on, plot(f_HB_Baseline2{2},mean(Data(Spectrotsd_HB_Baseline2(2))),'k')
legend('Baseline 1','Exposure','Baseline 2')
title('OB All (M926)')
xlabel('Frequency')
ylabel('Amplitude')

cd (Dir_figures)
savefig(fullfile('High frequency spectrograms OB.fig'))


%% Calcul du spectre high & low PFC deep et sup ET low bulb
% On regroupe tous les path
for i=1:length(Dir_Baseline1.path);
    path{i}=Dir_Baseline1.path{i}{1};
end
for i=1:length(Dir_Exposure.path);
    path{i+length(Dir_Baseline1.path)}=Dir_Exposure.path{i}{1};
end
for i=1:length(Dir_Baseline2.path);
    path{i+length(Dir_Baseline1.path)+length(Dir_Baseline2.path)}=Dir_Baseline2.path{i}{1};
end


for i=1:length(path);
    cd(path{i});
    if exist('ChannelsToAnalyse/PFCx_deep.mat','file')==2
        load('ChannelsToAnalyse/PFCx_deep.mat')
        channel_PFC_deep=channel;
        load('ChannelsToAnalyse/PFCx_sup.mat')
        channel_PFC_sup=channel;
        load('ChannelsToAnalyse/Bulb_deep.mat')
        channel_Bulb=channel;
    else
        error('No PFC deep channel, cannot calculate spectrogram');
    end
    
    foldername=pwd;
    if foldername(end)~=filesep
        foldername(end+1)=filesep;
    end
    
% PFC Deep High
    if ~(exist('PFC_deep_High_Spectrum.mat', 'file') == 2)
        fprintf('Calculting PFC deep High spectrum %d/%d\n',[i,length(path)])
        HighSpectrum(foldername,channel_PFC_deep,'PFC_deep');
    else
        disp('PFC deep High spectrum already calculated')
    end
% PFC Deep Low    
    if ~(exist('PFC_deep_Low_Spectrum.mat', 'file') == 2)
        fprintf('Calculting PFC deep Low spectrum %d/%d\n',[i,length(path)])
        LowSpectrumSB(foldername,channel_PFC_deep,'PFC_deep');
    else
        disp('PFC deep Low spectrum already calculated')
    end
% PFC Sup High    
    if ~(exist('PFC_sup_High_Spectrum.mat', 'file') == 2)
        fprintf('Calculting PFC sup High spectrum %d/%d\n',[i,length(path)])
        HighSpectrum(foldername,channel_PFC_sup,'PFC_sup');
    elseplot(f_LH_Exposure{1},mean(Data(Restrict(Spectrotsd_LH_Exposure(1),REMEpoch_Exposure(1)))),'r')
        disp('PFC sup Low spectrum already calculated')
    end
% PFC Sup Low    
    if ~(exist('PFC_sup_Low_Spectrum.mat', 'file') == 2)
        fprintf('Calculting PFC sup Low spectrum %d/%d\n',[i,length(path)])
        LowSpectrumSB(foldername,channel_PFC_sup,'PFC_sup');
    else
        disp('PFC sup Low spectrum already calculated')
    end   
% Bulb low
    if ~(exist('B_Low_Spectrum.mat', 'file') == 2)
        fprintf('Calculting Bulb Low spectrum %d/%d\n',[i,length(path)])
        LowSpectrumSB(foldername,channel_Bulb,'B');
    else
        disp('Bulb Low spectrum already calculated')
    end  
    
end


%% Loader les spectres

for i=1:length(Dir_Baseline1.path);
    cd(Dir_Baseline1.path{i}{1});
%PFC deep high
    fprintf('Loading PFC deep High spectrum Baseline 1 %d/%d...\n',[i,length(Dir_Baseline1.path)])
    load('PFC_deep_High_Spectrum.mat')
    SpectroHPFC_deep_Baseline1{i}=Spectro;
    Spectrotsd_HPFC_deep_Baseline1(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_HPFC_deep_Baseline1{i}=Spectro{3};
% %PFC deep low
%     fprintf('Loading PFC deep Low spectrum Baseline 1 %d/%d...\n',[i,length(Dir_Baseline1.path)])
%     load('PFC_deep_Low_Spectrum.mat')
%     SpectroLPFC_deep_Baseline1{i}=Spectro;
%     Spectrotsd_LPFC_deep_Baseline1(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LPFC_deep_Baseline1{i}=Spectro{3};
% %PFC sup high
%     fprintf('Loading PFC sup High spectrum Baseline 1 %d/%d...\n',[i,length(Dir_Baseline1.path)])
%     load('PFC_sup_High_Spectrum.mat')
%     SpectroHPFC_sup_Baseline1{i}=Spectro;
%     Spectrotsd_HPFC_sup_Baseline1(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_HPFC_sup_Baseline1{i}=Spectro{3};
% %PFC sup low
%     fprintf('Loading PFC sup Low spectrum Baseline 1 %d/%d...\n',[i,length(Dir_Baseline1.path)])
%     load('PFC_sup_Low_Spectrum.mat')
%     SpectroLPFC_sup_Baseline1{i}=Spectro;
%     Spectrotsd_LPFC_sup_Baseline1(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LPFC_sup_Baseline1{i}=Spectro{3};
% %Bulb low
%     fprintf('Loading OB low spectrum Baseline 1 %d/%d...\n',[i,length(Dir_Baseline1.path)])
%     load('B_High_Spectrum.mat')
%     SpectroLB_Baseline1{i}=Spectro;
%     Spectrotsd_LB_Baseline1(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LB_Baseline1{i}=Spectro{3};

    
end

for i=1:length(Dir_Exposure.path);
    cd(Dir_Exposure.path{i}{1});
%PFC deep high
    fprintf('Loading PFC deep High spectrum Exposure %d/%d...\n',[i,length(Dir_Exposure.path)])
    load('PFC_deep_High_Spectrum.mat')
    SpectroHPFC_deep_Exposure{i}=Spectro;
    Spectrotsd_HPFC_deep_Exposure(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_HPFC_deep_Exposure{i}=Spectro{3};
% %PFC deep low
%     fprintf('Loading PFC deep Low spectrum Exposure %d/%d...\n',[i,length(Dir_Exposure.path)])
%     load('PFC_deep_Low_Spectrum.mat')
%     SpectroLPFC_deep_Exposure{i}=Spectro;
%     Spectrotsd_LPFC_deep_Exposure(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LPFC_deep_Exposure{i}=Spectro{3};
% %PFC sup high
%     fprintf('Loading PFC sup High spectrum Exposure %d/%d...\n',[i,length(Dir_Exposure.path)])
%     load('PFC_sup_High_Spectrum.mat')
%     SpectroHPFC_sup_Exposure{i}=Spectro;
%     Spectrotsd_HPFC_sup_Exposure(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_HPFC_sup_Exposure{i}=Spectro{3};
% %PFC sup low
%     fprintf('Loading PFC sup Low spectrum Exposure %d/%d...\n',[i,length(Dir_Exposure.path)])
%     load('PFC_sup_Low_Spectrum.mat')
%     SpectroLPFC_sup_Exposure{i}=Spectro;
%     Spectrotsd_LPFC_sup_Exposure(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LPFC_sup_Exposure{i}=Spectro{3};
% %Bulb low
%     fprintf('Loading OB low spectrum Exposure %d/%d...\n',[i,length(Dir_Exposure.path)])
%     load('B_High_Spectrum.mat')
%     SpectroLB_Exposure{i}=Spectro;
%     Spectrotsd_LB_Exposure(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LB_Exposure{i}=Spectro{3};
    
    
end

for i=1:length(Dir_Baseline2.path);
    cd(Dir_Baseline2.path{i}{1});
%PFC deep high
    fprintf('Loading PFC deep High spectrum Baseline 2 %d/%d...\n',[i,length(Dir_Baseline2.path)])
    load('PFC_deep_High_Spectrum.mat')
    SpectroHPFC_deep_Baseline2{i}=Spectro;
    Spectrotsd_HPFC_deep_Baseline2(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
    f_HPFC_deep_Baseline2{i}=Spectro{3};
% %PFC deep low
%     fprintf('Loading PFC deep Low spectrum Baseline 2 %d/%d...\n',[i,length(Dir_Baseline2.path)])
%     load('PFC_deep_Low_Spectrum.mat')
%     SpectroLPFC_deep_Baseline2{i}=Spectro;
%     Spectrotsd_LPFC_deep_Baseline2(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LPFC_deep_Baseline2{i}=Spectro{3};
% %PFC sup high
%     fprintf('Loading PFC sup High spectrum Baseline 2 %d/%d...\n',[i,length(Dir_Baseline2.path)])
%     load('PFC_sup_High_Spectrum.mat')
%     SpectroHPFC_sup_Baseline2{i}=Spectro;
%     Spectrotsd_HPFC_sup_Baseline2(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_HPFC_sup_Baseline2{i}=Spectro{3};
% %PFC sup low
%     fprintf('Loading PFC sup Low spectrum Baseline 2 %d/%d...\n',[i,length(Dir_Baseline2.path)])
%     load('PFC_sup_Low_Spectrum.mat')
%     SpectroLPFC_sup_Baseline2{i}=Spectro;
%     Spectrotsd_LPFC_sup_Baseline2(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LPFC_sup_Baseline2{i}=Spectro{3};
% %Bulb low
%     fprintf('Loading OB low spectrum Baseline 2 %d/%d...\n',[i,length(Dir_Baseline2.path)])
%     load('B_High_Spectrum.mat')
%     SpectroLB_Baseline2{i}=Spectro;
%     Spectrotsd_LB_Baseline2(i)=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
%     f_LB_Baseline2{i}=Spectro{3};
    
    
end
