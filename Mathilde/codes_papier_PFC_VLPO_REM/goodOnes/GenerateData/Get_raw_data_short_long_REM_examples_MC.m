%% load session from a good mouse example
cd /media/nas7/ProjetPFCVLPO/M1450/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1450_sleepPostSD_230525_100459/

SetCurrentSession

load('SleepScoring_Accelero.mat', 'REMEpoch', 'SWSEpoch','Wake','Info','Sleep')

SpectroH = load('H_Low_Spectrum.mat');
freqH = SpectroH.Spectro{3};
sptsdH = tsd(SpectroH.Spectro{2}*1e4, SpectroH.Spectro{1});

SpectroP = load('PFCx_deep_Low_Spectrum.mat');
freqP = SpectroP.Spectro{3};
sptsdP = tsd(SpectroP.Spectro{2}*1e4, SpectroP.Spectro{1});


%% Get channels
res = pwd;
nam = 'EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
num_ch_emg = tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(num_ch_emg),'.mat'');'])
LFP_emg = LFP;
% SqurdEMG = ResampleTSD(tsd(Range(LFP_emg), Data(LFP_emg).^2),10);

% SqurdEMG = tsd(Range(LFP_emg), Data(LFP_emg).^2);
% % SqurdEMG = FilterLFP(SqurdEMG,[50 300]);

SqurdEMG = FilterLFP(LFP_emg,[50 300]);
SqurdEMG = tsd(Range(SqurdEMG), Data(SqurdEMG).^2);



nam = 'ThetaREM';
eval(['tempchThetaREM=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
num_ch_theta = tempchThetaREM.channel;

res = pwd;
nam = 'PFCx_sup';
eval(['tempchPFCx_deep=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
num_ch_pfc_sup = tempchPFCx_deep.channel;

res = pwd;
nam = 'PFCx_deep';
eval(['tempchPFCx_deep=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
num_ch_pfc_deep = tempchPFCx_deep.channel;



%% Get short / long REM bouts
lim_dur = 10;

[dur_REM, durT_REM]=DurationEpoch(REMEpoch,'s');

idx_short_rem = find(dur_REM<lim_dur);
short_REMEpoch = subset(REMEpoch, idx_short_rem);

idx_long_rem = find(dur_REM>lim_dur);
long_REMEpoch = subset(REMEpoch, idx_long_rem);

st = Start(REMEpoch)/1e4;
en = Stop(REMEpoch)/1e4;


%%compute sem of mean HPC spectrum
sp_HPC_short_REM_SEM_norm = nanstd(log10(Data(Restrict(sptsdH,short_REMEpoch))))/sqrt(size(log10(Data(Restrict(sptsdH,short_REMEpoch))),1));
sp_HPC_long_REM_SEM_norm = nanstd(log10(Data(Restrict(sptsdH,long_REMEpoch))))/sqrt(size(log10(Data(Restrict(sptsdH,long_REMEpoch))),1));

%%find peaks of mean HPC spectrum
sp_thresh=log10(8000);
xmax_short=findpeaks(nanmean(log10(Data(Restrict(sptsdH,short_REMEpoch)))),sp_thresh);
xmax_long=findpeaks(nanmean(log10(Data(Restrict(sptsdH,long_REMEpoch)))),sp_thresh);


%% compute variables for best short / long examples
winsize=120;

%%get data short a short rem
i_short=1;

[data_theta_short,indices_theta_short] = GetWideBandData(num_ch_theta, 'intervals',[(st(idx_short_rem(i_short)))-winsize (en(idx_short_rem(i_short)))+winsize]);
[data_hpc_sws_short,indices_hpc_sws_short] = GetWideBandData(num_ch_theta, 'intervals',[323*60 323.6*60]);

[data_emg_short,indices_emg_short] = GetWideBandData(num_ch_emg, 'intervals',[(st(idx_short_rem(i_short)))-winsize (en(idx_short_rem(i_short)))+winsize]);
emg_tsd_short = tsd(data_emg_short(:,1), data_emg_short(:,2));
filter_emg_short = FilterLFP(emg_tsd_short,[50 300]);

[data_emg_short_bis,indices_emg_short_bis] = GetWideBandData(num_ch_emg, 'intervals',[(st(idx_short_rem(i_short)))-winsize (en(idx_short_rem(i_short)))+winsize]);
emg_tsd_short_bis = tsd(data_emg_short_bis(:,1), data_emg_short_bis(:,2).^2);
filter_emg_short_bis = FilterLFP(emg_tsd_short_bis,[50 300]);



%%get data for a long rem
i_long=21;
[data_theta_long,indices_theta_long] = GetWideBandData(num_ch_theta, 'intervals',[(st(idx_long_rem(i_long)))-winsize (en(idx_long_rem(i_long)))+winsize]);
[data_hpc_sws_long,indices_hpc_sws_long] = GetWideBandData(num_ch_theta, 'intervals',[456*60 456.6*60]);

[data_emg_long,indices_emg_long] = GetWideBandData(num_ch_emg, 'intervals',[(st(idx_long_rem(i_long)))-winsize (en(idx_long_rem(i_long)))+winsize]);
emg_tsd_long = tsd(data_emg_long(:,1), data_emg_long(:,2));
filter_emg_long = FilterLFP(emg_tsd_long,[50 300]);

[data_emg_long_bis,indices_emg_long_bis] = GetWideBandData(num_ch_emg, 'intervals',[(st(idx_long_rem(i_long)))-winsize (en(idx_long_rem(i_long)))+winsize]);
emg_tsd_long_bis = tsd(data_emg_long_bis(:,1), data_emg_long_bis(:,2).^2);
filter_emg_long_bis = FilterLFP(emg_tsd_long_bis,[50 300]);


