function [EEG, accelero, stimulations, StageEpochs, labels_eeg, pulse_oximeter] = GetRecordDreem(filename,varargin)
%
%    [EEG, accelero, stimulations, StageEpochs, labels_eeg, pulse_oximeter] = GetRecordDreem(filename,varargin)
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
% - fs_accelero             (optional) double
%                           sampling frequency of the accelero signals (Hz)
%                           default: 50
% - stage_epoch_duration    (optional) double
%                           duration of an epoch in the hypnogram (1E-4s)
%                           default: 30E4
%
%
% OUTPUT:
% - signals                 struct tsd - Filtered EEG signals
% - accelero                tsd - accelerometer norm
% - stimulations            ts - stimulation times
% - StageEpochs             struct intervalSet - intervalSet for each Sleep Stage
%                           1: N1, 2: N2, 3: N3, 4: REM, 5: Wake
% - labels_eeg              'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz'
% - pulse_oximeter          tsd - pulse oxymeter
%
%       see 
%           GetRecordClinic
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
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
        case 'fs_accelero'
            fs_accelero = varargin{i+1};
            if ~isvector(fs_accelero) || length(fs_accelero)~=1
                error('Incorrect value for property ''fs_accelero''.');
            end
        case 'fs_pulseoxy'
            fs_pulseoxy = varargin{i+1};
            if ~isvector(fs_pulseoxy) || length(fs_pulseoxy)~=1
                error('Incorrect value for property ''fs_pulseoxy''.');
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

%check if exist and assign default value if not
if ~exist('freqfilter','var')
    freqfilter = [0.4 40];
end
if ~exist('fs_eeg','var')
    fs_eeg = 250;
end
if ~exist('fs_accelero','var')
    fs_accelero = 50;
end
if ~exist('fs_pulseoxy','var')
    fs_pulseoxy = 50;
end
if ~exist('stage_epoch_duration','var')
    stage_epoch_duration = 30E4;
end


%params
NameSleepStage = {'N1','N2','N3','REM','Wake','Unknown'};
stage_ind = 1:5;
delay_stim = 3120; %312ms


%% load

%eeg channels
fileinfo = h5info(filename);
chan = find(contains({fileinfo.Groups.Name}, 'channel'));
for i=1:length(chan)
    chgroup = fileinfo.Groups(chan(i)).Name;

    EEG{i} = double(h5read(filename,[chgroup '/visualization/']));
    try
        labels_eeg{i} = h5readatt(filename,chgroup,'location');
    catch
        labels_eeg{i} = ['CH' chgroup(9:end)];
    end
end

%accelero
Accelero = double(h5read(filename,'/accelerometer/norm/'));
%stim
Stim = double(h5read(filename,'/stimulations/stimulations/'));
Stim_int =  double(h5read(filename,'/stimulations/stimulations_intensity/'));

%hypnograms
try
    Hypnogram = double(h5read(filename,'/reporting/hypnograms/'));
catch
    try
        Hypnogram = double(h5read(filename,'/algo/dreemnogram/'));
    catch
        try
            Hypnogram = double(h5read(filename,'/reporting/dreemnogram/'));
        catch
            Hypnogram = [];
        end
    end
end

%pulse oxymeter
PulseOxi =  double(h5read(filename,'/pulse_oximeter/infrared_filtered/'));


%% times
x_EEG = (0:(length(EEG{1})-1))' / fs_eeg;
x_accelero = (0:(length(Accelero)-1))' / fs_accelero;
x_pulseoxi = (0:(length(PulseOxi)-1))' / fs_pulseoxy;


%% tsd 

%eeg
for ch=1:length(EEG)
    EEG{ch}     = tsd(x_EEG*1E4, EEG{ch});
%     EEG{ch} = FilterLFPBut(EEG{ch}, freqfilter, 4);
end

%accelero
accelero = tsd(x_accelero*1E4, Accelero);

%pulse_oxy
pulse_oximeter = tsd(x_pulseoxi*1E4, PulseOxi);

%stim
[Stim, idx] = sort(Stim);
Stim_int = Stim_int(idx);
stimulations = tsd((Stim / fs_eeg)*1E4 + delay_stim, Stim_int);


%% Hypnogram
stage_ind = -1:4;
for ss = stage_ind
    start_substage = find(Hypnogram==ss);
    intv = intervalSet((start_substage-1)*stage_epoch_duration,start_substage*stage_epoch_duration);
    if ss==0 %Wake
        StageEpochs{5} = mergeCloseIntervals(intv, 10);
    elseif ss==-1 %Noise
        StageEpochs{6} = mergeCloseIntervals(intv, 10);
    else
        StageEpochs{ss} = mergeCloseIntervals(intv, 10);
    end
end


end


