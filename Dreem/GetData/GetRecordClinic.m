function [signals, stimulations, StageEpochs, name_channel, domain, NameSleepStage] = GetRecordClinic(filename,varargin)
%   [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(filename,varargin)
%
% INPUT:
% - filename                Filename of the hdF5 file
% 
% - freqFilter              (optional) vector 1x2
%                           frequency range of the filter applied on EEG raw signals
%                           default: [0.4 40]
% - fs_eeg                  (optional) double
%                           sampling frequency of the EEG signals (Hz)
%                           default: 250
% - fs_emg                  (optional) double
%                           sampling frequency of the EMG signals (Hz)
%                           default: 250
% - fs_ecg                  (optional) double
%                           sampling frequency of the ECG signals (Hz)
%                           default: 250
% - fs_eog                  (optional) double
%                           sampling frequency of the EOG signals (Hz)
%                           default: 150
% - stage_epoch_duration    (optional) double
%                           duration of an epoch in the hypnogram (1E-4s)
%                           default: 30E4
%
%
% OUTPUT:
% - signals                 struct tsd - Filtered EEG signals and EMG/ECG/EOG signals
% - stimulations            tsd - stimulation times and intensities
% - StageEpochs             struct intervalSet - intervalSet for each Sleep Stage
%                           1: N1, 2: N2, 3: N3, 4: REM, 5: Wake
% - name_channel            'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'
% - domain                  'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'
% - NameSleepStage          'N1','N2','N3','REM','Wake' 
%
%
%       see 
%           GetRecordDreem
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'freqfilter'
            freqfilter = varargin{i+1};
            if ~isvector(freqfilter) || length(freqfilter)~=2
                error('Incorrect value for property ''freqfilter''.');
            end
        case 'fs_eeg'
            fs_eeg = varargin{i+1};
            if ~isvector(fs_eeg) || length(fs_eeg)~=1
                error('Incorrect value for property ''fs_eeg''.');
            end
        case 'fs_emg'
            fs_emg = varargin{i+1};
            if ~isvector(fs_emg) || length(fs_emg)~=1
                error('Incorrect value for property ''fs_emg''.');
            end
        case 'fs_ecg'
            fs_ecg = varargin{i+1};
            if ~isvector(fs_ecg) || length(fs_ecg)~=1
                error('Incorrect value for property ''fs_ecg''.');
            end
        case 'fs_eog'
            fs_eog = varargin{i+1};
            if ~isvector(fs_eog) || length(fs_eog)~=1
                error('Incorrect value for property ''fs_eog''.');
            end
        case 'stage_epoch_duration'
            stage_epoch_duration = varargin{i+1};
            if ~isvector(stage_epoch_duration) || length(stage_epoch_duration)~=1
                error('Incorrect value for property ''stage_epoch_duration''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if h5 file exists
if ~(exist(filename, 'file') == 2)
    error(['File ' filename ' not found.'])
end


%check if exist and assign default value if not
if ~exist('freqfilter','var')
    freqfilter = [0.4 40];
end
if ~exist('fs_eeg','var')
    fs_eeg = 250;
end
if ~exist('fs_emg','var')
    fs_emg = 250;
end
if ~exist('fs_ecg','var')
    fs_ecg = 250;
end
if ~exist('fs_eog','var')
    fs_eog = 150;
end
if ~exist('stage_epoch_duration','var')
    stage_epoch_duration = 30E4;
end


%params
name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
domain = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'};
NameSleepStage = {'N1','N2','N3','REM','Wake'};


%% load
Signals_raw = cell(0);
for i=1:length(name_channel)
    switch(domain{i})
        case 'EEG'
            Signals_raw{end+1} = double(h5read(filename,['/channel' num2str(i) '/visualization/']));
        case 'EMG'
            try
                Signals_raw{end+1} = double(h5read(filename,['/channel' num2str(i) '/emg/']));
            end
        case 'ECG'
            try
                Signals_raw{end+1} = double(h5read(filename,['/channel' num2str(i) '/ecg/']));
            end
        case 'EOG'
            try
                Signals_raw{end+1} = double(h5read(filename,['/channel' num2str(i) '/eog/']));
            end
        otherwise
            error(['Unknown domain for channel ' num2str(i)]);
    end
end

%adjust
name_channel = name_channel(1:length(Signals_raw));
domain = domain(1:length(Signals_raw));


%Arousals = double(h5read(filename,'/reporting/arousals/'));
Hypnogram = double(h5read(filename,'/reporting/hypnogram/'));
Stim = double(h5read(filename,'/stimulations/stimulations/'));
Stim_int =  double(h5read(filename,'/stimulations/stimulations_intensity/'));


%% tsd 
for i=1:length(Signals_raw)
    switch(domain{i})
        case 'EEG'
            x = (0:(length(Signals_raw{i})-1))' / fs_eeg;
            signals{i} = tsd(x*1E4, Signals_raw{i});
        case 'EMG'
            x = (0:(length(Signals_raw{i})-1))' / fs_emg;
            signals{i} = tsd(x*1E4, Signals_raw{i});
        case 'ECG'
            x = (0:(length(Signals_raw{i})-1))' / fs_ecg;
            signals{i} = tsd(x*1E4, Signals_raw{i});
        case 'EOG'
            x = (0:(length(Signals_raw{i})-1))' / fs_eog;
            signals{i} = tsd(x*1E4, Signals_raw{i});
        otherwise
            error(['Unknown domain for channel ' num2str(i)]);
    end
end


%stim
stimulations = tsd((Stim / fs_eeg)*1E4, Stim_int);


%% Hypnogram
stage_ind = 0:4;
for ss = stage_ind
    start_substage = find(Hypnogram==ss);
    intv = intervalSet((start_substage-1)*stage_epoch_duration,start_substage*stage_epoch_duration);
    if ss==0 %Wake
        StageEpochs{5} = mergeCloseIntervals(intv, 10);
    else
        StageEpochs{ss} = mergeCloseIntervals(intv, 10);
    end
end


end


