function GetProcessedVariables_EC(force_no_sleep_scoring)
% Process Neural Data with Necessary Checks
% Optional input: force_no_sleep_scoring (true/false)

if nargin < 1
    force_no_sleep_scoring = false;
end

% Define required channel files
dHPC_deep_file = 'ChannelsToAnalyse/dHPC_deep.mat';
dHPC_rip_file = 'ChannelsToAnalyse/dHPC_rip.mat';
Bulb_deep_file = 'ChannelsToAnalyse/Bulb_deep.mat';
EKG_file = 'ChannelsToAnalyse/EKG.mat';
lfp_file = '';

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
    end
end

% Check for required channels for sleep scoring
if force_no_sleep_scoring
    perform_sleep_scoring = false;
    disp('Sleep scoring is forcibly disabled by user.');
elseif exist(dHPC_deep_file, 'file') || exist(dHPC_rip_file, 'file')
    disp('Sleep scoring can be performed.');
    perform_sleep_scoring = true;
else
    disp('No dHPC deep or dHPC rip channel found. Skipping sleep scoring.');
    perform_sleep_scoring = false;
end


% Check for required channel for ripple detection
if exist(dHPC_rip_file, 'file')
    perform_ripple_detection = true;
else
    disp('No dHPC rip channel found. Skipping ripple detection.');
    perform_ripple_detection = false;
end

% Check for Bulb_deep channel for OB gamma power calculation
compute_OB_gamma = exist(Bulb_deep_file, 'file');

%% Get low frequency spectra - example with bulb
if compute_OB_gamma && ~exist(low_spectrogram_file, 'file')
    load(Bulb_deep_file, 'channel');
    LowSpectrumSB([cd filesep], channel, 'B');
else
    disp('B_Low_Spectrum.mat already exists or Bulb deep channel not found. Skipping low frequency spectra computation.');
end

%% Get high frequency spectra - example with bulb
if compute_OB_gamma && ~exist(high_spectrogram_file, 'file')
    load(Bulb_deep_file, 'channel');
    HighSpectrum([cd filesep], channel, 'B');
else
    disp('B_High_Spectrum.mat already exists or Bulb deep channel not found. Skipping high frequency spectra computation.');
end

%% Get heart beats (without noise correction first)
if exist(EKG_file, 'file')
    load(EKG_file, 'channel');
    lfp_file = ['LFPData/LFP', num2str(channel), '.mat'];

    if exist(lfp_file, 'file')
        load(lfp_file, 'LFP');

        % Initial options for heartbeat detection
        Options.TemplateThreshStd = 3;
        Options.BeatThreshStd = 1.5;
        modify_options = true;

        while modify_options
            % First, detect heartbeats WITHOUT noise correction and plot
            disp('Plotting detected heartbeats before computing noise...');
            [Times, Template, HeartRate, ~] = DetectHeartBeats_EmbReact_SB(LFP, intervalSet([], []), Options, 1);

            % Get figure handle
            hb_figure = gcf;

            % Pause execution for inspection
            disp('Inspect the plot. Do you want to modify the detection options? (y/n)');
            user_input = input('Enter y to modify options, n to continue: ', 's');

            % Close the plot after inspection
            if ishandle(hb_figure)
                close(hb_figure);
            end

            % Allow user to modify options
            if lower(user_input) == 'y'
                Options.TemplateThreshStd = input('Enter new TemplateThreshStd value: ');
                Options.BeatThreshStd = input('Enter new BeatThreshStd value: ');
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


%% Compute noise epochs (only if sleep scoring is NOT performed)
if ~perform_sleep_scoring && compute_OB_gamma
    FindNoiseEpoch_BM([cd filesep], channel, 0);

    % Close all noise-related plots
    close all;
else
    if ~compute_OB_gamma
        disp('Bulb deep channel not found. Skipping noisy epoch computation.');
    else
        disp('Sleep scoring includes noise detection. Skipping separate noisy epoch computation.');
    end
end

%% Sleep scoring (if applicable)
if perform_sleep_scoring
    disp('Running sleep scoring...');
    SleepScoring_Accelero_OBgamma;
end

%% Get heart beats (WITH noise correction, AFTER sleep scoring if performed)
if exist(EKG_file, 'file') && exist(lfp_file, 'file')
    % Check if noise epochs were computed
    if exist('StateEpochSB.mat', 'file')
        load('StateEpochSB.mat', 'TotalNoiseEpoch');
        [Times, Template, HeartRate, GoodEpoch] = DetectHeartBeats_EmbReact_SB(LFP, TotalNoiseEpoch, Options, 1);
    else
        disp('StateEpochSB.mat missing, proceeding without noise correction.');
        GoodEpoch = [];
    end

    % Store results
    EKG.HBTimes = ts(Times);
    EKG.HBShape = Template;
    EKG.DetectionOptions = Options;
    EKG.HBRate = HeartRate;
    EKG.GoodEpoch = GoodEpoch;

    % Save results
    save('HeartBeatInfo.mat', 'EKG');
    saveas(gcf, 'EKGCheck.fig');
    saveas(gcf, 'EKGCheck.png');

end

%% Get breathing from OB
if ~exist(respi_freq_file, 'file') && exist(low_spectrogram_file, 'file')
    load(low_spectrogram_file, 'Spectro');
    Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(Spectro{3}, Spectro{2} * 1e4, Spectro{1});

    % Remove noise if available
    if exist('StateEpochSB.mat', 'file')
        load('StateEpochSB.mat', 'Epoch');  % Clean epoch
        Spectrum_Frequency = Restrict(Spectrum_Frequency, Epoch);
        disp('Denoised RespiFreq');
    end
    save(respi_freq_file, 'Spectrum_Frequency');


else
    disp('RespiFreq.mat already exists or B_Low_Spectrum.mat not found. Skipping OB breathing computation.');
end

%% Get gamma power (only if sleep scoring is NOT performed)
if ~perform_sleep_scoring && compute_OB_gamma
    load(Bulb_deep_file, 'channel');
    lfp_file = ['LFPData/LFP', num2str(channel), '.mat'];

    if exist(lfp_file, 'file')
        load(lfp_file, 'LFP');
        FilGamma = FilterLFP(LFP, [50 70], 1024);
        HilGamma = hilbert(Data(FilGamma));
        H = abs(HilGamma);
        tot_ghi = tsd(Range(LFP), H);
        smootime = 3;
        SmoothGamma = tsd(Range(tot_ghi), runmean(Data(tot_ghi), ceil(smootime / median(diff(Range(tot_ghi, 's'))))));

        % Remove noise if available
        if exist('StateEpochSB.mat', 'file')
            load('StateEpochSB.mat', 'Epoch');  % This is the clean (non-noisy) epoch
            SmoothGamma = Restrict(SmoothGamma, Epoch);
            disp('Denoised SmoothGamma')
        end

        save('SleepScoring_OBGamma', 'SmoothGamma');

    else
        disp('LFP data file missing for Bulb deep channel. Skipping gamma power computation.');
    end
else
    if perform_sleep_scoring
        disp('Sleep scoring includes gamma power computation. Skipping separate gamma power computation.');
    end
end

%% Get ripples
if perform_ripple_detection
    CreateRipplesSleep('stim', 0, 'restrict', 1, 'sleep', 1);
end

% Close any remaining figures
close all;

end
