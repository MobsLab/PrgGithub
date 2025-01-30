% sleepScoringComparison
%   This script compares the sleep scoring given by:
%   - the LFP
%   - the video tracking
%   - the actimetry
%
% developed for the ProjetSLEEPcontrol-Antoine project
% by antoine.delhomme@espci.fr
%

%% generate figure interface
FigActi=figure('color',[1 1 1],'units','normalized','position',[0.1 0.08 0.5 0.7]);

%% SleepScoringAD actimetry 

% Load the activity file
%   15/05/2015 --> 26, 3
%   21/05/2015 --> 32, 3
%   4/06/2015 --> 34, 5
a = Activity_old(26, 3);

% Update the activity with the last version of GetActivity
fprintf('[Activity] Update activity\n');
[sc_acti_raw] = a.applyForEachGroup(@GetActivity2, 0);
a.activity = sc_acti_raw;
% Do the sleep scoring on it
fprintf('[Activity] Do the sleepscoring\n');
[sc_acti, t_acti] = a.computeSleepScoring();

%%
% Set acti and timestamps to the right dimensions
t_acti = [t_acti(1) - 3; t_acti(1) - 2; t_acti(1) - 1; t_acti];
t_acti = t_acti - t_acti(1);

sc_acti = [0, 0, 0, sc_acti]';

xl=[0 max(t_acti)];

subplot(3, 1, 3),
    %plot(a.timeStamps_sign - a.timeStamps_sign(1), a.data, 'b');
    plot(t_acti, sc_acti, '-r', 'Linewidth', 1.2);
xlim(xl);
ylim([-1.5, 1.5]);
title('Actimetry scoringAD (movements frequency)')

%% StateEpoch, movements and epochs
clear REMEpoch SWSEpoch
load StateEpoch REMEpoch SWSEpoch
sc_video=ones(size(t_acti));
for si=1:length(Start(SWSEpoch))
    sc_video(t_acti>=Start(subset(SWSEpoch,si),'s') & t_acti<Stop(subset(SWSEpoch,si),'s'))=-1;
end
for si=1:length(Start(REMEpoch))
    sc_video(t_acti>=Start(subset(REMEpoch,si),'s') & t_acti<Stop(subset(REMEpoch,si),'s'))=-1;
end

subplot(3, 1, 1)
plot(t_acti,sc_video,'-r','Linewidth',1.2); xlim(xl);
ylim([-1.5, 1.5]);
title('SleepscoringML  (Movements from videotracking)')

%% StateEpochSB, epochs
clear REMEpoch SWSEpoch
% load B_High_Spectrum Spectro
load StateEpochSB REMEpoch SWSEpoch
subplot(3,1,2)

sc_spectro=ones(size(t_acti));
for si=1:length(Start(SWSEpoch))
    sc_spectro(t_acti>=Start(subset(SWSEpoch,si),'s') & t_acti<Stop(subset(SWSEpoch,si),'s'))=-1;
end
for si=1:length(Start(REMEpoch))
    sc_spectro(t_acti>=Start(subset(REMEpoch,si),'s') & t_acti<Stop(subset(REMEpoch,si),'s'))=-1;
end

plot(t_acti,sc_spectro,'-r','Linewidth',1.2); xlim(xl);
ylim([-1.5, 1.5]);
title('SleepscoringSB  (sum gamma spectro from Bulb)')



%% Do the comparison

% do
fprintf('=== sleep comparison on %d s (%.1f h) ===\n', length(sc_acti), length(sc_acti)/3600);
fprintf('video vs. acti: %.2f\n', mean(sc_video ==  sc_acti));
fprintf('spectro vs. acti: %.2f\n', mean(sc_spectro == sc_acti));
fprintf('video vs. spectro: %.2f\n', mean(sc_spectro == sc_video));
fprintf('---\n');
fprintf('EEphi = sleeping, acti: %.2f on %.1f h (%.2f) of sleep\n', ...
    sum((sc_spectro == -1) .* (sc_acti == -1)) / sum(sc_spectro == -1), ...
    sum(sc_spectro == -1)/3600, ...
    mean(sc_spectro == -1));
fprintf('EEphi = moving,   acti: %.2f on %.1f h (%.2f) of movement\n', ...
    sum((sc_spectro ==  1) .* (sc_acti ==  1)) / sum(sc_spectro ==  1),...
    sum(sc_spectro == 1)/3600, ...
    mean(sc_spectro == 1));
fprintf('===\n');
