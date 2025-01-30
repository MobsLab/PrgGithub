% DataClinicObserver
% 06.01.2017 KJ
%
% Observe the data with SignalObserverGUI
% - data from the clinical trials
% 
%   see SignalObserverGUI DataDreemObserver
%
%

% - StageEpochs             struct intervalSet - intervalSet for each Sleep Stage
%                           1: N1, 2: N2, 3: N3, 4: REM, 5: Wake
% - name_channel            'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'
% - domain                  'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'
%


clear
Dir = ListOfClinicalTrialDreemAnalyse('all');
filereference = 26655;
p = find(cell2mat(Dir.filereference)==filereference);
filename = Dir.filename{p};

common_data=GetClinicCommonData();


%% load
[signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(filename);

% VIRTUAL CHANNEL SIGNAL
[index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
[signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
rg = Range(signals_dreem_vc);
All_night = intervalSet(rg(1),rg(end));
goodEpochs = All_night - badEpochsDreem;

%Hypnogram
N1=StageEpochs{1}; N2=StageEpochs{2}; N3=StageEpochs{3}; REM=StageEpochs{4}; WAKE=StageEpochs{5};
Rec = or(or(or(N1,or(N2,N3)),REM),WAKE);
num_substage = [2 1.5 1 3 4]; %ordinate in graph
indtime = min(Start(Rec)):1E4:max(Stop(Rec));
timeTsd = tsd(indtime,zeros(length(indtime),1));

SleepStages = zeros(1,length(indtime)) + 4.5; %4.5 is the default value for non-scored epochs

for ep=1:5
    idx = find(ismember(indtime, Range(Restrict(timeTsd,StageEpochs{ep})))==1);
    SleepStages(idx) = num_substage(ep);
end
SleepStages = tsd(indtime,SleepStages');


%% Detect Slow waves
params_so = {};

SlowWaveEpochs = DetectSlowWavesHybrid(signals_dreem_vc, StageEpochs{3});
sampleEpoch = subset(SlowWaveEpochs, 500:1000);
[~, sample_times] = extremumEpochs(signals_dreem_vc, sampleEpoch, 0); %minima of slow waves
slowwave_pointsTM = DetectSlowWavesTM(signals_dreem_vc, sample_times);

%EMG
emg_channel = find(strcmpi(name_channel,'REF EMG'));
signal_emg = signals{emg_channel};



%% signals
clear visu
visu{1} = [Range(signals{1})'/1E4 ; Data(signals{1})'];
visu{2} = [Range(signals{2})'/1E4  ; Data(signals{2})'];
visu{3} = [Range(signal_emg)'/1E4  ; Data(signal_emg)'];
visu{4} = [Range(SleepStages)'/1E4  ; Data(SleepStages)'];


stim_tmp = Range(stimulations)/1E4;
stim_volume = Data(stimulations);
stim_tmp = stim_tmp(stim_volume>0);

start_sw = Start(SlowWaveEpochs,'ms')' / 1000;
sw_duration = (End(SlowWaveEpochs,'ms') - Start(SlowWaveEpochs,'ms'))' / 1000;


%% plot observer
labels = {name_channel{1}, name_channel{2}, 'EMG','Hypnogram'};

sog = SignalObserverGUI(visu,'DisplayWindow',[10 10]);
for ch=1:sog.nb_channel
    sog.add_verticals(stim_tmp, ch)
    sog.set_title(labels{ch}, ch);
end

sog.set_ymin(1, -180); sog.set_ymax(1, 180);
sog.set_ymin(2, -180); sog.set_ymax(2, 180);
sog.set_ymin(3, -500); sog.set_ymax(3, 500);
sog.set_ymin(4, 0.5); sog.set_ymax(4, 4.8);

sog.set_time_events(stim_tmp);
sog.add_rectangles(start_sw, sw_duration, 1);
sog.add_rectangles(start_sw, sw_duration, 2);
sog.add_verticals(slowwave_pointsTM, 1);
sog.add_verticals(slowwave_pointsTM, 2);


sog.run_window
%hypno labels
set(gca,'Ytick', [1 1.5 2 3 4],'YTickLabel', {'N3','N2','N1','REM','WAKE'})








