%Dir{2}=PathForExperiments_Opto_Septum('Stim_20Hz');
Dir{2}=PathForExperiments_Opto_Septum('Sham_20Hz');


number=1;
for i=1:length(Dir{2}.path)     % each mouse / recording
    cd(Dir{2}.path{i}{1});
    
    [SpectroREM,SpectroSWS,SpectroWake,facREM,facSWS,facWake,valBetaREM,valBetaSWS,valBetaWake,freqB,temps]=PlotBETAPowerOverTime_Septum_SingleMouse_TG;
    SpREM{i}=SpectroREM;
    SpSWS{i}=SpectroSWS;
    SpWake{i}=SpectroWake;
    
    FacREM{i}=facREM;
    FacSWS{i}=facSWS;
    FacWake{i}=facWake;

    betaREM{i}=valBetaREM;
    betaSWS{i}=valBetaSWS;
    betaWake{i}=valBetaWake;
    
    
    for j=1:length(betaREM)
        AvBetaREM(j,:)=nanmean(betaREM{j}(:,:),1);
    end
    for j=1:length(betaSWS)
        AvBetaSWS(j,:)=nanmean(betaSWS{j}(:,:),1);
    end
    for j=1:length(betaWake)
        AvBetaWake(j,:)=nanmean(betaWake{j}(:,:),1);
    end
    
    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end
%%
dataFacREM=cat(3,FacREM{:});
avFacREM=nanmean(dataFacREM,3);

dataFacSWS=cat(3,FacSWS{:});
avFacSWS=nanmean(dataFacSWS,3);

dataFacWake=cat(3,FacWake{:});
avFacWake=nanmean(dataFacWake,3);


dataSpREM=cat(3,SpREM{:});
dataSpSws=cat(3,SpSWS{:});
dataSpWake=cat(3,SpWake{:});

avdataSpREM=nanmean(dataSpREM,3);
avdataSpSWS=nanmean(dataSpSws,3);
avdataSpWake=nanmean(dataSpWake,3);

%%

figure('color',[1 1 1]),
% subplot(3,4,[1,2])
subplot(3,6,[1,2]), imagesc(temps,freqB, avdataSpREM), caxis([1E3 4E3]),axis xy,colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB REM ')
subplot(3,6,[3,4]), imagesc(temps,freqB, avdataSpSWS), axis xy, caxis([1E3 4E3]), colormap(jet)
line([0 0], ylim,'color','w','linestyle',':')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC NREM')
% subplot(3,6,[5,6])
subplot(3,6,[5,6]), imagesc(temps,freqB, avdataSpWake), axis xy, caxis([1E3 4E3]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB Wake')


runfac=4;
betaIdx=find(freqB>21&freqB<25);
beforeidx=find(temps>-10&temps<0);
duringidx=find(temps>0&temps<10);

% subplot(3,4,[3:4,7:8])
subplot(3,6,[7:12]), hold on,
shadedErrorBar(temps,avdataSpSWS(betaIdx,:)/avFacSWS,{@mean,@stdError},'-r',1);
shadedErrorBar(temps,avdataSpREM(betaIdx,:)/avFacREM,{@mean,@stdError},'-g',1);
shadedErrorBar(temps,avdataSpWake(betaIdx,:)/avFacWake,{@mean,@stdError},'-b',1);
xlim([-30 +30])
line([0 0], ylim,'color','k','linestyle',':')
xlabel('Time (s)')
ylim([0 1.8])
ylabel('beta power')


% subplot(3,4,11),
subplot(3,6,[13,14]),PlotErrorBarN_KJ({mean(AvBetaREM(:,beforeidx)/avFacREM,2), mean(AvBetaREM(:,duringidx)/avFacREM,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 2])
ylabel('beta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
subplot(3,6,[15,16]),PlotErrorBarN_KJ({mean(AvBetaSWS(:,beforeidx)/avFacSWS,2), mean(AvBetaSWS(:,duringidx)/avFacSWS,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.8])
ylabel('theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
subplot(3,6,[17,18]),PlotErrorBarN_KJ({mean(AvBetaWake(:,beforeidx)/avFacWake,2), mean(AvBetaWake(:,duringidx)/avFacWake,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 2])
ylabel('theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')

