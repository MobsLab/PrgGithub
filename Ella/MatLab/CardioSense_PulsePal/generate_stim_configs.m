function configsByFreq = generate_stim_configs(frequencies, phaseDurations, burstDurations)
    %GENERATE_STIM_CONFIGS Generate stimulation configs grouped by frequency
    %
    % Inputs:
    %   frequencies   - vector of frequencies (Hz), e.g. 5:0.5:10
    %   phaseDurations - vector of phase durations (s), e.g. [0.01, 0.005]
    %   burstDurations - vector of burst durations (s), e.g. [0.5, 1.0, 1.5]
    %
    % Output:
    %   configsByFreq - struct array with fields:
    %       Frequency - the frequency value
    %       Configs   - array of structs with fields:
    %           PhaseDuration
    %           InterPulseInterval
    %           BurstDuration
    %           InterBurstInterval
    %           PulseTrainDuration

    % Pre-allocate struct array
    configsByFreq = repmat(struct('Frequency', [], 'Configs', []), length(frequencies), 1);

    for f_idx = 1:length(frequencies)
        f = frequencies(f_idx);

        % Number of configs per frequency = length(phaseDurations) * length(burstDurations)
        nConfigs = numel(phaseDurations) * numel(burstDurations);

        configList = repmat(struct('PhaseDuration', [], 'InterPulseInterval', [], ...
                                   'BurstDuration', [], 'InterBurstInterval', [], ...
                                   'PulseTrainDuration', []), 1, nConfigs);
        c_idx = 1;

        for pd = phaseDurations
            ipi = round((1 / f - pd), 3);

            for bd = burstDurations
                ibd = bd + 4.0;
                ptd = (bd + ibd) * 15;

                configList(c_idx) = struct( ...
                    'PhaseDuration', pd, ...
                    'InterPulseInterval', ipi, ...
                    'BurstDuration', bd, ...
                    'InterBurstInterval', ibd, ...
                    'PulseTrainDuration', ptd ...
                );
                c_idx = c_idx + 1;
            end
        end

        configsByFreq(f_idx).Frequency = f;
        configsByFreq(f_idx).Configs = configList;
    end
end



% % Clean up any previous conflicting definitions
% clear all
% 
% % Define parameters
% frequencies = 9.5:-0.5:5.0;
% phaseDurations = [0.01, 0.005];
% burstDurations = [0.5, 1.0, 1.5];
% 
% % Initialize struct array with known fields
% configsByFreq = repmat(struct('Frequency', [], 'Configs', []), length(frequencies), 1);
% 
% % Loop through frequencies
% for f_idx = 1:length(frequencies)
%     f = frequencies(f_idx);
%     configList = repmat(struct('PhaseDuration', [], 'InterPulseInterval', [], ...
%                                'BurstDuration', [], 'InterBurstInterval', [], ...
%                                'PulseTrainDuration', []), ...
%                         1, numel(phaseDurations) * numel(burstDurations));
%     c_idx = 1;
% 
%     for pd = phaseDurations
%         ipi = round((1 / f - pd), 3);
% 
%         for bd = burstDurations
%             ibd = bd + 4.0;
%             ptd = (bd + ibd) * 10;
% 
%             configList(c_idx) = struct( ...
%                 'PhaseDuration', pd, ...
%                 'InterPulseInterval', ipi, ...
%                 'BurstDuration', bd, ...
%                 'InterBurstInterval', ibd, ...
%                 'PulseTrainDuration', ptd ...
%             );
%             c_idx = c_idx + 1;
%         end
%     end
% 
%     configsByFreq(f_idx).Frequency = f;
%     configsByFreq(f_idx).Configs = configList;
% end
