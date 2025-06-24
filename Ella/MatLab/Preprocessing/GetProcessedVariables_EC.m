function GetProcessedVariables_EC(sleepscoring, predefine_gammathresh)
% Process Neural Data with Necessary Checks
% Inputs:
%   - sleepscoring: true/false to enable or disable sleep scoring
%   - predefine_gammathresh: numeric value for gamma threshold (optional)

if nargin < 1
    sleepscoring = false;
end
if nargin < 2
    predefine_gammathresh = [];
end


% Define required channel files
Bulb_deep_file = 'ChannelsToAnalyse/Bulb_deep.mat';
EKG_file = 'ChannelsToAnalyse/EKG.mat';

% Define output files to check
heartbeat_file = 'HeartBeatInfo.mat';
noise_file = 'StateEpochSB.mat';
sleep_scoring_file = 'SleepScoring_OBGamma.mat';
low_spectrogram_file = 'B_Low_Spectrum.mat';
high_spectrogram_file = 'B_High_Spectrum.mat';
respi_freq_file = 'RespiFreq.mat';

% Check if variables have already been generated
if exist(heartbeat_file, 'file') && exist(noise_file, 'file') && exist(sleep_scoring_file, 'file')
    user_input = input('Processed variables already exist. Do you want to reprocess? (y/n): ', 's');
    if lower(user_input) ~= 'y'
        disp('Skipping processing.');
        return;
    else
        fprintf('--- Starting preprocessing of neural data ---\n');
    end
else
    fprintf('--- Starting preprocessing of neural data ---\n');
end

% Check for Bulb_deep channel for OB gamma power calculation
compute_OB_gamma = exist(Bulb_deep_file, 'file');
if compute_OB_gamma
    load(Bulb_deep_file, 'channel');
    channel_bulb = channel;
end

% Initialize folder name
foldername = pwd;
if foldername(end) ~= filesep
    foldername(end+1) = filesep;
end


%% Get low frequency spectra - example with bulb
if compute_OB_gamma && ~exist(low_spectrogram_file, 'file')
    fprintf('Computing low frequency spectrum...\n');
    LowSpectrumSB(foldername, channel_bulb, 'B');
else
    disp('B_Low_Spectrum.mat already exists or Bulb deep channel not found. Skipping low frequency spectra computation.');
end

%% Get high frequency spectra - example with bulb
if compute_OB_gamma && ~exist(high_spectrogram_file, 'file')
    fprintf('Computing high frequency spectrum...\n');
    HighSpectrum(foldername, channel_bulb, 'B');
else
    disp('B_High_Spectrum.mat already exists or Bulb deep channel not found. Skipping high frequency spectra computation.');
end

%% Get heart beats (without noise correction first)
if exist(EKG_file, 'file')
    load(EKG_file, 'channel');
    channel_ekg = channel;
    lfp_file = fullfile('LFPData', ['LFP', num2str(channel_ekg), '.mat']);

    if exist(lfp_file, 'file')
        load(lfp_file, 'LFP');

        Options.TemplateThreshStd = 3;
        Options.BeatThreshStd = 1.5;
        modify_options = true;

        while modify_options
            fprintf('Plotting detected heartbeats before computing noise...\n');
            [Times, Template, HeartRate, ~] = DetectHeartBeats_EmbReact_SB(LFP, intervalSet([], []), Options, 1);
            hb_figure = gcf;

            user_input = input('Inspect the plot. Do you want to modify the detection options? (y/n): ', 's');

            if ishandle(hb_figure)
                close(hb_figure);
            end

            if lower(user_input) == 'y'
                Options.TemplateThreshStd = input('Enter new TemplateThreshStd value (default = 3): ');
                Options.BeatThreshStd = input('Enter new BeatThreshStd value (default = 1.5): ');
            else
                modify_options = false;
            end
        end
    else
        disp('LFP data file missing. Skipping heart beat detection.');
    end
else
    disp('EKG channel file not found. Skipping heart beat detection.');
end

%% Compute noise epochs (always)
if compute_OB_gamma
    fprintf('Computing noisy epochs...\n');
    FindNoiseEpoch_BM(foldername, channel_bulb, 0);
    close all force;
else
    disp('Bulb deep channel not found. Skipping noisy epoch computation.');
end

%% Sleep scoring (if applicable)
if sleepscoring && compute_OB_gamma
    load('StateEpochSB.mat', 'Epoch');

    smootime = 3;
    Frequency = [50 70];
    minduration = 3;

    fprintf('Running sleep scoring...\n');
    if isempty(predefine_gammathresh)
        [SleepEpoch, SmoothGamma, Info] = FindGammaEpoch_SleepScoring(Epoch, channel_bulb, minduration, ...
            'foldername', foldername, 'smoothwindow', smootime);
    else
        [SleepEpoch, SmoothGamma, Info] = FindGammaEpoch_SleepScoring(Epoch, channel_bulb, minduration, ...
            'foldername', foldername, 'smoothwindow', smootime, ...
            'predefinegammathresh', predefine_gammathresh);
    end

    WakeEpoch = Epoch - SleepEpoch;
    save('SleepScoring_OBGamma.mat', 'SleepEpoch', 'WakeEpoch', 'SmoothGamma', 'Info');
    disp('Saved sleep and wake epochs.');
end

%% Get heart beats (WITH noise correction)
if exist(EKG_file, 'file') && exist('lfp_file', 'var') && exist(lfp_file, 'file')
    if exist('StateEpochSB.mat', 'file')
        load('StateEpochSB.mat', 'TotalNoiseEpoch');
        [Times, Template, HeartRate, GoodEpoch] = DetectHeartBeats_EmbReact_SB(LFP, TotalNoiseEpoch, Options, 1);
        disp('Denoised HeartBeatInfo')
    else
        disp('StateEpochSB.mat missing, proceeding without noise correction.');
        GoodEpoch = [];
    end

    EKG.HBTimes = ts(Times);
    EKG.HBShape = Template;
    EKG.DetectionOptions = Options;
    EKG.HBRate = HeartRate;
    EKG.GoodEpoch = GoodEpoch;

    save('HeartBeatInfo.mat', 'EKG');
    saveas(gcf, 'EKGCheck.fig');
    saveas(gcf, 'EKGCheck.png');
end

%% Get breathing from OB
if ~exist(respi_freq_file, 'file') && exist(low_spectrogram_file, 'file')
    load(low_spectrogram_file, 'Spectro');
    Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(Spectro{3}, Spectro{2} * 1e4, Spectro{1});

    if exist('StateEpochSB.mat', 'file')
        load('StateEpochSB.mat', 'Epoch');
        Spectrum_Frequency = Restrict(Spectrum_Frequency, Epoch);
        disp('Denoised RespiFreq');
    end
    save(respi_freq_file, 'Spectrum_Frequency');
else
    disp('RespiFreq.mat already exists or B_Low_Spectrum.mat not found. Skipping OB breathing computation.');
end

%% Get gamma power (only if sleep scoring is NOT performed)
if ~sleepscoring && compute_OB_gamma
    lfp_file = fullfile('LFPData', ['LFP', num2str(channel_bulb), '.mat']);

    if exist(lfp_file, 'file')
        load(lfp_file, 'LFP');
        FilGamma = FilterLFP(LFP, [50 70], 1024);
        HilGamma = hilbert(Data(FilGamma));
        H = abs(HilGamma);
        tot_ghi = tsd(Range(LFP), H);
        smootime = 3;
        SmoothGamma = tsd(Range(tot_ghi), runmean(Data(tot_ghi), ceil(smootime / median(diff(Range(tot_ghi, 's'))))));

        % if exist('StateEpochSB.mat', 'file')
        %     load('StateEpochSB.mat', 'Epoch');
        %     SmoothGamma = Restrict(SmoothGamma, Epoch);
        %     disp('Denoised SmoothGamma')
        % end

        save('SleepScoring_OBGamma.mat', 'SmoothGamma', '-append');
    else
        disp('LFP data file missing for Bulb deep channel. Skipping gamma power computation.');
    end
else
    if sleepscoring
        disp('Sleep scoring includes gamma power computation. Skipping separate gamma power computation.');
    end
end

%% Wrap-up
fprintf('--- Preprocessing complete. ---\n');
fprintf('Generated files include:\n');
if exist(heartbeat_file, 'file'), fprintf(' - %s\n', heartbeat_file); end
if exist(noise_file, 'file'), fprintf(' - %s\n', noise_file); end
if exist(sleep_scoring_file, 'file'), fprintf(' - %s\n', sleep_scoring_file); end
if exist(respi_freq_file, 'file'), fprintf(' - %s\n', respi_freq_file); end

close all force;
end
