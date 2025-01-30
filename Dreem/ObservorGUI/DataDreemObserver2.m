% DataDreemObserver2
% 28.03.2018 KJ
%
% Observe the data with SignalObserverGUI
% - data from the viewer Rythm
% 
%   see SignalObserverGUI DataDreemObserver 
%
%

clear


%% load data
filereference = 83800;
filename = fullfile(FolderStimImpactRecords, [num2str(filereference)  '.h5']);

%% manually

fs_eeg=250;
freqfilter = [1 20];

for i=1:6
    eeg_raw{i} = double(h5read(filename,['/channel' num2str(i) '/raw/']));
end
x_EEG = (0:(length(eeg_raw{1})-1))' / fs_eeg;
for i=1%:length(eeg_raw)
    eeg_raw{i}  = tsd(x_EEG*1E4, eeg_raw{i});
%     eeg_filt{i} = FilterLFPBut(eeg_raw{i}, freqfilter, 96);
    eeg_filt{i} = FilterLFP(eeg_raw{i}, freqfilter, 96);
   
    
end


%% 
[eeg_visu, accelero, stimulations, StageEpochs, labels_eeg, pulse_oximeter] = GetRecordDreem(filename);

%stimulation
time_stim = Range(stimulations);
int_stim = Data(stimulations);

time_sham = time_stim(Data(stimulations)==0); %sham
time_stim = time_stim(Data(stimulations)>0); %true tones, not sham
int_stim = int_stim(Data(stimulations)>0);

stimulations = tsd(time_stim, int_stim);
sham = ts(time_sham);


%% signals
signals{1} = [Range(eeg_visu{1})'/1E4  ; Data(eeg_visu{1})'];
signals{2} = [Range(eeg_filt{1})'/1E4  ; Data(eeg_filt{1})'];
signals{3} = [Range(eeg_raw{1})'/1E4   ; Data(eeg_raw{1})'];
signals{4} = [Range(pulse_oximeter)'/1E4 ; Data(pulse_oximeter)'];
stim_tmp = Range(stimulations)/1E4;

%% plot observer
name_channels = {'Fpz-O1', 'Fpz-O2', 'Fpz-F7', 'F8-F7', 'F7-O1', 'F8-O2'};
labels = ['Fpz-O1 visu', 'filtered', 'raw', {'PulseOxi'}];

sog = SignalObserverGUI(signals,'DisplayWindow',[5 5]);
for ch=1:sog.nb_channel
    sog.add_verticals(stim_tmp, ch)
    sog.set_title(labels{ch}, ch);
end
sog.set_time_events(stim_tmp);

sog.set_ymin(1, -200); sog.set_ymax(1, 200);
sog.set_ymin(2, -400); sog.set_ymax(2, 400);
sog.set_ymin(3, -5e4); sog.set_ymax(3, 5e4);
sog.set_ymin(4, -200); sog.set_ymax(4, 200);

sog.run_window




