% PredictorDownLFP
% 18.10.2017 KJ
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
start_down = Start(Down);
end_down = End(Down);




