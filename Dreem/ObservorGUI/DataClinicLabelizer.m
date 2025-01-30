% DataClinicLabelizer
%
% Label the slow waves with ClinicDeltaLabelizor
% - data from the clinical trials
% 
%   see SignalObserverGUI DataClinicObserver ClinicDeltaLabelizor
%
%

% - StageEpochs             struct intervalSet - intervalSet for each Sleep Stage
%                           1: N1, 2: N2, 3: N3, 4: REM, 5: Wake
% - name_channel            'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'
% - domain                  'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'
%


clear
%
filereference = 27912;

%
Dir = ListOfClinicalTrialDreemAnalyse('all');
p = find(cell2mat(Dir.filereference)==filereference);
filename = Dir.filename{p};


%% load
[signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(filename);
% VIRTUAL CHANNEL SIGNAL
[index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
[signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
rg = Range(signals_dreem_vc);
All_night = intervalSet(rg(1),rg(end));
goodEpochs = All_night - badEpochsDreem;
%Detect Slow waves
common_data=GetClinicCommonData();
params_so = common_data.predetect_so;

for i=1:2
    SlowWaveEpochs{i}=FindSlowWaves(signals{i}, 'method','predetect','params',params_so);
end

%EMG
emg_channel = find(strcmpi(name_channel,'REF EMG'));
signal_emg = signals{emg_channel};

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


%% signals
clear visu
visu{1} = [Range(signals{1})'/1E4 ; Data(signals{1})'];
visu{2} = [Range(signals{1})'/1E4  ; Data(signals{2})'];
visu{3} = [Range(signals_dreem_vc)'/1E4 ; Data(signals_dreem_vc)'];
visu{4} = [Range(signal_emg)'/1E4  ; Data(signal_emg)'];
visu{5} = [Range(SleepStages)'/1E4  ; Data(SleepStages)'];


for i=1:2
    start_sw{i} = Start(SlowWaveEpochs{i},'ts')' / 1E4;
    center_sw{i} = (Start(SlowWaveEpochs{i},'ts')' + End(SlowWaveEpochs{i},'ts')') / 2E4;
    sw_duration{i} = (End(SlowWaveEpochs{i},'ts') - Start(SlowWaveEpochs{i},'ts'))' / 1E4;
end


%% plot observer
labels = {name_channel{1}, name_channel{2}, 'Dreem VC','EMG','Hypnogram'};

sog = ClinicDeltaLabelizor(visu,'DisplayWindow',[10 10]);
for ch=1:sog.nb_channel
    sog.set_title(labels{ch}, ch);
end

sog.set_ymin(1, -180); sog.set_ymax(1, 180);
sog.set_ymin(2, -180); sog.set_ymax(2, 180);
sog.set_ymin(3, -180); sog.set_ymax(3, 180);
sog.set_ymin(4, -500); sog.set_ymax(4, 500);
sog.set_ymin(5, 0.5); sog.set_ymax(5, 4.8);


for i=1:2
    sog.add_rectangles(start_sw{i}, sw_duration{i}, ones(1,length(start_sw{i}))*i);
    sog.add_verticals(center_sw{i}, i)
end

sog.run_window
set(gca,'Ytick', [1 1.5 2 3 4],'YTickLabel', {'N3','N2','N1','REM','WAKE'})


%% save
labelname = [FolderClinicLabelized 'labelso_' num2str(filereference) ];
%sog.save_labels(labelname, Dir.subject{p});







