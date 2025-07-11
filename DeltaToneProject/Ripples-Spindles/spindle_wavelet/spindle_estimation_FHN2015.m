function [spindles_start_end, detected_spindles] = spindle_estimation_FHN2015(LFP, fs, Info)
%
% General call: spindles_start_end = spindle_estimation_FHN2015(x, fs);
%
%% Function for extracting sleep spindles from a single lead EEG data
%
% Inputs:  x            -> EEG data (vector)
%          fs           -> sampling frequency of the EEG
%
%__________________________________________________________________________
% optional inputs:
%          Info.freq_range          -> range over which to search for sleep spindles [default: 11:16]
%          Info.alg_used            -> Choose algorithm to apply to detect sleep spindles
%                                      (currently supporting 'a7' or 'a8')  [default: 'a7']
%          Info.proba_threshold     -> probability threshold for the detection of spindles     
%
%
% =========================================================================
% OUTPUT:  spindles_start_end -> sleep spindle onset (1st column), and spindle offset (2nd column), denoting sample into the time-series. The number of rows indicates the number of detected spindles in the data.
%          detected_spindles  -> Structure with additional information (primarily used for my debugging and additional information)
% =========================================================================
%
% Part of the "Thanasis_EEG_analysis" Toolbox
%
% -----------------------------------------------------------------------
% Useful references:
% 
% 1) A. Tsanas, G.D. Clifford: "Stage-independent, single lead EEG sleep 
% spindle detection using the continuous wavelet transform and local 
% weighted smoothing", Frontiers in Human Neuroscience 9:181, 2015
% -----------------------------------------------------------------------
%
% Last modified on 2nd August 2015
%
% Copyright (c) Athanasios Tsanas, 2015
%
% ********************************************************************
% If you use this program please cite:
%
% A. Tsanas, G.D. Clifford: "Stage-independent, single lead EEG sleep 
% spindle detection using the continuous wavelet transform and local 
% weighted smoothing", Frontiers in Human Neuroscience 9:181, 2015
% ********************************************************************
%
% For any question, to report bugs, or just to say this was useful, email
% tsanasthanasis@gmail.com
% Rewrited by KJ


%% Check inputs
if nargin < 2
  error('Incorrect number of parameters.');
end
if nargin < 3
    Info.freq_range = [10 18];
    Info.algo = 'a7';
end

if ~isfield(Info, 'freq_range')
    Info.freq_range = [10 18];
end
if ~isfield(Info, 'algo')
    Info.algo = 'a7';
end
if ~isfield(Info, 'proba_threshold')
    Info.proba_threshold = 0.3;
end


spindle_frequency_range = Info.freq_range;
alg_used = Info.algo;
proba_threshold = Info.proba_threshold;


%% Resample the signal at 100 Hz and run the main function
new_fs = 100;
tsignal = ResampleTSD(LFP, new_fs);
x = Data(tsignal);
[spindles_start_end, detected_spindles] = main_spindles_function(x, new_fs, spindle_frequency_range, alg_used, proba_threshold);

% rescale the samples approapriately due to the different sampling rate the user may have used
spindles_start_end = round(spindles_start_end./(new_fs/fs));

end


function [spindles_start_end, detected_spindles] = main_spindles_function(x, fs, spindle_frequency_range, alg_used, proba_threshold)
%% internal algorithmic defaults
Frq1 = spindle_frequency_range(1); Frq2 = spindle_frequency_range(end); % frequencies of interest to study (11-16 Hz for sleep spindles!)

detected_spindles = [];

% set minimum and maximum spindle duration
min_spindle_duration = 0.3; max_spindle_duration = 1.5; % expected spindle duration in seconds

topK_coef = 10; % focus on the top K coefficients
movingL = 0.11*fs; % moving filter (number of samples - this was tested for fs = 100Hz)

wname = 'morl'; % Morlet wavelet
scales = 2:0.1:15; % scales corresponding to pseudo-frequencies

% necessary pre-processing of the data: resampling to 100Hz
new_fs = 100; % resampling at 100Hz
fs_original = fs;
Kfs = new_fs/fs_original; % K times the original sampling frequency (note that this is not necessarily scalar)
x = resample(x, new_fs, fs_original); fs = new_fs;

%% Main part of the function

coefs = cwt(x,scales,wname); % Apply CWT
pseudo_freqCWT = scal2frq(scales,wname,1/fs); pseudo_freqCWT=pseudo_freqCWT(:);
[~, idxSca1] = min(abs(pseudo_freqCWT-Frq1));
[~, idxSca2] = min(abs(pseudo_freqCWT-Frq2));
S = abs(coefs.*coefs); SC = 100*S./sum(S(:)); Xcoef = SC;
scales_of_interest = idxSca2:idxSca1;

[~, sortIndex] = sort(Xcoef,'descend');

for jj = 1:size(sortIndex,2)
    [C{jj,1}, ia{jj,1}, ib{jj,1}] = intersect(sortIndex(1:topK_coef,jj), scales_of_interest);
    features_spindles.topcoefs(1,jj) = length(C{jj}); % how many Xcoef coefficients appear in the topK_coef for the studied time interval
    features_spindles.topcoefs(2,jj) = sum(1./ia{jj}); % give weights depending on the order the Xcoef appear at the top

    % now obtain probabilistic estimate for spindle occurence for the sample-by-sample interval
    features_spindles.prob_spindle(jj) = features_spindles.topcoefs(2,jj)/sum(1./(1:topK_coef));
end

%% running mean (smoothing of samples) with movingL-mean filter or exponential weighted moving average
clear spindle*

switch (alg_used)
    case 'a7'
%         features_spindles.prob_spindle_moving = moving(features_spindles.prob_spindle, movingL, @mean);
        features_spindles.prob_spindle_moving = moving_mean(features_spindles.prob_spindle, movingL);
        features_spindles.prob_spindle_moving = features_spindles.prob_spindle_moving(:)';
        features_spindles.prob_spindle_moving2 = max(features_spindles.prob_spindle, features_spindles.prob_spindle_moving);

    case 'a8'
        % Exponential weighted moving average based concept
        movingL=21; y=buffer([zeros(1, floor(movingL/2)), features_spindles.prob_spindle, zeros(1, floor(movingL/2))], movingL, movingL-1, 'nodelay');
        dist_weight = [linspace(0, 1,floor(movingL/2)), 0, linspace(0, 1, floor(movingL/2))]';
        dist_coef_weights = ((exp(y)-1)'*dist_weight)./((sum(dist_weight)));
        dist_coef_weights = dist_coef_weights(:)';
        features_spindles.prob_spindle_moving2 = min(1, (features_spindles.prob_spindle + dist_coef_weights));
%         features_spindles.prob_spindle_moving2 = max(features_spindles.prob_spindle_moving2, (moving(features_spindles.prob_spindle_moving2, round(movingL/2),@mean))');
        features_spindles.prob_spindle_moving2 = max(features_spindles.prob_spindle_moving2, (moving_mean(features_spindles.prob_spindle_moving2, round(movingL/2)))');

    otherwise
        disp('Currently only supporting my two FHN paper algorithms a7 and a8');
end

%% determine spindle candidates
[spindle_candidates] = find(features_spindles.prob_spindle_moving2 > proba_threshold)+0;

begins = []; ends = [];
if(spindle_candidates~=0)
    % Now, find successive differences of spindle prob candidates
    d = [0, abs(diff(spindle_candidates))]; cp = find(d>1);
    clear begins ends
    begins = [spindle_candidates(1), spindle_candidates(cp)]; % possible starts of the sleep spindles
    ends = [spindle_candidates(cp-1), spindle_candidates(end)]; % possible ends of the sleep spindles
end

%% check if we can group spindles together

cand_spindle_dur = abs(begins - ends); kill_cands1 = cand_spindle_dur<0.03*fs;
begins(kill_cands1) = []; ends(kill_cands1) = [];

spindle_diff = begins(2:end) - ends(1:end-1); % difference between the end of the previous candidate spindle with the onset of the following one
group_spindles = find(spindle_diff<=0.1*fs); 
begins(group_spindles+1) = []; ends(group_spindles) = []; % group candidates with difference<10msec

% Now attempt to group candidate spindles which have a gap further apart but where the candidate spindles before and after appear to be "strong"
if(length(begins)>=2)  
    spindle_diff2 = begins(2:end) - ends(1:end-1); % difference between the end of the previous candidate spindle with the onset of the following one
    cand_spindle_dur = abs(begins - ends); % duration of candidate spindles
    duration_flag = (cand_spindle_dur(1:end-1)>0.1*fs & cand_spindle_dur(2:end)>0.3*fs) | (cand_spindle_dur(2:end)>0.1*fs & cand_spindle_dur(1:end-1)>0.3*fs); % flag "long" candidate spindles
    duration_flag_moderate = (cand_spindle_dur(1:end-1)>0.1*fs & cand_spindle_dur(2:end)>0.2*fs) | (cand_spindle_dur(2:end)>0.1*fs & cand_spindle_dur(1:end-1)>0.2*fs); % flag "long" candidate spindles
        
    % If the spindle candidates are long; do NOT merge
    duration_flagNO = (cand_spindle_dur(1:end-1) + cand_spindle_dur(2:end)> (max_spindle_duration*fs)); % flag for independent candidate spindles -- no merging
    duration_flag = (duration_flag & ~duration_flagNO); duration_flag_moderate = (duration_flag_moderate & ~duration_flagNO); 
    
    % if we have two "strong" spindle candidates
    for j = 1:length(begins)-1
        strength_flag(j) = mean(features_spindles.prob_spindle_moving2(begins(j):ends(j)))>0.7 & mean(features_spindles.prob_spindle_moving2(begins(j+1):ends(j+1)))>0.7; % flag "strong" candidate spindles
        strength_flag_moderate(j) = mean(features_spindles.prob_spindle_moving2(begins(j):ends(j)))>0.6 & mean(features_spindles.prob_spindle_moving2(begins(j+1):ends(j+1)))>0.6; % flag "strong" candidate spindles
    end
    group_spindles2 = find(spindle_diff2 <= 0.3*fs & ((duration_flag & strength_flag_moderate) | (strength_flag & duration_flag_moderate))); % group candidates = f(strength of candidates before and after)
    begins(group_spindles2+1) = []; ends(group_spindles2) = [];
end

%% Now finalize spindle detection and characteristics
cand_spindle_dur = abs(begins - ends); % duration of candidate spindles
kill_cand_spindles = find(cand_spindle_dur<min_spindle_duration*fs);
begins(kill_cand_spindles) = []; ends(kill_cand_spindles) = [];

% extract requested spindle characteristics
for i = 1:length(begins)
    detected_spindles{i}.spindle_idx = i;
    detected_spindles{i}.spindle_duration_samples = round(ends(i)./Kfs - begins(i)./Kfs)+1;
    detected_spindles{i}.spindle_duration_sec = detected_spindles{i}.spindle_duration_samples/fs_original;
    detected_spindles{i}.sample_strength = mean(features_spindles.prob_spindle(begins(i):ends(i)));
    detected_spindles{i}.prob_spindle = mean(features_spindles.prob_spindle_moving2(begins(i):ends(i)));
end
 
spindles_start_end = [begins(:), ends(:)]./Kfs;

end % end of main function


function y = moving_mean(x,L)

X = buffer([NaN(1, floor(L/2)), x(:)', NaN(1, floor(L/2))], L, L-1, 'nodelay');
y = nanmean(X); y(length(x)+1:end) = []; y=y';

end
