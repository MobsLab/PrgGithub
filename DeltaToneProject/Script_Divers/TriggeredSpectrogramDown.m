%TriggeredSpectrogramDown
% 09.01.2018 KJ
%
% triggered spectrogram on down states
%
% see AverageSpectrogram
%


clear

%% load
load ChannelsToAnalyse/PFCx_deep.mat
load(['LFPData/LFP' num2str(channel)], 'LFP')

load('DownState','down_PFCx')
start_down = Start(down_PFCx);


%% params
durations = [-5 5];
params.fpass = [1 300];
params.tapers = [3 4];
smoothing = 0;
movingwin=[0.02 0.002];


%% specgram
events = start_down(1000:5000)/1e4;
[mean_specgram, times, frequencies] = SyncSpecgram_KJ(LFP, events, 'durations',durations, 'params',params, 'movingwin',movingwin);

imagesc(times/1E3, frequencies, SmoothDec(mean_specgram,[smoothing smoothing])),hold on,
axis xy









