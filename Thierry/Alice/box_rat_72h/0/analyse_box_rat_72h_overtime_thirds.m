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
end

%Load Exposure
Dir_Exposure=PathForExperiments_TG('box_rat_72h_Exposure');

for i=1:length(Dir_Exposure.path);
    cd(Dir_Exposure.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','SWSEpoch','SWSEpoch','Sleep');
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
end

%Load Baseline2
Dir_Baseline2=PathForExperiments_TG('box_rat_72h_Baseline2');

for i=1:length(Dir_Baseline2.path);
    cd(Dir_Baseline2.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep');
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
    
end


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
PercNREMSecThird_Baseline2
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