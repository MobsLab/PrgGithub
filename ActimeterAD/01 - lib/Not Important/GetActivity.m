function [ state, f ] = GetActivity( s, sampleRate, ~, ~ )
%GETACTIVITYSTATE Given an actimetry signal, return the activity state
%   Two activity state are detected : awake and sleeping.
%

% Define constantes
IS_SLEEPING = -1;
IS_UNDECIDABLE = 0;
IS_AWAKE = 1;

% Define some aliases
%   ampl_lower_threshold :  if the signal standard deviation is lower
%                       than it and if the main frequency is out of the
%                       accepted range, the activity state is said to be
%                       unknown.
%   ampl_upper_threshold :	if the signal standard deviation is upper thant
%                       it, the activity state is said to be awake.
%   pick_threshold :    picks lower than this fraction of the main pick are
%                       ignored during the picks detection.
%   fCut           :    if necessary, frquencies higher thant fCut are cut
%                       (in Hz)
%   n              :    number of samples
%   sd             :    standard deviation
%   fSleepingRange :    breath frequencies have to be in this range (in Hz)
ampl_lower_threshold = 0.12;
ampl_upper_threshold = 1;
pick_threshold = 1/5;
fCut = 5;
breathRange = [1, 4];

n = length(s);
sd = sqrt(var(s));  % On the last block
sd_last = sqrt(var(s(end-n/4+1:end)));

if sd_last > ampl_upper_threshold
    % The high standard deviation pictures high fluctuations : the mouse is
    % awake. (if the mouse is not sleeping, f is not meaningful)
    state = IS_AWAKE;
    f = 0;
else
    % Center the signal
    s = s - mean(s);
    
    % Filter the signal and get is spectrum
    [s, S] = LowPassFilter(s, fCut, sampleRate);

    % Get the frequency of the main pick and convert it in Hz, this is the
    % breath frequency.
    S = abs(S((floor(n/2)+1:end)));

    [~, f_index] = max(S);
    
    f = (f_index - 1)*sampleRate/n;
    
    % Distinguish the activity state using the main frequency
    if (f < breathRange(1) || f > breathRange(2))
        % f in out of the breath range
        if sd_last < ampl_lower_threshold
            % The standard deviation is too low and the main frequency is
            % out of the typical range for breathing. The activity state is
            % undecidable.
            state = IS_UNDECIDABLE;
        else
            % Else, the activity state is awake
            state = IS_AWAKE;
            f = 0;
        end
    else
        % The activiy state seems to be sleep. So, the regulartiy of the
        % signal is tested.
        
        % Crop the signal to cut off picks and help the crosscorrelation
        s(s > sd) = sd;
        s(s < -sd) = -sd;

        % Compute the crosscorrelation
        r = xcorr(s);
        r = r((end-n+1):end);

        % Get picks
        [t, pick_ampl] = pickDetector(r, 20, r(1)*pick_threshold);

        % Set the new status
        if length(pick_ampl) >= 3
            state = IS_SLEEPING;
        else
            % The activity state is undecidable.
            state = IS_AWAKE;
        end
        
%         thinness = sum(S(f_index-2:f_index+2)) / sum(S);
%         if thinness > 0.5
%             state = IS_SLEEPING;
%         else
%             state = IS_AWAKE;
%         end
    end
end

% Debug
% figure(2); clf;
% subplot(2, 1, 1);
%     hold on;
%     plot(s);
%     plot([0, 400], [sd, sd]);
%     plot([0, 400], [-sd, -sd]);
%     hold off;
% subplot(2, 1, 2);
%     hold on;
%     plot(r);
%     plot(t, pick_ampl, 'r+');
%     hold off;
%disp(thinness);

end

