% Dir{2}=PathForExperiments_Opto_Septum('Stim_20Hz');
Dir{2}=PathForExperiments_Opto('Stim_20Hz');
% Dir{2}=PathForExperiments_Opto('Baseline_20Hz');
% Dir{2}=PathForExperiments_Opto_Septum('Sham_20Hz');

number=1;
for i=1:length(Dir{2}.path)     % each mouse / recording
    cd(Dir{2}.path{i}{1});
    
    [SpectroREM,SpectroSWS,SpectroWake,facREM,facSWS,facWake,valThetaREM,valThetaSWS,valThetaWake,freq,temps]=PlotThetaPowerOverTime_Septum_SingleMouse_TG;
    SpREM{i}=SpectroREM;
    SpSWS{i}=SpectroSWS;
    SpWake{i}=SpectroWake;

    
    FacREM{i}=facREM;
    FacSWS{i}=facSWS;
    FacWake{i}=facWake;


    thetaREM{i}=valThetaREM;
    thetaSWS{i}=valThetaSWS;
    thetaWake{i}=valThetaWake;

    
    for j=1:length(thetaREM)
        AvThetaREM(j,:)=nanmean(thetaREM{j}(:,:),1);
    end
    for j=1:length(thetaSWS)
        AvThetaSWS(j,:)=nanmean(thetaSWS{j}(:,:),1);
    end
    for j=1:length(thetaWake)
        AvThetaWake(j,:)=nanmean(thetaWake{j}(:,:),1);
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
subplot(3,6,[1,2]), imagesc(temps,freq, avdataSpREM),caxis([0 3.5]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC REM')
subplot(3,6,[3,4]), imagesc(temps,freq, avdataSpSWS), axis xy, caxis([0 3.5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle',':')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC NREM')
subplot(3,6,[5,6]), imagesc(temps,freq, avdataSpWake),caxis([0 3.5]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC Wake')


runfac=4;
thetaIdx=find(freq>6&freq<9);
beforeidx=find(temps>-30&temps<0);
duringidx=find(temps>0&temps<30);

% subplot(3,4,[3:4,7:8])
subplot(3,6,[7,8,9,10,11,12]), hold on,
shadedErrorBar(temps,avdataSpSWS(thetaIdx,:)/avFacSWS,{@mean,@stdError},'-r',1);
shadedErrorBar(temps,avdataSpREM(thetaIdx,:)/avFacREM,{@mean,@stdError},'-g',1);
shadedErrorBar(temps,avdataSpWake(thetaIdx,:)/avFacWake,{@mean,@stdError},'-b',1);
xlim([-30 +30])
xlabel('Time (s)')
ylim([0 1.5])
ylabel('theta power')
line([0 0], ylim,'color','k','linestyle',':')


% subplot(3,4,11),
subplot(3,6,[13,14]),PlotErrorBarN_KJ({mean(AvThetaREM(:,beforeidx)/avFacREM,2), mean(AvThetaREM(:,duringidx)/avFacREM,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.6])
ylabel('theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
subplot(3,6,[15,16]),PlotErrorBarN_KJ({mean(AvThetaSWS(:,beforeidx)/avFacSWS,2), mean(AvThetaSWS(:,duringidx)/avFacSWS,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.6])
ylabel('theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
subplot(3,6,[17,18]),PlotErrorBarN_KJ({mean(AvThetaWake(:,beforeidx)/avFacWake,2), mean(AvThetaWake(:,duringidx)/avFacWake,2)},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.6])
ylabel('theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')
