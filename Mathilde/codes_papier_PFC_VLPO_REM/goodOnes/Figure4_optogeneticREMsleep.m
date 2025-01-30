%% input dir
DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [648 675 733 1136 1137]);


DirCtrl_ripp=PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirCtrl_ripp = RestrictPathForExperiment(DirCtrl_ripp, 'nMice', [1075 1111 1112 1180 1181]);
DirOpto_ripp=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto_ripp = RestrictPathForExperiment(DirOpto_ripp, 'nMice', [733 1137 1136 1109 1076]);


%% parameters
state = 'rem'; % to select in which state stimulations occured
TimeWindowAroundStim = -60:1:60; % time window around stimulations
MinDurBeforeStimOnset = 5; % minimal duration of bouts before stim onset (in sec)

%%parameters spectrograms
timeWindow = 20;
timeWindow15 = 15;
timeWindow20 = 20;

MinDurBeforeStim=1;
timebin = 1;

%% GET DATA - ctrl
number=1;
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    if exist('SleepScoring_OBGamma.mat') % load sleep scoring
        stage_ctrl{i} = load('SleepScoring_OBGamma.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','LowThetaEpochMC');
    else
        stage_ctrl{i} = load('SleepScoring_Accelero.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','LowThetaEpochMC');
    end
    durtotal_ctrl{i} = max([max(End(stage_ctrl{i}.WakeWiNoise)),max(End(stage_ctrl{i}.SWSEpochWiNoise))]);
    SleepStages{i} = PlotSleepStage(stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,0);

    %%get time of opto stim
    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise);
    stim_rem_ctrl{i} = FindOptoStimWithLongBout_MC(stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,'rem', MinDurBeforeStimOnset);
    stim_wake_ctrl{i} = FindOptoStimWithLongBout_MC(stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,'wake', MinDurBeforeStimOnset);
    stim_sws_ctrl{i} = FindOptoStimWithLongBout_MC(stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,'sws', MinDurBeforeStimOnset);
    
    durREMctrl(i)=mean(End(stage_ctrl{i}.REMEpochWiNoise)-Start(stage_ctrl{i}.REMEpochWiNoise))/1E4;
    numREMctrl(i)=length(End(stage_ctrl{i}.REMEpochWiNoise)-Start(stage_ctrl{i}.REMEpochWiNoise));

    %%Get time of opto stim in REM (with minimal duration of REM before
    %%stim onset)
    StimWithLongBout_ctrl{i} = FindOptoStimWithLongBout_MC(stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,state, MinDurBeforeStimOnset);
    [h{i},rg{i},vec{i}] = HistoSleepStagesTransitionsMathilde_MC(SleepStages{i}, ts(StimWithLongBout_ctrl{i}), TimeWindowAroundStim, 0);

    %%stages percentage around stim
    perc_aroundStim_ctrl{i} = h{i};
    perc_eveil_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,1);
    perc_REM_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,2);
    perc_SWS_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,3);
    
    %%PROBILITE
    same_epoch_ctrl{i} = intervalSet(0,durtotal_ctrl{i});
    [P_S_S, P_S_R, P_S_W, P_R_R, P_R_S, P_R_W, P_W_W, P_W_S, P_W_R] = Get_transition_probabilities_MC_VF...
        (stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,stage_ctrl{i}.WakeWiNoise, same_epoch_ctrl{i});
    prob_trans_WAKE_to_REM_ctrl(i)=P_W_R;
    prob_trans_REM_to_WAKE_ctrl(i)=P_R_W;
    prob_trans_SWSEpoch_to_WAKE_ctrl(i)=P_S_W;
    prob_trans_WAKE_to_SWSEpoch_ctrl(i)=P_W_S;
    prob_trans_SWSEpoch_to_REM_ctrl(i)=P_S_R;
    prob_trans_REM_to_SWSEpoch_ctrl(i)=P_R_S;
    prob_trans_REM_to_REM_ctrl(i)=P_R_R;
    prob_trans_SWS_to_SWS_ctrl(i)=P_S_S;
    prob_trans_WAKE_to_WAKE_ctrl(i)=P_W_W;
    
    %%SPECTROGRAM
    %%Get spectro triggered on stimulations in REM
    Spectro_H_Ctrl{i} = load('H_Low_Spectrum.mat','Spectro');
    [SpHREM,SpHSWS,SpHWake,time]=PlotSpectroAroundStim_SingleMouse_MC(Spectro_H_Ctrl{i}.Spectro, stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,stage_ctrl{i}.LowThetaEpochMC,stim_rem_ctrl{i});
    SpectroH_REM_Ctrl{i}=SpHREM;

    Spectro_P_Ctrl{i} = load('PFCx_deep_Low_Spectrum.mat','Spectro');
    [SpPREM,SpPSWS,SpPWake,time]=PlotSpectroAroundStim_SingleMouse_MC(Spectro_P_Ctrl{i}.Spectro, stage_ctrl{i}.WakeWiNoise,stage_ctrl{i}.SWSEpochWiNoise,stage_ctrl{i}.REMEpochWiNoise,stage_ctrl{i}.LowThetaEpochMC,stim_rem_ctrl{i});
    SpectroP_REM_Ctrl{i}=SpPREM;

    %%Restrict time to the time window (defined above)
    tps_ctrl{i} = time/1e3;
    beforeidx{i}=find(time/1e3>-timeWindow&time/1e3<0); 
    duringidx{i}=find(time/1e3>0&time/1e3<timeWindow);
    
    freq{i}=[1:size(SpectroH_REM_Ctrl{i},1)]/size(SpectroH_REM_Ctrl{i},1)*20;
    
    %%Select the frequency band of interest
    idxfreq_theta{i}=find(freq{i}>5&freq{i}<9); 
    idxfreq_delta{i}=find(freq{i}>1&freq{i}<4);
    
    %%Get the frequency band in the time window of interest
    HPC_thetaBandREM_ctrl{i} = SpectroH_REM_Ctrl{i}(idxfreq_theta{i},:);
    HPC_deltaBandREM_ctrl{i} = SpectroH_REM_Ctrl{i}(idxfreq_delta{i},:);
    PFC_deltaBandREM_ctrl{i} = SpectroP_REM_Ctrl{i}(idxfreq_delta{i},:);    

    %%Spectro in the theta frequency band and defined timewindow
    Sp_HPC_thetaBandREM_Before_ctrl{i} = SpectroH_REM_Ctrl{i}(idxfreq_theta{i},beforeidx{i}');
    Sp_HPC_thetaBandREM_During_ctrl{i} = SpectroH_REM_Ctrl{i}(idxfreq_theta{i},duringidx{i}');

    Sp_HPC_deltaBandREM_Before_ctrl{i} = SpectroH_REM_Ctrl{i}(idxfreq_delta{i},beforeidx{i}');
    Sp_HPC_deltaBandREM_During_ctrl{i} = SpectroH_REM_Ctrl{i}(idxfreq_delta{i},duringidx{i}');
    
    Sp_PFC_deltaBandREM_Before_ctrl{i} = SpectroP_REM_Ctrl{i}(idxfreq_delta{i},beforeidx{i}');
    Sp_PFC_deltaBandREM_During_ctrl{i} = SpectroP_REM_Ctrl{i}(idxfreq_delta{i},duringidx{i}');

    ratio_thea_delta_REM_HPC_before_ctrl{i} =  Sp_HPC_thetaBandREM_Before_ctrl{i} / Sp_HPC_deltaBandREM_Before_ctrl{i};
    ratio_thea_delta_REM_HPC_during_ctrl{i} =Sp_HPC_thetaBandREM_During_ctrl{i} / Sp_HPC_deltaBandREM_During_ctrl{i};
    
    %%Compute average power in theta band across mice
    for ii=1:length(Sp_PFC_deltaBandREM_Before_ctrl)
        av_Sp_PFC_deltaBandREM_Before_ctrl(ii,:)=nanmean(Sp_PFC_deltaBandREM_Before_ctrl{ii});
        av_Sp_PFC_deltaBandREM_During_ctrl(ii,:)=nanmean(Sp_PFC_deltaBandREM_During_ctrl{ii});
        
        av_Sp_HPC_thetaBandREM_Before_ctrl(ii,:)=nanmean(Sp_HPC_thetaBandREM_Before_ctrl{ii});
        av_Sp_HPC_thetaBandREM_During_ctrl(ii,:)=nanmean(Sp_HPC_thetaBandREM_During_ctrl{ii});
        
        av_Sp_HPC_deltaBandREM_Before_ctrl(ii,:)=nanmean(Sp_HPC_deltaBandREM_Before_ctrl{ii});
        av_Sp_HPC_deltaBandREM_During_ctrl(ii,:)=nanmean(Sp_HPC_deltaBandREM_During_ctrl{ii});
        
        av_ratio_thea_delta_REM_HPC_before_ctrl(ii,:)=nanmean(ratio_thea_delta_REM_HPC_before_ctrl{ii});
        av_ratio_thea_delta_REM_HPC_during_ctrl(ii,:)=nanmean(ratio_thea_delta_REM_HPC_during_ctrl{ii});
    end
end


%% GET RIPPLES - ctrl
for i=1:length(DirCtrl_ripp.path)
    cd(DirCtrl_ripp.path{i}{1});
    if exist('SleepScoring_OBGamma.mat') % load sleep scoring
        stage_ctrl_ripp{i} = load('SleepScoring_OBGamma.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','LowThetaEpochMC');
    else
        stage_ctrl_ripp{i} = load('SleepScoring_Accelero.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','LowThetaEpochMC');
    end
    [MatRemRip,MatRemRipStart,MatRemRipEnd] = GetRipplesDensityOpto_MC(stage_ctrl_ripp{i}.WakeWiNoise,stage_ctrl_ripp{i}.SWSEpochWiNoise,stage_ctrl_ripp{i}.REMEpochWiNoise,'rem',1);
    dataRippCtrl{i}=MatRemRip;
end
    

%% GET DATA - opto
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    stage_opto{j} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','LowThetaEpochMC'); %load sleep scoring
    durtotal_opto{j} = max([max(End(stage_opto{j}.WakeWiNoise)),max(End(stage_opto{j}.SWSEpochWiNoise))]);
    SleepStages_opto{j} = PlotSleepStage(stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,0);

    %%get time of opto stim
    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise);
    
    stim_rem_opto{j} = FindOptoStimWithLongBout_MC(stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,'rem', MinDurBeforeStimOnset);
    stim_wake_opto{j} = FindOptoStimWithLongBout_MC(stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,'wake', MinDurBeforeStimOnset);
    stim_sws_opto{j} = FindOptoStimWithLongBout_MC(stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,'sws', MinDurBeforeStimOnset);        
    
    %%Get time of opto stim in REM (with minimal duration of REM before
    %%stim onset)
    StimWithLongBout_opto{j} = FindOptoStimWithLongBout_MC(stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,state, MinDurBeforeStimOnset);
    [h{j},rg{j},vec{j}] = HistoSleepStagesTransitionsMathilde_MC(SleepStages_opto{j}, ts(StimWithLongBout_opto{j}), TimeWindowAroundStim, 0); 

    %%stages percentage around stim
    perc_aroundStim_opto{j} = h{j};    
    perc_eveil_opto(:,j) = perc_aroundStim_opto{j}(:,1);
    perc_REM_opto(:,j) = perc_aroundStim_opto{j}(:,2);
    perc_SWS_opto(:,j) = perc_aroundStim_opto{j}(:,3);
    
    durREMopto(j)=mean(End(stage_opto{j}.REMEpochWiNoise)-Start(stage_opto{j}.REMEpochWiNoise))/1E4;
    numREMopto(j)=length(End(stage_opto{j}.REMEpochWiNoise)-Start(stage_opto{j}.REMEpochWiNoise));

    %%PROBILITE
    same_epoch_opto{j} = intervalSet(0,durtotal_opto{j});
    [P_S_S, P_S_R, P_S_W, P_R_R, P_R_S, P_R_W, P_W_W, P_W_S, P_W_R] = Get_transition_probabilities_MC_VF...
        (stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,stage_opto{j}.WakeWiNoise, same_epoch_opto{j});
    prob_trans_WAKE_to_REM_opto(j)=P_W_R;
    prob_trans_REM_to_WAKE_opto(j)=P_R_W;
    prob_trans_SWSEpoch_to_WAKE_opto(j)=P_S_W;
    prob_trans_WAKE_to_SWSEpoch_opto(j)=P_W_S;
    prob_trans_SWSEpoch_to_REM_opto(j)=P_S_R;
    prob_trans_REM_to_SWSEpoch_opto(j)=P_R_S;
    prob_trans_REM_to_REM_opto(j)=P_R_R;
    prob_trans_SWS_to_SWS_opto(j)=P_S_S;
    prob_trans_WAKE_to_WAKE_opto(j)=P_W_W;
    
    
    %%SPECTROGRAM
    %%Get spectro triggered on stimulations in REM
    Spectro_H_opto{j} = load('H_Low_Spectrum.mat','Spectro');
    [SpHREM,SpHSWS,SpHWake,time]=PlotSpectroAroundStim_SingleMouse_MC(Spectro_H_opto{j}.Spectro, stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,stage_opto{j}.LowThetaEpochMC,stim_rem_opto{j});
    SpectroH_REM_opto{j}=SpHREM;

    Spectro_P_opto{j} = load('PFCx_deep_Low_Spectrum.mat','Spectro');
    [SpPREM,SpPSWS,SpPWake,time]=PlotSpectroAroundStim_SingleMouse_MC(Spectro_P_opto{j}.Spectro, stage_opto{j}.WakeWiNoise,stage_opto{j}.SWSEpochWiNoise,stage_opto{j}.REMEpochWiNoise,stage_opto{j}.LowThetaEpochMC,stim_rem_opto{j});
    SpectroP_REM_opto{j}=SpPREM;

    %%Restrict time to the time window (defined above)
    tps_opto{j} = time/1e3;
    beforeidx{j}=find(tps_opto{j}>-timeWindow&tps_opto{j}<0); 
    duringidx{j}=find(tps_opto{j}>0&tps_opto{j}<timeWindow);

    freq{j}=[1:size(SpectroH_REM_opto{j},1)]/size(SpectroH_REM_opto{j},1)*20;
    
    %%Select the frequency band of interest
    idxfreq_theta{j}=find(freq{j}>5&freq{j}<9); 
    idxfreq_delta{j}=find(freq{j}>1&freq{j}<4);

    %%Get the frequency band in the time window of interest
    HPC_thetaBandREM_opto{j} = SpectroH_REM_opto{j}(idxfreq_theta{j},:);
    HPC_deltaBandREM_opto{j} = SpectroH_REM_opto{j}(idxfreq_delta{j},:);
    PFC_deltaBandREM_opto{j} = SpectroP_REM_opto{j}(idxfreq_delta{j},:);    
    
    %%Spectro in the theta frequency band and defined timewindow
    Sp_HPC_thetaBandREM_Before_opto{j} = SpectroH_REM_opto{j}(idxfreq_theta{j},beforeidx{j}');
    Sp_HPC_thetaBandREM_During_opto{j} = SpectroH_REM_opto{j}(idxfreq_theta{j},duringidx{j}');

    Sp_HPC_deltaBandREM_Before_opto{j} = SpectroH_REM_opto{j}(idxfreq_delta{j},beforeidx{j}');
    Sp_HPC_deltaBandREM_During_opto{j} = SpectroH_REM_opto{j}(idxfreq_delta{j},duringidx{j}');
    
    Sp_PFC_deltaBandREM_Before_opto{j} = SpectroP_REM_opto{j}(idxfreq_delta{j},beforeidx{j}');
    Sp_PFC_deltaBandREM_During_opto{j} = SpectroP_REM_opto{j}(idxfreq_delta{j},duringidx{j}');

    ratio_thea_delta_REM_HPC_before_opto{j} =  Sp_HPC_thetaBandREM_Before_opto{j} / Sp_HPC_deltaBandREM_Before_opto{j};
    ratio_thea_delta_REM_HPC_during_opto{j} =Sp_HPC_thetaBandREM_During_opto{j} / Sp_HPC_deltaBandREM_During_opto{j};
    
    %%Compute average power in theta band across mice
    for jj=1:length(Sp_PFC_deltaBandREM_Before_opto)
        av_Sp_PFC_deltaBandREM_Before_opto(jj,:)=nanmean(Sp_PFC_deltaBandREM_Before_opto{jj});
        av_Sp_PFC_deltaBandREM_During_opto(jj,:)=nanmean(Sp_PFC_deltaBandREM_During_opto{jj});
        
        av_Sp_HPC_thetaBandREM_Before_opto(jj,:)=nanmean(Sp_HPC_thetaBandREM_Before_opto{jj});
        av_Sp_HPC_thetaBandREM_During_opto(jj,:)=nanmean(Sp_HPC_thetaBandREM_During_opto{jj});
 
        av_Sp_HPC_deltaBandREM_Before_opto(jj,:)=nanmean(Sp_HPC_deltaBandREM_Before_opto{jj});
        av_Sp_HPC_deltaBandREM_During_opto(jj,:)=nanmean(Sp_HPC_deltaBandREM_During_opto{jj});

        av_ratio_thea_delta_REM_HPC_before_opto(jj,:)=nanmean(ratio_thea_delta_REM_HPC_before_opto{jj});
        av_ratio_thea_delta_REM_HPC_during_opto(jj,:)=nanmean(ratio_thea_delta_REM_HPC_during_opto{jj});
    end
end

%% GET RIPPLES - opto
for j=1:length(DirOpto_ripp.path)
    cd(DirOpto_ripp.path{j}{1});
    stage_opto_ripp{j} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','LowThetaEpochMC'); %load sleep scoring

    [MatRemRip,MatRemRipStart,MatRemRipEnd] = GetRipplesDensityOpto_MC(stage_opto_ripp{j}.WakeWiNoise,stage_opto_ripp{j}.SWSEpochWiNoise,stage_opto_ripp{j}.REMEpochWiNoise,'rem',1);
    dataRippOpto{j}=MatRemRip;
end

    
%%
%%calculate SEM
SEMperc_REM = nanstd(perc_REM_ctrl')/sqrt(size(perc_REM_ctrl,2));
SEMperc_SWS = nanstd(perc_SWS_ctrl')/sqrt(size(perc_SWS_ctrl,2));
SEMperc_eveil = nanstd(perc_eveil_ctrl')/sqrt(size(perc_eveil_ctrl,2));

SEMperc_REM_opto = nanstd(perc_REM_opto')/sqrt(size(perc_REM_opto,2)); 
SEMperc_SWS_opto = nanstd(perc_SWS_opto')/sqrt(size(perc_SWS_opto,2)); 
SEMperc_eveil_opto = nanstd(perc_eveil_opto')/sqrt(size(perc_eveil_opto,2));

prob_out_rem_ctrl = prob_trans_REM_to_SWSEpoch_ctrl + prob_trans_REM_to_WAKE_ctrl;
prob_out_rem_opto = prob_trans_REM_to_SWSEpoch_opto + prob_trans_REM_to_WAKE_opto;


%%RIPPLES
data_ripp=cat(3,dataRippCtrl{:});
data_rippOpto=cat(3,dataRippOpto{:});
%mean
data_rippCtrl_mean = mean(data_ripp(:,2,:),2);
data_rippOpto_mean = mean(data_rippOpto(:,2,:),2);
%SEM
data_rippCtrl_SEM = std(squeeze(data_rippCtrl_mean)',1);
data_rippOpto_SEM = std(squeeze(data_rippOpto_mean)',1);
% to normalize
normOpto=mean(mean(data_rippOpto(20:40,2,:)));
norm=mean(mean(data_ripp(20:40,2,:)));

%% FIGURE
%%param figure
idxonset = find(TimeWindowAroundStim==0);
idxduring = find(TimeWindowAroundStim==30);
idxbefore = find(TimeWindowAroundStim==-30);

col_ctrl = [.4 .4 .4];
col_opto = [.4 .6 1];

col_ctrl_off = [1 1 1];
col_ctrl_on = [.4 .4 .4];

col_opto_off = [1 1 1];
col_opto_on = [.4 .6 1];


f=figure;
% REM HPC opto
subplot(3,8,[4:6],'align')
imagesc(time/1e3, freq{2}, SpectroH_REM_opto{2}), axis xy, xlim([-30 30]), caxis([1 5])
hold on, line([0 0], ylim, 'color','w')
colormap(jet), colorbar
ylabel('Frequency (Hz)')
set(gca,'fontsize',17,'fontname','Lato Semibold')


% REM HPC ctrl
subplot(3,8,[1:3],'align')
imagesc(time/1e3, freq{2}, SpectroH_REM_Ctrl{5}), axis xy, xlim([-30 30]), caxis([1 5])
hold on, line([0 0], ylim, 'color','w')
colormap(jet), colorbar
ylabel('Frequency (Hz)')
set(gca,'fontsize',17,'fontname','Lato Semibold')



%HPC REM
subplot(3,8,[7,8],'align')
PlotErrorBarN_MC({nanmean(av_Sp_HPC_thetaBandREM_Before_ctrl,2), nanmean(av_Sp_HPC_thetaBandREM_During_ctrl,2),...
    nanmean(av_Sp_HPC_thetaBandREM_Before_opto,2), nanmean(av_Sp_HPC_thetaBandREM_During_opto,2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_ctrl_off,col_ctrl_on,col_opto_off,col_opto_on});
xticks([1.5 4.5]); xticklabels({'mCherry','ChR2'}); xtickangle(0)
ylabel('Theta/delta power (a.u.)')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')

%%test stats
[h,p_opto]=ttest(nanmean(av_Sp_HPC_thetaBandREM_Before_opto,2), nanmean(av_Sp_HPC_thetaBandREM_During_opto,2));
if p_opto<0.05
    sigstar_DB({[4 5]},p_opto,0,'LineWigth',16,'StarSize',24);
end
[h,p_ctrl]=ttest(nanmean(av_Sp_HPC_thetaBandREM_Before_ctrl,2), nanmean(av_Sp_HPC_thetaBandREM_During_ctrl,2));
if p_ctrl<0.05
    sigstar_DB({[1 2]},p_ctrl,0,'LineWigth',16,'StarSize',24);
end


subplot(3,8,15,'align')
h=shadedErrorBar(TimeWindowAroundStim,nanmean(perc_REM_opto,2),SEMperc_REM_opto,'r',1); hold on,
h.mainLine.Color=col_opto; h.patch.FaceColor=col_opto;  h.edge(1).Color='none'; h.edge(2).Color='none';
h2=shadedErrorBar(TimeWindowAroundStim,nanmean(perc_REM_ctrl,2),SEMperc_REM,'k',1);
h2.mainLine.Color=col_ctrl; h2.patch.FaceColor=col_ctrl;  h2.edge(1).Color='none'; h2.edge(2).Color='none';
line([0 0],[0 100],'color','k','linestyle',':')
line([30 30],[0 100],'color','k','linestyle',':')
ylim([0 100]); ylabel('REM percentage')
xlim([-20 60]); xlabel('Time (s)')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')


subplot(3,8,16,'align')
PlotErrorBarN_MC({nanmean(perc_REM_ctrl(idxonset:idxduring,:)) nanmean(perc_REM_opto(idxonset:idxduring,:))},'newfig',0,'paired',0,'ShowSigstar','none','barcolors',{col_ctrl,col_opto});
ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
ylabel('REM percentage')
makepretty
[h,p]=ttest2(nanmean(perc_REM_ctrl(idxonset:idxduring,:)), nanmean(perc_REM_opto(idxonset:idxduring,:)));
if p<0.05
    sigstar_MC({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
set(gca,'fontsize',17,'fontname','Lato Semibold')


subplot(3,8,12,'align')
h=shadedErrorBar(TimeWindowAroundStim,nanmean(perc_SWS_opto,2),SEMperc_SWS_opto,'b',1); hold on,
h.mainLine.Color=col_opto; h.patch.FaceColor=col_opto;  h.edge(1).Color='none'; h.edge(2).Color='none';
h2=shadedErrorBar(TimeWindowAroundStim,nanmean(perc_SWS_ctrl,2),SEMperc_SWS,'k',1);
h2.mainLine.Color=col_ctrl; h2.patch.FaceColor=col_ctrl;  h2.edge(1).Color='none'; h2.edge(2).Color='none';
line([0 0],[0 100],'color','k','linestyle',':')
line([30 30],[0 100],'color','k','linestyle',':')
ylim([0 100]); ylabel('NREM percentage')
xlim([-20 60]); xlabel('Time (s)')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')


subplot(3,8,13,'align')
PlotErrorBarN_MC({nanmean(perc_SWS_ctrl(idxonset:idxduring,:)) nanmean(perc_SWS_opto(idxonset:idxduring,:))},'newfig',0,'paired',0,'ShowSigstar','none','barcolors',{col_ctrl,col_opto});
ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
 ylabel('NREM percentage')
 makepretty
[h,p]=ttest2(nanmean(perc_SWS_ctrl(idxonset:idxduring,:)), nanmean(perc_SWS_opto(idxonset:idxduring,:)));
if p<0.05
    sigstar_MC({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
set(gca,'fontsize',17,'fontname','Lato Semibold')


subplot(3,8,[9],'align')
h=shadedErrorBar(TimeWindowAroundStim,nanmean(perc_eveil_opto,2),SEMperc_eveil_opto,'b',1); hold on,
h.mainLine.Color=col_opto; h.patch.FaceColor=col_opto;  h.edge(1).Color='none'; h.edge(2).Color='none';
h2=shadedErrorBar(TimeWindowAroundStim,nanmean(perc_eveil_ctrl,2),SEMperc_eveil,'k',1);
h2.mainLine.Color=col_ctrl; h2.patch.FaceColor=col_ctrl;  h2.edge(1).Color='none'; h2.edge(2).Color='none';
line([0 0],[0 100],'color','k','linestyle',':')
line([30 30],[0 100],'color','k','linestyle',':')
ylim([0 30]); ylabel('Wake percentage')
xlim([-20 60]); xlabel('Time (s)')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')


subplot(3,8,10,'align')
PlotErrorBarN_MC({nanmean(perc_eveil_ctrl(idxonset:idxduring,:)) nanmean(perc_eveil_opto(idxonset:idxduring,:))},'newfig',0,'paired',0,'ShowSigstar','none','barcolors',{col_ctrl,col_opto});
ylim([0 30])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
ylabel('Wake percentage')
makepretty
[h,p]=ttest2(nanmean(perc_eveil_ctrl(idxonset:idxduring,:)), nanmean(perc_eveil_opto(idxonset:idxduring,:)));
if p<0.05
    sigstar_MC({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
set(gca,'fontsize',17,'fontname','Lato Semibold')



subplot(3,8,[17:18],'align'), hold on
h=shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippOpto_mean,3),3)/normOpto,data_rippOpto_SEM','r',1); 
h.mainLine.Color=col_opto; h.patch.FaceColor=col_opto;  h.edge(1).Color='none'; h.edge(2).Color='none';
h2=shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippCtrl_mean,3),3)/norm,data_rippCtrl_SEM','k',1); 
h2.mainLine.Color=col_ctrl; h2.patch.FaceColor=col_ctrl;  h2.edge(1).Color='none'; h2.edge(2).Color='none';
line([0 0],ylim,'color','k','linestyle',':')
line([30 30],ylim,'color','k','linestyle',':')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')
xlim([-20 +60])
ylim([0 2])
xlabel('Time (s)')
ylabel('Density (ripples/s)')


subplot(3,8,19,'align'),
PlotErrorBarN_MC({mean(data_rippCtrl_mean(idxduring,:),1)/norm, mean(data_rippOpto_mean(idxduring,:),1)/normOpto},'newfig',0,'paired',0,'ShowSigstar','none','barcolors',{col_ctrl,col_opto});
xticks([1 2])
xticklabels({'mCherry','ChR2'}), xtickangle(45)
ylabel('Density (ripples/s)')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')

[h,p]=ttest2(mean(data_rippCtrl_mean(idxduring,:),1)/norm, mean(data_rippOpto_mean(idxduring,:),1)/normOpto);
if p<0.05; sigstar_MC({[1 2]},p,0,'LineWigth',16,'StarSize',24);end




subplot(3,8,23,'align'),
PlotErrorBarN_MC({durREMctrl, durREMopto},...
     'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_ctrl,col_opto});
xticks([1 2]); xticklabels({'mCherry','ChR2'}), xtickangle(45)
ylabel('REM mean duration (s)')
makepretty
[h,p]=ttest2(durREMctrl, durREMopto);
% p=ranksum(durREMctrl, durREMopto);
if p<0.05
    sigstar_MC({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
set(gca,'fontsize',17,'fontname','Lato Semibold')



subplot(3,8,24,'align'),
PlotErrorBarN_MC({numREMctrl, numREMopto},...
     'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_ctrl,col_opto});
xticks([1 2]); xticklabels({'mCherry','ChR2'}), xtickangle(45)
ylabel('REM mean duration (s)')
makepretty
[h,p]=ttest2(numREMctrl, numREMopto);
% p=ranksum(durREMctrl, durREMopto);
if p<0.05
    sigstar_MC({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
set(gca,'fontsize',17,'fontname','Lato Semibold')





subplot(3,8,21,'align'),
PlotErrorBarN_MC({prob_trans_REM_to_SWSEpoch_ctrl prob_trans_REM_to_SWSEpoch_opto},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_ctrl, col_opto});
xticks([1 2]); xticklabels({'mCherry','ChR2'}), xtickangle(45)
ylabel('Probability REM to NREM')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')
[h,p_ctrl_opto]=ttest2(prob_trans_REM_to_SWSEpoch_ctrl, prob_trans_REM_to_SWSEpoch_opto);
if p_ctrl_opto<0.05; sigstar_MC({[1 2]},p_ctrl_opto,0,'LineWigth',16,'StarSize',24);end



subplot(3,8,22,'align'),
PlotErrorBarN_MC({prob_trans_REM_to_WAKE_ctrl prob_trans_REM_to_WAKE_opto},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_ctrl, col_opto});
xticks([1 2]); xticklabels({'mCherry','ChR2'}), xtickangle(45)
ylabel('Probability REM to NREM')
makepretty
set(gca,'fontsize',17,'fontname','Lato Semibold')
[h,p_ctrl_opto]=ttest2(prob_trans_REM_to_WAKE_ctrl, prob_trans_REM_to_WAKE_opto);
if p_ctrl_opto<0.05; sigstar_MC({[1 2]},p_ctrl_opto,0,'LineWigth',16,'StarSize',24);end

