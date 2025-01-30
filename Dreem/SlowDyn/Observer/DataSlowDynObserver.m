% DataSlowDynObserver
% 02.10.2018 KJ
%
% Observe the data with SignalObserverGUI
% - data from the SlowDyn database
% 
%   see SignalObserverGUI DataClinicObserver
%
%


clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))


%% load
p=451;
[eeg, accelero, stimulations, StageEpochs, labels_eeg, pulse_oximeter] = GetRecordDreem(Dir.filename{p});

%quality
[~, NoiseEpoch] = GetDreemQuality(Dir.filereference{p});
NoiseEpoch{5} = NoiseEpoch{1};
NoiseEpoch{6} = NoiseEpoch{2};
eeg = eeg(1:6);

%stimulation
[stim_tmp, sham_tmp, int_stim, stim_train, sham_train, ~, ~] = SortDreemStimSham(stimulations);


%slow waves
eeg_occipital = eeg([1 2 5 6]);
sw_file = fullfile(FolderSlowDynPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
load(sw_file);
SlowWaveEpochs = SlowWaveEpochs([1 2 5 6]);

for i=1:length(SlowWaveEpochs)
    start_sw{i} = Start(SlowWaveEpochs{i})';
    sw_duration{i} = End(SlowWaveEpochs{i})' - Start(SlowWaveEpochs{i})';
end

%spindles
for i=1:length(eeg)
    params.noise_epoch = NoiseEpoch{i};
    SpindlesEpoch{i} = FindSpindlesDreem(eeg{i},'method','mensen','params',params);
    start_spi{i} = Start(SpindlesEpoch{i})';
    spi_duration{i} = End(SpindlesEpoch{i})' - Start(SpindlesEpoch{i})';
end


%% signals
signals{1} = [Range(eeg{1})'/1E4 ; Data(eeg{1})'];
signals{2} = [Range(eeg{2})'/1E4  ; Data(eeg{2})'];
signals{3} = [Range(eeg{3})'/1E4  ; Data(eeg{3})'];
signals{4} = [Range(eeg{4})'/1E4  ; Data(eeg{4})'];
signals{5} = [Range(eeg{5})'/1E4  ; Data(eeg{5})'];
signals{6} = [Range(eeg{6})'/1E4  ; Data(eeg{6})'];

%% plot observer
labels = labels_eeg(1:6);

sog = SignalObserverGUI(signals,'DisplayWindow',[5 5]);
for ch=1:sog.nb_channel
    sog.add_verticals(stim_tmp, ch)
    sog.set_title(labels{ch}, ch);
    
    sog.set_ymin(ch, -200); sog.set_ymax(ch, 200);

    %epoch
%     sog.add_rectangles(start_sw{ch} /1e4, sw_duration{ch}/1e4, ch);
    sog.add_rectangles(start_spi{ch} /1e4, spi_duration{ch}/1e4, ch);

end
sog.set_time_events(start_spi{1}'/1e4);

sog.run_window




