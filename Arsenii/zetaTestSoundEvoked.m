function zetaTestSoundEvoked(spikes, Starttime)
% zetaTestSoundEvoked  Tests each cluster for significant sound-evoked responses.
%
%  INPUTS:
%    spikes    - N x M matrix, where each column M is one cluster and each row is a spike time (in seconds).
%                Unused rows may be NaN or 0 if a cluster has fewer than N spikes.
%    Starttime - 1 x T vector of stimulus onset times (one onset per trial).
%
%  OUTPUTS:
%    The function will display or store the computed z-score (zeta) for each cluster
%    and a simple significance estimate.

    % -- User-defined parameters --
    stimulusDuration = 3;     % seconds
    nShuffle         = 1000;  % number of permutations for null distribution
    
    % Make sure spikes is a double matrix, remove any trailing NaNs or zeros if needed
    % (Adjust as appropriate for your data structure)
%     spikes = double(spikes);
    
    % Number of clusters (neurons)
    nClusters = size(spikes, 2);
    
    % Number of trials
    nTrials = length(Starttime);
    
    % Pre-allocate results
    zetaValues = nan(1, nClusters);
    pValues    = nan(1, nClusters);

    % Loop over each cluster
    for c = 1:nClusters
        
        % Extract the spike times for this cluster, dropping NaNs or zeros
        spikeTimesRaw = spikes(:, c);
        spikeTimesRaw = spikeTimesRaw(~isnan(spikeTimesRaw) & spikeTimesRaw > 0);
        
        % STEP 1: Compute observed spike count across all trials in the 3s window
        observedCount = 0;
        for t = 1:nTrials
            tStart = Starttime(t);
            tEnd   = tStart + stimulusDuration;
            % Count how many spikes fall in [tStart, tEnd]
            observedCount = observedCount + sum(spikeTimesRaw >= tStart & spikeTimesRaw <= tEnd);
        end
        
        % STEP 2: Build null distribution by shuffling
        % There are many ways to shuffle. 
        % One simple approach: shuffle the assignment of spike times to trials 
        % while preserving the total number of spikes.
        
        nullCounts = zeros(1, nShuffle);
        nSpikes = length(spikeTimesRaw); % total spikes for this cluster
        
        for shuf = 1:nShuffle
            % Shuffle approach #1: randomize the assignment of each spike to a "trial onset"
            % Then count how many would fall into the [onset, onset+3] window.
            % 
            % Alternatively, you might "circularly shift" spike times or do a 
            % different surrogate that better fits your experimental design.
            
            % Randomly pick trial onsets for each spike
            randomTrials = randi(nTrials, [nSpikes 1]); 
            
            % For each spike, define "fake" spike time by offset from chosen trial
            % We keep the relative offset (spikeTimeRaw - someTrialStart) 
            % but choose a new random trial's onset. This is just one example method.
            
            % Real offsets from some chosen "true" onset (could be the first trial, etc.)
            % For simplicity, let's just assign each spike a random offset in [0, 3] as a naive approach:
            % (Again, adapt to preserve the ISI distribution, etc., if you want a more rigorous surrogate.)
            fakeSpikeTimes = zeros(nSpikes, 1);
            for sIdx = 1:nSpikes
                % generate a random offset within [0, 3]
                offset = 3 * rand; 
                fakeSpikeTimes(sIdx) = Starttime(randomTrials(sIdx)) + offset;
            end
            
            % Now count how many of these "fake spikes" lie in the corresponding 3s window
            % For each assigned trial, the window is [Starttime(...), Starttime(...) + 3].
            % Because we forced each spike time to be Starttime(...) + offset (with offset < 3),
            % effectively all "fake spikes" lie in their assigned window by construction.
            %
            % Therefore, the total count across all trials = number of spikes = nSpikes
            % That is trivially the same. We need a better shuffle approach that 
            % does not automatically place spikes in the window:
            
            % More general approach: 
            %   - Keep real spike times as is, 
            %   - Randomly shift the entire set of spike times 
            %     by a uniform offset within the inter-trial interval (or entire session),
            %   - Then count how many fall in each trial window.
            
            % Let's demonstrate the random "global shift" method:
            
            % (1) pick a random shift within e.g. 0–(max session time)
            %     or you can do a circular shift. For simplicity, pick from 0–3 here
            %     (not a standard approach, adapt to your experiment.)
            maxShift       = 3;
            randomTimeShift = maxShift * rand;
            
            % (2) shift all spike times by randomTimeShift
            shiftedTimes = spikeTimesRaw + randomTimeShift;
            
            % (3) possibly wrap around if you want a circular shift:
            %     (comment out if not wanted)
            % sessionEnd = max(Starttime) + stimulusDuration; % e.g. last trial end
            % idxWrap    = shiftedTimes > sessionEnd;
            % shiftedTimes(idxWrap) = shiftedTimes(idxWrap) - sessionEnd; 
            
            % (4) Count how many fall into the [starttime, starttime+3] windows
            countShuffled = 0;
            for t2 = 1:nTrials
                tStart2 = Starttime(t2);
                tEnd2   = tStart2 + stimulusDuration;
                countShuffled = countShuffled + sum(shiftedTimes >= tStart2 & shiftedTimes <= tEnd2);
            end
            
            nullCounts(shuf) = countShuffled;
        end
        
        % STEP 3: Compute mean and std of the null distribution
        muNull = mean(nullCounts);
        sdNull = std(nullCounts);
        
        % STEP 4: Zeta / Z-score
        zVal = (observedCount - muNull) / sdNull;
        
        % STEP 5: p-value (two-tailed, normal approx or from empirical rank)
        % Normal-approx:
        %   p = 2 * (1 - normcdf(abs(zVal)));
        % Or empirical from the distribution:
        %   p = mean( abs(nullCounts - muNull) >= abs(observedCount - muNull) );
        
        pVal = 2 * (1 - normcdf(abs(zVal)));  % Normal approximation
        
        % Store results
        zetaValues(c) = zVal;
        pValues(c)    = pVal;
    end
    
    % -- Display or return the results --
    disp('Cluster | Zeta (Z-score) | p-value');
    for c = 1:nClusters
        fprintf('%7d | %14.3f | %7.5f\n', c, zetaValues(c), pValues(c));
    end
    
    % Optionally, you could return them from the function if desired
    % varargout{1} = zetaValues;
    % varargout{2} = pValues;
end