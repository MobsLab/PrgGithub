%% input dir
DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [733 1137 1136 648 1074]);%648

%% get data
%%control mice
for k=1:length(DirCtrl.path)
    cd(DirCtrl.path{k}{1});
        %%load sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        c{k} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    elseif exist('SleepScoring_Accelero.mat')
        c{k} = load('SleepScoring_Accelero', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    else
    end
    
    [M_REM_Delt] = GetDeltasDensityOpto_MC(c{k}.WakeWiNoise,c{k}.SWSEpochWiNoise,c{k}.REMEpochWiNoise,'sws');
    deltas_ctrl{k}=M_REM_Delt;
end

%% opto mice
for i=1:length(DirOpto.path)
    cd(DirOpto.path{i}{1});
        %%load sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    elseif exist('SleepScoring_Accelero.mat')
        a{i} = load('SleepScoring_Accelero', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    else
    end
    
    [M_REM_Delt] = GetDeltasDensityOpto_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise,'sws');
    deltas_opto{i}=M_REM_Delt;
end

%% average accross mice
data_deltas_ctrl=cat(3,deltas_ctrl{:});
data_deltas_opto=cat(3,deltas_opto{:});


%% index to restrain time durinf the stim
idxduring=find(data_deltas_ctrl(:,1)>0&data_deltas_ctrl(:,1)<30);
idxbefore=find(data_deltas_ctrl(:,1)>-60&data_deltas_ctrl(:,1)<0);


%%
%% ripples : traces for each mouse + mean
figure,
plot(data_deltas_ctrl(:,1),runmean(squeeze(data_deltas_ctrl(:,2,:)),4),'color',[0.6 0.6 0.6]), hold on
plot(data_deltas_ctrl(:,1),nanmean(runmean(squeeze(data_deltas_ctrl(:,2,:)),4),2),'k','linewidth',2)

plot(data_deltas_opto(:,1),runmean(squeeze(data_deltas_opto(:,2,:)),4),'color',[0.6 0.6 0.6]), hold on
plot(data_deltas_opto(:,1),nanmean(runmean(squeeze(data_deltas_opto(:,2,:)),4),2),'k','linewidth',2)
% makepretty
xlim([-60 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')


%%


%%  MEAN ripples
% mean
data_delt_ctrl_mean = mean(data_deltas_ctrl(:,2,:),2);
data_delt_opto_mean = mean(data_deltas_opto(:,2,:),2);

% SEM
data_delt_ctrl_SEM = std(squeeze(data_delt_ctrl_mean)',1);
data_delt_opto_SEM = std(squeeze(data_delt_opto_mean)',1);

% to normalize
norm_ctrl=mean(mean(data_deltas_ctrl(20:40,2,:)));
norm_opto=mean(mean(data_deltas_opto(20:40,2,:)));


%%
col_ctrl=[.8 .8 .8];
col_chr2=[.3 .3 .3];
figure, subplot(1,3,[1,2])
shadedErrorBar(data_deltas_ctrl(:,1),runmean(mean(data_delt_ctrl_mean,3),3)/norm_ctrl,data_delt_ctrl_SEM','k',1), hold on
shadedErrorBar(data_deltas_opto(:,1),runmean(mean(data_delt_opto_mean,3),3)/norm_opto,data_delt_opto_SEM','b',1), hold on
makepretty
xlim([-20 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (deltas/s)')

subplot(1,3,[3])
PlotErrorBarN_KJ({mean(data_delt_ctrl_mean(idxduring,:))/norm_ctrl mean(data_delt_opto_mean(idxduring,:))/norm_opto}, 'paired',0, 'newfig',0,'showsigstar','none')
xticks([1 2])
xticklabels({'ctrl','opto'})
ylabel('Density (ripples/s)')
makepretty

% [h,p] = ttest2(mean(data_delt_ctrl_mean(idxduring,:))/norm_ctrl, mean(data_delt_opto_mean(idxduring,:))/norm_opto)
p=ranksum(mean(data_delt_ctrl_mean(idxduring,:))/norm_ctrl, mean(data_delt_opto_mean(idxduring,:))/norm_opto)


if p<0.05; sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);end

