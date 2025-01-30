% DataDreemObserver
% 21.12.2016 KJ
%
% Observe the data with SignalObserverGUI
% - data from the viewer Rythm
% 
%   see SignalObserverGUI DataClinicObserver
%
%

clear


%% load
Dir = ListOfDreemRecordsStimImpact('internal');
p=1;
[eeg, accelero, stimulations, StageEpochs, labels_eeg, pulse_oximeter] = GetRecordDreem(Dir.filename{p});

%quality
% [~, NoiseEpoch] = GetDreemQuality(Dir.filereference{p});

%stimulation
[stim_tmp, sham_tmp, int_stim, stim_train, sham_train, ~, ~] = SortDreemStimSham(stimulations);


%slow waves
eeg_occipital = eeg([1 2 5 6]);
sw_file = fullfile(FolderStimImpactPreprocess, 'SlowWaves2', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
load(sw_file);
SlowWaveEpochs = SlowWaveEpochs([1 2 5 6]);

for i=1:length(SlowWaveEpochs)
    start_sw{i} = Start(SlowWaveEpochs{i})';
    sw_duration{i} = End(SlowWaveEpochs{i})' - Start(SlowWaveEpochs{i})';
end

%% signals
signals{1} = [Range(eeg{1})'/1E4 ; Data(eeg{1})'];
signals{2} = [Range(eeg{2})'/1E4  ; Data(eeg{2})'];
signals{3} = [Range(eeg{5})'/1E4  ; Data(eeg{5})'];
signals{4} = [Range(eeg{6})'/1E4  ; Data(eeg{6})'];


%% plot observer
labels = labels_eeg([1 2 5 6]);

sog = SignalObserverGUI(signals,'DisplayWindow',[5 5]);
for ch=1:sog.nb_channel
    sog.add_verticals(stim_tmp, ch)
    sog.set_title(labels{ch}, ch);
    %epoch
    sog.add_rectangles(start_sw{ch} /1e4, sw_duration{ch}/1e4, ch);
end
sog.set_time_events([stim_tmp/1e4 ; start_sw{1}'/1e4]);

sog.set_ymin(1, -200); sog.set_ymax(1, 200);
sog.set_ymin(2, -200); sog.set_ymax(2, 200);
sog.set_ymin(3, -200); sog.set_ymax(3, 200);
sog.set_ymin(4, -200); sog.set_ymax(4, 200);

sog.run_window




