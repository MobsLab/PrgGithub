Dir{2}=PathForExperiments_Opto('Stim_20Hz');

number=1;
for i=1:length(Dir{2}.path)     % each mouse / recording
    cd(Dir{2}.path{i}{1});

    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    REMTime{i}=REMEpoch;
    wakeTime{i}=Wake;
    SWSTime{i}=SWSEpoch;
    load H_Low_Spectrum
    SpectroH{i}=Spectro;
    freqR=Spectro{3};
    sptsdH(i)= tsd(SpectroH{i}{2}*1e4, SpectroH{i}{1});

    [Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to find optogenetic stimulations
    events{i}=Stim;
    
    % PFC average spectro during wake and REM sleep
    [MH_wake{i},SH_wake{i},tps]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(ts(events{i}*1E4),wakeTime{i}),500,500,0);
    [MH_REM{i},SH_REM{i},tps]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(ts(events{i}*1E4),REMTime{i}),500,500,0);
    [MH_SWS{i},SH_SWS{i},tps]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(ts(events{i}*1E4),SWSTime{i}),500,500,0);
    
    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end

% mean
data_MH_wake=cat(3,MH_wake{:});               
data_MH_REM=cat(3,MH_REM{:});
data_MH_SWS=cat(3,MH_SWS{:});
avdata_MH_wake=nanmean(data_MH_wake,3);
avdata_MH_REM=nanmean(data_MH_REM,3);
avdata_MH_SWS=nanmean(data_MH_SWS,3);


runfac=4; 

temps=tps/1E3;
SpectroREM=avdata_MH_REM;
SpectroSWS=avdata_MH_SWS;
SpectroWake=avdata_MH_wake;

freqR=[1:size(SpectroREM,1)]/size(SpectroREM,1)*20;
% freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*20;
% freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*20;


idx1=find(freqR>6&freqR<9);
% idx2=find(freqR>3&freqR<6);
tpsidx=find(temps>-30&temps<0);

beforeStim=find(temps>-30&temps<0);
duringStim=find(temps>0&temps<30);


% ratio=mean(SpectroREM(idx1,:),1)./mean(SpectroREM(idx2,:),1);
valThetaREM=mean(SpectroREM(idx1,:),1);
valThetaSWS=mean(SpectroSWS(idx1,:),1);
valThetaWake=mean(SpectroWake(idx1,:),1);


facREM=mean(valThetaREM(tpsidx));
stdfacREM=std(valThetaREM(tpsidx));
facSWS=mean(valThetaSWS(tpsidx));
stdfacSWS=std(valThetaSWS(tpsidx));
facWake=mean(valThetaWake(tpsidx));
stdfacWake=std(valThetaWake(tpsidx));
%%

figure('color',[1 1 1]), 
subplot(231), imagesc(temps,freqR, SpectroREM), axis xy, caxis([0 5E4]), colormap(jet)
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC REM')
subplot(232), imagesc(temps,freqR, SpectroSWS), axis xy, caxis([0 5E4]), colormap(jet)
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC NREM')
subplot(233), imagesc(temps,freqR, SpectroWake), axis xy, caxis([0 5E4]), colormap(jet)
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC Wake')

subplot(234),plot(temps,mean(SpectroREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
plot(temps,runmean(mean(SpectroREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
xlim([-30 +30])
xlabel('time (s)')
ylim([0.4 1.2])
ylabel('theta power')
line([0 0], ylim,'color','k','linestyle',':')

subplot(235),plot(temps,mean(SpectroSWS(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
plot(temps,runmean(mean(SpectroSWS(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
xlim([-30 +30])
xlabel('time (s)')
ylim([0.4 1.2])
ylabel('theta power')
line([0 0], ylim,'color','k','linestyle',':')

subplot(236),plot(temps,mean(SpectroWake(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
plot(temps,runmean(mean(SpectroWake(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
xlim([-30 +30])
xlabel('time (s)')
ylim([0.4 1.2])
ylabel('theta power')
line([0 0], ylim,'color','k','linestyle',':')


%%
figure, hold on,
shadedErrorBar(temps,SpectroSWS(idx1,:)/facSWS,{@mean,@stdError},'-r',1);
shadedErrorBar(temps,SpectroREM(idx1,:)/facREM,{@mean,@stdError},'-g',1);
shadedErrorBar(temps,SpectroWake(idx1,:)/facWake,{@mean,@stdError},'-b',1);
line([0 0], ylim,'color','k','linestyle',':')
xlim([-30 +30])
xlabel('Time (s)')
ylim([0.4 1.4])
ylabel('theta power')

%%
% bar plot theta power before VS during the stim
figure,
subplot(131),PlotErrorBarN_KJ({mean(SpectroREM(idx1,beforeStim)/facREM), mean(SpectroREM(idx1,duringStim)/facREM)},'newfig',0,'paired',1,'ShowSigstar','sig');

% 
% % PlotErrorBar2(mean(ThetaREM(:,BeforeStim),2),mean(ThetaREM(:,DuringStim),2),0);
% ylim([0 4e+04])
% ylabel('Theta power')
% xticks(1:2)
% xticklabels({'Before','During'});
% title('REM')
% subplot(132),PlotErrorBarN_KJ({mean(SpectroSWS(idx1,:)/facSWS), mean(SpectroSWS(idx1,:)/facSWS)},'newfig',0,'paired',1,'ShowSigstar','sig');
% % PlotErrorBar2(mean(ThetaSWS(:,BeforeStim),2),mean(ThetaSWS(:,DuringStim),2),0);
% ylim([0 4e+04])
% ylabel('Theta power')
% xticks(1:2)
% xticklabels({'Before','During'});
% title('NREM')
% subplot(133),PlotErrorBarN_KJ({mean(ThetaWake(:,BeforeStim),2), mean(ThetaWake(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% % PlotErrorBar2(mean(ThetaWake(:,BeforeStim),2),mean(ThetaWake(:,DuringStim),2),0);
% ylim([0 4e+04])
% ylabel('Theta power')
% xticks(1:2)
% xticklabels({'Before','During'});
% title('Wake')
