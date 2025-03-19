% QuantifStimImpactSlowWaveDetectionPlot
% 16.05.2017 KJ
%
% quantify the detections of slow wave - STIM IMPACT
%   -> plot
%
%   see 
%       QuantifStimImpactSlowWaveDetection 
%

%load 
clear
load(fullfile(FolderStimImpactData, 'QuantifStimImpactSlowWaveDetection.mat'))


nb_multi = [];
nb_adhoc = [];

for p=1:length(detect_res.filename)
    nb_multi = [nb_multi ; length(detect_res.multi.start{p})];
    nb_adhoc = [nb_adhoc ; length(detect_res.adhoc.start{p})];

end


%% Plot
border = 3500;

figure, hold on
scatter(nb_adhoc, nb_multi, 25, 'filled')
plot(0:1:border,0:1:border, 'color', [0.7 0.7 0.7]), 
set(gca, 'xlim', [0 border], 'ylim', [0 border]),
xlabel('number of adhoc'), ylabel('number of multi'),


