% PcaLFPonDown
% 19.10.2017 KJ
%
% New detector of down states from LFP
%
%
%


clear

%params
window_before = 0.05E4; %50ms
window_after = 0.15E4; %150ms
nb_points = 50;
with_duration = 1;

channels = [32 34 36 38 58 59 60 61 62 63]; 
depth = {'deep','deep','deep','deep','deep','sup','deep','deep','deep','sup'};

%% Load data

%LFP
for i=1:length(channels)
    ch = channels(i);
    eval(['load LFPData/LFP',num2str(ch)])
    PFC{i} = LFP;
    clear LFP
end

%StateEpoch
load StateEpochSB SWSEpoch


%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
Down = and(Down,SWSEpoch);
down_durations = End(Down) - Start(Down);
Down_large = intervalSet(Start(Down) - window_before, End(Down) + window_after); 

%detected events for training
start_evt = Start(Down_large);
end_evt = End(Down_large);
center_evt = (Start(Down_large) + End(Down_large)) / 2;
duration_evt = End(Down_large) - Start(Down_large);


%% normalize
func_uniformize = @(a) signalEpochNormalize(a, nb_points, with_duration);
[norm_signals, duration, ~] = functionOnEpochs(PFC{end}, Down, func_uniformize, 'uniformoutput',false);
norm_signals = cell2mat(norm_signals)';

%% pca
[coeff,score,latent,tsquared,explained,mu] = pca(norm_signals);
newspace_down = [tsquared(:,1:4) down_durations];

%% clustering
obj = fitgmdist(newspace_down,5);


%% plot
scattersize = 10;

figure, hold on
scatter(newspace_down(:,5),newspace_down(:,4),10,'.'), hold on






