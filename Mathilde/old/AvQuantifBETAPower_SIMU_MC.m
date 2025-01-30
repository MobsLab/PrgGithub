Dir{1}=PathForExperiments_Opto('Baseline_20Hz');

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    [SpectroREMsimu,SpectroSWSsimu,SpectroWakesimu,facREMsimu,facSWSsimu,facWakesimu,valBetaREMsimu,valBetaSWSsimu,valBetaWakesimu,freqSimu,tempsSimu]=PlotBETAPowerOverTime_SingleMouse_SIMU_MC;
    
    SpREMsimu{i}=SpectroREMsimu;
    SpSWSsimu{i}=SpectroSWSsimu;
    SpWakesimu{i}=SpectroWakesimu;
    
    FacREMsimu{i}=facREMsimu;
    FacSWSsimu{i}=facSWSsimu;
    FacWakesimu{i}=facWakesimu;
    
    betaREMsimu{i}=valBetaREMsimu;
    betaSWSsimu{i}=valBetaSWSsimu;
    betaWakesimu{i}=valBetaWakesimu;
    
    
    for j=1:length(betaREMsimu)
        AvBetaREMsimu(j,:)=nanmean(betaREMsimu{j}(:,:),1);
    end
    for j=1:length(betaSWSsimu)
        AvBetaSWSsimu(j,:)=nanmean(betaSWSsimu{j}(:,:),1);
    end
    for j=1:length(betaWakesimu)
        AvBetaWakeSimu(j,:)=nanmean(betaWakesimu{j}(:,:),1);
    end
    
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end

%% mean

dataFacREMsimu=cat(3,FacREMsimu{:});
avFacREMsimu=nanmean(dataFacREMsimu,3);

dataFacSWSsimu=cat(3,FacSWSsimu{:});
avFacSWSsimu=nanmean(dataFacSWSsimu,3);

dataFacWakesimu=cat(3,FacWakesimu{:});
avFacWakesimu=nanmean(dataFacWakesimu,3);


dataSpREMsimu=cat(3,SpREMsimu{:}); % to average spectro across mice
dataSpSwssimu=cat(3,SpSWSsimu{:});
dataSpWakesimu=cat(3,SpWakesimu{:});
avdataSpREMsimu=nanmean(dataSpREMsimu,3);
avdataSpSWSsimu=nanmean(dataSpSwssimu,3);
avdataSpWakesimu=nanmean(dataSpWakesimu,3);

%%
% 
runfac=4;
betaIdx=find(freqSimu>21&freqSimu<25);
beforeidx=find(tempsSimu>-30&tempsSimu<0);
duringidx=find(tempsSimu>0&tempsSimu<30);

figure('color',[1 1 1]), subplot(3,5,[1,2]), imagesc(tempsSimu,freqSimu, avdataSpREMsimu),  caxis([1E3 4E3]),axis xy,colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
% xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB REM simu')
% subplot(3,5,[6,7]), imagesc(tempsSimu,freqSimu, avdataSpSWSsimu), axis xy, caxis([1E3 4E3]), colormap(jet)
% line([0 0], ylim,'color','w','linestyle',':')
% xlim([-60 +60])
% % xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% colorbar
% title('HPC NREM simu')
subplot(3,5,[6,7]), imagesc(tempsSimu,freqSimu, avdataSpWakesimu), axis xy, caxis([1e+03 9e+03]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-40 +40])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB Wake simu')

subplot(3,5,[3:4,9:10]), hold on, 
% shadedErrorBar(tempsSimu,avdataSpSWSsimu(betaIdx,:)/avFacSWSsimu,{@mean,@stdError},'-r',1);
shadedErrorBar(tempsSimu,avdataSpREMsimu(betaIdx,:)/avFacREMsimu,{@mean,@stdError},'-g',1);
shadedErrorBar(tempsSimu,avdataSpWakesimu(betaIdx,:)/avFacWakesimu,{@mean,@stdError},'-b',1);
xlim([-40 +40])
xlabel('Time (s)')
ylim([0 1.8])
ylabel('beta power')
line([0 0], ylim,'color','k','linestyle',':')


subplot(3,5,14),PlotErrorBarN_KJ({mean(AvBetaREMsimu(:,beforeidx)/avFacREMsimu,2), mean(AvBetaREMsimu(:,duringidx)/avFacREMsimu,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 2])
ylabel('beta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
% subplot(3,5,14),PlotErrorBarN_KJ({mean(AvBetaSWSsimu(:,beforeidx)/avFacSWSsimu,2), mean(AvBetaSWSsimu(:,duringidx)/avFacSWSsimu,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% ylim([0 1.8])
% % ylabel('theta power')
% xticks(1:2)
% xticklabels({'Before','During'});
% title('NREM')
subplot(3,5,15),PlotErrorBarN_KJ({mean(AvBetaWakeSimu(:,beforeidx)/avFacWakesimu,2), mean(AvBetaWakeSimu(:,duringidx)/avFacWakesimu,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.6])
% ylabel('theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')

