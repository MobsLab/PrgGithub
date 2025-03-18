function GetProcessedVariables_EC()
    % Process Neural Data with Necessary Checks

    % Define required channel files
    dHPC_deep_file = 'ChannelsToAnalyse/dHPC_deep.mat';
    dHPC_rip_file = 'ChannelsToAnalyse/dHPC_rip.mat';
    Bulb_deep_file = 'ChannelsToAnalyse/Bulb_deep.mat';
    EKG_file = 'ChannelsToAnalyse/EKG.mat';

    % Check for required channels for sleep scoring
    if exist(dHPC_deep_file, 'file') || exist(dHPC_rip_file, 'file')
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
    if compute_OB_gamma
        load(Bulb_deep_file, 'channel');
        LowSpectrumSB([cd filesep], channel, 'B');
    else
        disp('Bulb deep channel not found. Skipping low frequency spectra computation.');
    end

    %% Get high frequency spectra - example with bulb
    if compute_OB_gamma
        load(Bulb_deep_file, 'channel');
        HighSpectrum([cd filesep], channel, 'B');
    else
        disp('Bulb deep channel not found. Skipping high frequency spectra computation.');
    end

    %% Get breathing from OB
    if exist('B_Low_Spectrum.mat', 'file')
        load('B_Low_Spectrum.mat', 'Spectro');
        Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(Spectro{3}, Spectro{2} * 1e4, Spectro{1});
        save('RespiFreq', 'Spectrum_Frequency');
    else
        disp('B_Low_Spectrum.mat not found. Skipping OB breathing computation.');
    end

    %% Get noisy epochs
    if compute_OB_gamma
        load(Bulb_deep_file, 'channel');
        LowSpectrumSB([cd filesep], channel, 'B');
        FindNoiseEpoch_BM([cd filesep], channel, 0);
    else
        disp('Bulb deep channel not found. Skipping noisy epoch computation.');
    end

    %% Get heart beats
    if exist(EKG_file, 'file')
        load(EKG_file, 'channel');
        lfp_file = ['LFPData/LFP', num2str(channel), '.mat'];
        
        if exist(lfp_file, 'file') && exist('StateEpochSB.mat', 'file')
            load(lfp_file, 'LFP');
            load('StateEpochSB.mat', 'TotalNoiseEpoch');

            Options.TemplateThreshStd = 3;
            Options.BeatThreshStd = 0.05;

            [Times, Template, HeartRate, GoodEpoch] = DetectHeartBeats_EmbReact_SB(LFP, TotalNoiseEpoch, Options, 1);

            EKG.HBTimes = ts(Times);
            EKG.HBShape = Template;
            EKG.DetectionOptions = Options;
            EKG.HBRate = HeartRate;
            EKG.GoodEpoch = GoodEpoch;

            save('HeartBeatInfo.mat', 'EKG');
            saveas(gcf, 'EKGCheck.fig');
            saveas(gcf, 'EKGCheck.png');
        else
            disp('Required LFP or StateEpochSB.mat file missing. Skipping heart beat detection.');
        end
    else
        disp('EKG channel file not found. Skipping heart beat detection.');
    end

    %% Get gamma power (only if sleep scoring is not performed)
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

            save('SleepScoring_OBGamma', 'SmoothGamma');
        else
            disp('LFP data file missing for Bulb deep channel. Skipping gamma power computation.');
        end
    end

    %% Sleep scoring
    if perform_sleep_scoring
        SleepScoringOBGamma;
    end

    %% Get ripples
    if perform_ripple_detection
        CreateRipplesSleep('stim', 0, 'restrict', 1, 'sleep', 1);
    end
end
